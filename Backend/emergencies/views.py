from django.shortcuts import render, get_object_or_404
from django.conf import settings

from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAdminUser, IsAuthenticated
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser

from .serializers import EmergencyRequestPostSerializer, EmergencyRequestSerializer
from .models import EmergencyRequest
from users.permissions import IsOperator, HasRole
from users.models import User

class SubmitEmergencyView(viewsets.ModelViewSet):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    parser_classes = (MultiPartParser, FormParser)
    serializer_class = EmergencyRequestPostSerializer
    queryset = EmergencyRequest.objects.all()

class EmergencyListView(viewsets.ViewSet):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsOperator]

    def list_inactive(self, request):
        serializer = EmergencyRequestSerializer(EmergencyRequest.objects.filter(is_active=False), many=True)
        return Response(serializer.data)
    
    def list_active(self, request):
        serializer = EmergencyRequestSerializer(EmergencyRequest.objects.filter(is_active=True), many=True)
        return Response(serializer.data)

class AssignUnitsView(APIView):
    """
    Assignment endpoint for assigning unit(s) to a certain Emergency Request
    Takes unit ids as comma-seperated strings and assigns them to the Emergency

    Accepts POST parameter: "unit_ids" as a string that contains unit ids comma seperated such that:
    {
        "unit_ids": "42,5,13"
    }

    Returns:
    Emergency Request object with status code 200 if successful
    Not found error with code 404 if one or more unit ids or emergency request id is invalid
    Not authorized response with status code 401 if user making the request is not Operator
    Bad request error with status code 201 if "unit_ids" are not specified.
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsOperator]

    def post(self, request, emergency_id):
        emergency_object = get_object_or_404(EmergencyRequest, pk=emergency_id)
        unit_ids = self.request.data.get('unit_ids', None)

        if unit_ids is not None:
            unit_ids = [int(x) for x in unit_ids.split(',')]
            for i in unit_ids:
                unit = get_object_or_404(User, pk=i)
                emergency_object.assigned_units.add(unit)
            return Response(EmergencyRequestSerializer(emergency_object).data)
        else:
            return Response({"unit_ids": "This field is required."}, status=201)

class UnitAssignedEmergencyListView(viewsets.ViewSet):
    authentication_classes = [TokenAuthentication]
    permission_classes = [HasRole]

    def list_inactive(self, request):
        unit = get_object_or_404(User, pk=request.user.id)
        serializer = EmergencyRequestSerializer(unit.assigned_emergencies.filter(is_active=False), many=True)
        return Response(serializer.data)
    
    def list_active(self, request):
        unit = get_object_or_404(User, pk=request.user.id)
        serializer = EmergencyRequestSerializer(unit.assigned_emergencies.filter(is_active=True), many=True)
        return Response(serializer.data)