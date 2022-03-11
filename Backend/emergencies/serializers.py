from rest_framework import serializers
from django.conf import settings
from .models import EmergencyRequest

class EmergencyRequestPostSerializer(serializers.ModelSerializer):
    
    def create(self, validated_data):
        validated_data['opened_by'] = self.context['request'].user
        return EmergencyRequest.objects.create(**validated_data)

    class Meta:
        model = EmergencyRequest
        fields = "__all__"
        read_only_fields = ['id', 'date_created', 'opened_by', 'is_active', 'action_taken']
        extra_kwargs = {
            'longitude': {'required': True},
            'altitude': {'required': True},
            'incident_type': {'required': True},
            'message': {'required': True},
        }