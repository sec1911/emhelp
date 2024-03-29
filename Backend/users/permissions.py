from rest_framework.permissions import BasePermission
from .models import User

class HasRole(BasePermission):
    """
    Allow access to user who has any type of role.
    """
    def has_permission(self, request, view):
        return isinstance(request.user, User) and not request.user.user_role == User.NO_ROLE

class IsOperator(BasePermission):
    """
    Permission class for checking if user is Operator or not
    """
    def has_permission(self, request, view):
        return isinstance(request.user, User) and request.user.is_operator()