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
from users.permissions import IsOperator

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