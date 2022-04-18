from django.urls import path, include
from .views import (HelloWorldView, 
                    UserSelfDetail, 
                    OperatorLoginView, 
                    UnitRegisterView, 
                    CustomLoginView,
                    UnitApproveView,
                    UnapprovedUnitsView,
                    UpdateUserView,
                    ListAllUnitsView)

from dj_rest_auth.views import LoginView
from dj_rest_auth.registration.views import RegisterView

urlpatterns = [
    #path('admin-login', LoginView.as_view()),
    #path('', views.UserSelfDetail.as_view()),
    path('list-unapproved', UnapprovedUnitsView.as_view()),
    path('list-all-units', ListAllUnitsView.as_view()),
    path('approve-unit/<int:user_id>', UnitApproveView.as_view()),
    path('account/details', UserSelfDetail.as_view()),
    path('account/login/', CustomLoginView.as_view()),
    path('account/operator-login', OperatorLoginView.as_view()),
    path('account/unit-register', UnitRegisterView.as_view()),
    path('account/register/', RegisterView.as_view()),
    path('account/hello', HelloWorldView.as_view()),
    path('account/update', UpdateUserView.as_view())
    #path('update-role/<int:pk>', views.UpdateUserRole.as_view())
]