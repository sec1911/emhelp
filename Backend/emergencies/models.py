from django.db import models
from django.conf import settings
from django.utils.translation import ugettext_lazy as _

class EmergencyRequest(models.Model):

    FIREFIGHTER = 'firefighter'
    MEDIC = 'medic'
    POLICE = 'police'

    UNIT_TYPE_CHOICES = (
        (FIREFIGHTER, 'firefighter'),
        (MEDIC, 'medic'),
        (POLICE, 'police'),
    )

    date_created = models.DateTimeField(auto_now_add=True)
    opened_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    is_active = models.BooleanField(default=True, null=False)
    action_taken = models.BooleanField(default=False, null=False)
    voice_recording = models.FileField(blank=True, null=True, upload_to='recordings/')
    longitude = models.DecimalField(max_digits=22, decimal_places=16, blank=False, null=False)
    latitude = models.DecimalField(max_digits=22, decimal_places=16, blank=False, null=False)
    incident_type = models.CharField(max_length=30, blank=False, null=False)
    message = models.TextField(blank=True, null=False)
    unit_type = models.CharField(max_length = 15, choices=UNIT_TYPE_CHOICES, default=POLICE, blank=False, null=False)