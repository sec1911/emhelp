from django.shortcuts import render, get_object_or_404
from django.conf import settings
from django.db.models import Q

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
from users.serializers import UserSerializer

class SubmitEmergencyView(viewsets.ModelViewSet):
    """
    Endpoint for submitting new Emergencies by normal users.

    Takes unit ids as comma-seperated strings and assigns them to the Emergency

    Accepts POST parameter:
    Send a bad request (empty json) to learn the parameters and constraints (see the explanation of Unit register endpoint to understand how field errors are returned).

    Returns:
    Emergency Request object as JSON object with status code 200 if successful.
    Not authorized response with status code 401 if not a valid token is in the headers.
    Bad request error with status code 400 with field errors response (see the explanation of Unit register endpoint to understand how field errors are returned).
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    parser_classes = (MultiPartParser, FormParser)
    serializer_class = EmergencyRequestPostSerializer
    queryset = EmergencyRequest.objects.all()

class EmergencyListView(viewsets.ViewSet):
    """
    Endpoint for listing Emergencies, only users with role Operator can use this endpoint.

    Accepts no parameters, request type: GET

    <BASE_URL>/emergencies/list-inactive will return inactive (closed) emergencies
    <BASE_URL>/emergencies/list-active   will return active (ongoing) emergencies
    Note: "action_taken" field represents if any units are assigned to that emergency or not.
    
    Returns:
    JSON array of Emergency Request objects with status code 200 if successful.
    Not authorized response with status code 401 if user token with role "Operator" is not in the headers.
    """
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
    Bad request error with status code 400 if "unit_ids" are not specified.
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
            return Response({"unit_ids": "This field is required."}, status=400)

class UnitAssignedEmergencyListView(viewsets.ViewSet):
    """
    Endpoint for listing Emergencies which belongs to a certain unit, only users that are "Unit"s can use this endpoint.

    Accepts no parameters, request type: GET

    <BASE_URL>/units/list-inactive-assigned will return inactive (closed) emergencies
    <BASE_URL>/units/list-active-assigned   will return active (ongoing) emergencies
    
    Returns:
    JSON array of Emergency Request objects with status code 200 if successful.
    Not authorized response with status code 401 if requesting user is not a Unit (user is determined by the token in the header).
    """
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

class EmergencyClosedView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [HasRole]

    def post(self, request, emergency_id):
        emergency_object = get_object_or_404(EmergencyRequest, pk=emergency_id)
        emergency_object.is_active = False
        emergency_object.save()
        serializer = EmergencyRequestSerializer(emergency_object)
        return Response(serializer.data)

class SuggestUnitView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsOperator]

    def get(self, request, emergency_id):
        pass

class GetStatisticsView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsOperator]

    def get(self, request):
        pass
    