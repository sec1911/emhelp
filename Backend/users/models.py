from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import ugettext_lazy as _
from .managers import CustomUserManager

class User(AbstractUser):

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