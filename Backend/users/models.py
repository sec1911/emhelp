from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import ugettext_lazy as _
from .managers import CustomUserManager
from django.core.validators import RegexValidator
from django.conf import settings

class User(AbstractUser):

    phone_regex = RegexValidator(regex=r'^(5)\d{9}$', message='Enter your phone number in format: 5xxxxxxxxx')
    ssn_regex = RegexValidator(regex=r'^\d{11}$', message='Enter your 11-digit social security number.')


    objects = CustomUserManager()
    username = None
    email = models.EmailField(_('email address'), unique=True)
    first_name = models.CharField(verbose_name='first_name', max_length=30)
    last_name = models.CharField(verbose_name='last_name', max_length=30)
    date_of_birth = models.DateField(blank=True, null=True)
    blood_type = models.CharField(blank=True, max_length=100)
    special_conditions = models.CharField(blank=True, max_length=100)
    medications = models.CharField(blank=True, max_length=100)
    social_security_number = models.CharField(blank=True, max_length=100)
    last_login = models.DateField(verbose_name='last login', auto_now=True)
    isApproved = models.BooleanField(default=True)
    phone_number = models.CharField(max_length=20, blank=True)

    NO_ROLE = 'none'
    OPERATOR = 'operator'
    FIREFIGHTER = 'firefighter'
    MEDIC = 'medic'
    POLICE = 'police'

    USER_ROLE_CHOICES = (
        (NO_ROLE, 'none'),
        (OPERATOR, 'operator'),
        (FIREFIGHTER, 'firefighter'),
        (MEDIC, 'medic'),
        (POLICE, 'police'),
    )

    user_role = models.CharField(max_length = 15, choices = USER_ROLE_CHOICES, default = NO_ROLE, blank=False, null=False)


    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['first_name', 'last_name', 'social_security_number', 'blood_type', 'date_of_birth']

    def is_operator(self):
        return self.user_role in {self.OPERATOR}

    def is_firefighter(self):
        return self.user_role in {self.FIREFIGHTER}

    def is_medic(self):
        return self.user_role in {self.MEDIC}

    def is_police(self):
        return self.user_role in {self.POLICE}

    def __str__(self):
        return self.email

class UnitLocation(models.Model):
    unit = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, primary_key=True)
    longitude = models.DecimalField(max_digits=22, decimal_places=16, blank=False, null=False, default=32.866287)
    latitude = models.DecimalField(max_digits=22, decimal_places=16, blank=False, null=False, default=39.925533)