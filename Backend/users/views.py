from django.shortcuts import render, get_object_or_404
from django.conf import settings
from django.db.models import Q

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
                        UnapprovedUserSerializer,
                        UnitLocationSerializer
)
from dj_rest_auth.views import LoginView as DRA_LoginView
from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.views import RegisterView
from dj_rest_auth.app_settings import  TokenSerializer, create_token
from django.utils.translation import gettext_lazy as _
from .models import User, UnitLocation


class UnapprovedUnitsView(APIView):
    """
    Endpoint for retrieving current unapproved units in a JSON array so approving units can be done using provided ids in the future.
    Only users with role Operator can use this endpoint, so token in the request header must belong to some Operator.
    
    Accepts no parameters, request type: GET
    Returns:
    Not authorized response with status code 401 if user making the request is not Operator.
    Returns JSON array of unapproved unit registries if owner of the token has permission (is Operator?) with status code 200.

    Example response body (JSON array):
    [
        {
            "id": 22,
            "email": "kanguru1413@hotmail.com",
            "social_security_number": "1535113315",
            "wants_to_be": "medic"
        },
        {
            "id": 23,
            "email": "kanguru44443@hotmail.com",
            "social_security_number": "1535113315",
            "wants_to_be": "police"
        }
    ]
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsOperator]
    
    def get(self, request):
        serializer = UnapprovedUserSerializer(User.objects.filter(isApproved=False), many=True)
        return Response(serializer.data)

class UnitApproveView(APIView):
    """
    Note : After Unit registration, units must be approved by the operators to log in.
    Endpoint for approving pending unapproved unit registrations by their id, id can be specified by the url.
    Only users with role Operator can use this endpoint, so token in the request header must belong to some Operator.

    Accepts no parameters, request type: POST
    POST request with Operator token in headers to : <BASE_URL>/users/approve-unit/<int:user_id>
    Example POST request to approve Unit registartion with id 5: <BASE_URL>/users/approve-unit/5

    Returns:
    Account succesfully approved message with status code 200.
    User is not found message with status code 404, if user does not exist with the id given in the url.
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
    """
    Note : After Unit registration, units must be approved by some Operator user to log in.
    Endpoint used to do Unit registration. Unit location (which does not change) is also given in this step. 
    There is four choices for "user_role" parameter which are "operator", "firefighter", "medic", "police"

    Accepts POST parameters:
    Send a bad request (empty json) to learn the parameters and constraints. See the example below.

    Returns:
    Your submission is saved, you can login after we approve your account message with status code 200 if registration was succesful.
    Bad request response with according field errors with status code 400.

    Example for bad request response:
    {
        "longitude": [
            "This field is required."
        ],
        "phone_number": [
            "Enter your phone number in format: 5xxxxxxxxx"
        ]
    }
    Explanation : Phone number is given in wrong format, also Unit's location is missing. Send bad requests to learn about parameters.
    Also, if passwords don't match, bad request response with field errors such as above will return.
    """
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
    """
    Endpoint for retrieving User's information as JSON.
    Finds the user using Authorization Token in the request header and returns User information in a JSON body.

    Accepts no parameters, request type: GET
    Returns: 
    User information JSON with status code 200
    Error if user is not found with the token with status code 404
    """
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
    Returns: 
    A Token with "key" JSON parameter for future authentication, status code 200
    Bad request response with field errors provided, status code 400
    
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

class UpdateUserView(APIView):
    """
    Endpoint for updating User's information such as blood type etc.
    Finds the user using Authorization Token in the request header and updates the fields given in the request body.

    Examples:

    1- Post request with body that ought to be change only two fields:
    {
        "date_of_birth": "1994-04-04",
        "blood_type": "A rh+"
    }

    2 - Request with body to change medications:
    {
        "medications": "Fluticasone, Cortisone"
    }

    Accepts the following POST parameters: all fields of User (and unit) object. 
    Returns the updated User (or Unit) JSON with all it's fields with status code 200 if request is successful.
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        user = request.user
        serializer = UserSerializer(user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)

class ListAllUnitsView(APIView):
    """
    Endpoint for listing all units with their coordinates, see the note below.

    Accepts no parameters, request type: GET

    Returns:
    Not authorized response with status code 401 if user making the request is not Operator.
    Returns JSON array of units with their coordinates if owner of the token has permission (is Operator?) with status code 200.
    Note: Units must be registered with unit-register endpoint. 
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsOperator]

    def get(self, request):
        unit_locations = UnitLocation.objects.all()
        serializer = UnitLocationSerializer(unit_locations, many=True)
        return Response(serializer.data)