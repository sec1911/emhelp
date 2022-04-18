from rest_framework import serializers
from dj_rest_auth.registration.serializers import RegisterSerializer
from dj_rest_auth.serializers import LoginSerializer
from rest_framework import exceptions, serializers
from django.utils.translation import gettext_lazy as _
from .models import User, UnitLocation
from .adapters import UnitAccountAdapter
from django.core.exceptions import ValidationError as DjValidationError
from allauth.account.utils import setup_user_email

class UnitLocationSerializer(serializers.ModelSerializer):

    class Meta:
        model = UnitLocation
        fields = "__all__"
        extra_kwargs = {
            'longitude': {'required': True},
            'latitude': {'required': True},
            'unit': {'required': True}
        }

class UnitRegisterSerializer(RegisterSerializer):
    username = None
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    social_security_number= serializers.CharField(required=True)
    user_role = serializers.ChoiceField(required=True, choices=User.USER_ROLE_CHOICES)
    longitude = serializers.DecimalField(required=True, max_digits=22, decimal_places=16)
    latitude = serializers.DecimalField(required=True, max_digits=22, decimal_places=16)
    phone_number = serializers.CharField(required=True)

    def validate_phone_number(self, pn):
        validator = User.phone_regex
        try:
            validator(pn)
        except DjValidationError:
            raise serializers.ValidationError(_(validator.message))
        return pn

    def validate_social_security_number(self, ssn):
        validator = User.ssn_regex
        try:
            validator(ssn)
        except DjValidationError:
            raise serializers.ValidationError(_(validator.message))
        return ssn

    def get_cleaned_data(self):
        return {
            'password1': self.validated_data.get('password1', ''),
            'email': self.validated_data.get('email', ''),
            'first_name': self.validated_data.get('first_name', ''),
            'last_name': self.validated_data.get('last_name', ''),
            'social_security_number': self.validated_data.get('social_security_number', ''),
            'user_role': self.validated_data.get('user_role', ''),
            'longitude': self.validated_data.get('longitude', ''),
            'latitude': self.validated_data.get('latitude', ''),
            'phone_number': self.validated_data.get('phone_number', '')
        }
    
    def save(self, request):
        adapter = UnitAccountAdapter(None)
        user = adapter.new_user(request)
        self.cleaned_data = self.get_cleaned_data()
        longitude_ = self.cleaned_data.pop("longitude")
        latitude_ = self.cleaned_data.pop("latitude")
        user = adapter.save_user(request, user, self)

        if "password1" in self.cleaned_data:
            try:
                adapter.clean_password(self.cleaned_data['password1'], user=user)
            except DjValidationError as exception:
                raise serializers.ValidationError(detail=serializers.as_serializer_error(exception))
        user.save()
        setup_user_email(request, user, [])
        unit_loc_obj = UnitLocation.objects.create(unit=user, longitude=longitude_, latitude=latitude_)
        # unit_loc_ser = UnitLocationSerializer(unit=user, longitude=longitude_, latitude=latitude_)
        # if unit_loc_ser.is_valid():
        #     unit_loc_ser.save()
        return user

class CustomRegisterSerializer(RegisterSerializer):
    username = None
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    social_security_number= serializers.CharField(required=True)
    blood_type = serializers.CharField(required=True)
    date_of_birth = serializers.DateField(required=True)
    phone_number = serializers.CharField(required=True)

    def validate_phone_number(self, pn):
        validator = User.phone_regex
        try:
            validator(pn)
        except DjValidationError:
            raise serializers.ValidationError(_(validator.message))
        return pn


    def validate_social_security_number(self, ssn):
        validator = User.ssn_regex
        try:
            validator(ssn)
        except DjValidationError:
            raise serializers.ValidationError(_(validator.message))
        return ssn

    def get_cleaned_data(self):
        return {
            'password1': self.validated_data.get('password1', ''),
            'email': self.validated_data.get('email', ''),
            'first_name': self.validated_data.get('first_name', ''),
            'last_name': self.validated_data.get('last_name', ''),
            'social_security_number': self.validated_data.get('social_security_number', ''),
            'blood_type': self.validated_data.get('blood_type', ''),
            'date_of_birth': self.validated_data.get('date_of_birth', ''),
            'phone_number': self.validated_data.get('phone_number', )
        }
class UnapprovedUserSerializer(serializers.ModelSerializer):
    full_name = serializers.ReadOnlyField() #full_name is property of user
    wants_to_be = serializers.ReadOnlyField(source='user_role')
    
    class Meta:
        model = User
        fields = ['id', 'email', 'social_security_number', 'full_name', 'wants_to_be']
        read_only_fields = ['id', 'email', 'social_security_number', 'full_name', 'wants_to_be']

class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ["email", "first_name", "last_name", "date_of_birth", "blood_type", 
        "special_conditions", "medications", "social_security_number", "last_login", "user_role", "phone_number"]

class OperatorCustomLoginSerializer(LoginSerializer):

    ## Overrides LoginSerializer's validate_auth_user_status()
    @staticmethod
    def validate_auth_user_status(user):
        if not user.is_active:
            msg = _('Your account is disabled.')
            raise exceptions.ValidationError(msg)
        if not user.isApproved:
            msg = _('Your account has not been approved by the operators yet. Try again later.')
            raise exceptions.ValidationError(msg)
        if not user.is_operator():
            msg = _('Unable to login since you do not have role (Operator).')
            raise exceptions.ValidationError(msg)



class CustomLoginSerializer(LoginSerializer):
    
    ## Overrides LoginSerializer's validate_auth_user_status()
    @staticmethod
    def validate_auth_user_status(user):
        if not user.is_active:
            msg = _('Your account is disabled.')
            raise exceptions.ValidationError(msg)
        if not user.isApproved:
            msg = _('Your account has not been approved by operators yet. Try again later.')
            raise exceptions.ValidationError(msg)

class UserRelatedField(serializers.RelatedField):
    def to_representation(self, user):
        try:
            return({
                'id': user.id,
                'name': f'{user.first_name} {user.last_name} ({user.phone_number})',
            })
        except:
            return 'Error: User not found. Account may be deleted.'

class UnitSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ["email", "first_name", "last_name", "user_role", "phone_number"]

class UnitLocationSerializer(UnitLocationSerializer):
    unit = UnitSerializer()