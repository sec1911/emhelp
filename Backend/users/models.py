from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
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

    def is_operator(self):
        return self.user_role in {self.OPERATOR}

    def is_firefighter(self):
        return self.user_role in {self.FIREFIGHTER}

    def is_medic(self):
        return self.user_role in {self.MEDIC}

    def is_police(self):
        return self.user_role in {self.POLICE}
    