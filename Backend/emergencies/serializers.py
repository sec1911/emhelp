from rest_framework import serializers
from django.conf import settings
from .models import EmergencyRequest
from users.serializers import UserRelatedField

class EmergencyRequestPostSerializer(serializers.ModelSerializer):
    
    def create(self, validated_data):
        validated_data['opened_by'] = self.context['request'].user
        return EmergencyRequest.objects.create(**validated_data)

    class Meta:
        model = EmergencyRequest
        fields = "__all__"
        read_only_fields = ['id', 'date_created', 'opened_by', 'is_active', 'action_taken', 'assigned_units']
        extra_kwargs = {
            'longitude': {'required': True},
            'altitude': {'required': True},
            'incident_type': {'required': True},
            'message': {'required': True},
            'unit_type': {'required': True},
        }

class EmergencyRequestSerializer(serializers.ModelSerializer):
    opened_by = UserRelatedField(read_only=True)
    assigned_units = UserRelatedField(read_only=True, many=True)
    seeker_blood_type = serializers.CharField(source='opened_by.blood_type')
    seeker_conditions = serializers.CharField(source='opened_by.special_conditions')
    seeker_medications = serializers.CharField(source='opened_by.medications')

    class Meta:
        model = EmergencyRequest
        fields = "__all__"