from rest_framework import serializers
from dj_rest_auth.registration.serializers import RegisterSerializer


class CustomRegisterSerializer(RegisterSerializer):
    username = None
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    social_security_number= serializers.CharField(required=True)
    blood_type = serializers.CharField(required=True)
    date_of_birth = serializers.DateField(required=True)

    def get_cleaned_data(self):
        return {
            'password1': self.validated_data.get('password1', ''),
            'email': self.validated_data.get('email', ''),
            'first_name': self.validated_data.get('first_name', ''),
            'last_name': self.validated_data.get('last_name', ''),
            'social_security_number': self.validated_data.get('social_security_number', ''),
            'blood_type': self.validated_data.get('blood_type', ''),
            'date_of_birth': self.validated_data.get('date_of_birth', ''),
        }