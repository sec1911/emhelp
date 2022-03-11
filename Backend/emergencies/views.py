from django.shortcuts import render, get_object_or_404
from django.conf import settings

from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAdminUser, IsAuthenticated
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser

from .serializers import EmergencyRequestPostSerializer
from .models import EmergencyRequest

class SubmitEmergencyView(viewsets.ModelViewSet):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    parser_classes = (MultiPartParser, FormParser)
    serializer_class = EmergencyRequestPostSerializer
    queryset = EmergencyRequest.objects.all()