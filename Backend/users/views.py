from django.shortcuts import render, get_object_or_404
from django.conf import settings

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAdminUser, IsAuthenticated
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser

from .permissions import IsOperator
from .serializers import (
                        UserSerializer,
                        OperatorCustomLoginSerializer, 
                        UnitRegisterSerializer, 
                        CustomLoginSerializer,
                        UnapprovedUserSerializer
)
from dj_rest_auth.views import LoginView as DRA_LoginView
from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.views import RegisterView
from dj_rest_auth.app_settings import  TokenSerializer, create_token
from django.utils.translation import gettext_lazy as _
from .models import User


class UnapprovedUnitsView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsOperator]
    
    def get(self, request):
        serializer = UnapprovedUserSerializer(User.objects.filter(isApproved=False), many=True)
        return Response(serializer.data)

class UnitApproveView(APIView):
    """
    Returns 404 if user is not found.
    """
    # Get the user
    # Do the validation
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsOperator]

    def post(self, request, user_id):
        user = get_object_or_404(User, pk=user_id)
        user.isApproved = True
        user.save()
        return Response({"detail": _("Account successfully approved.")}, status=200)

class UnitRegisterView(RegisterView):
    serializer_class = UnitRegisterSerializer

    #override get_response_data of RegisterView
    def get_response_data(self, user):
            return {'detail': _('Your submission is saved, you can login after we approve your account.')}

class HelloWorldView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        user = get_object_or_404(User, pk=pk)
        return Response({"result": "Hello World!"})

class UserSelfDetail(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serialized = UserSerializer(request.user)
        return Response(serialized.data)

class OperatorLoginView(DRA_LoginView):
    """
    Check the credentials and user role to return a token if credentials
    are correct and user role is assigned as Operator.

    Accepts the following POST parameters: email, password
    Returns: A Token with "key" JSON parameter for future authentication
    """
    ## Override Login serializer with Custom serializer for Operators:
    serializer_class = OperatorCustomLoginSerializer

class CustomLoginView(DRA_LoginView):
    """
    Custom login endpoint for handling login process of both normal and unit accounts
    Checks the credentials of user, and is approved if registered user to return a access token.

    Accepts the following POST parameters: email, password
    Returns one of the following: 
    A Token with "key" JSON parameter for future authentication, with status code 200

    """
    ## Override Login serializer with Custom serializer
    serializer_class = CustomLoginSerializer
