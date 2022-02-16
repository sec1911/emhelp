from django.urls import path, include
from .views import HelloWorldView, UserSelfDetail
from dj_rest_auth.views import LoginView
from dj_rest_auth.registration.views import RegisterView

urlpatterns = [
    #path('admin-login', LoginView.as_view()),
    #path('', views.UserSelfDetail.as_view()),
    path('account/details', UserSelfDetail.as_view()),
    path('account/login/', LoginView.as_view()),
    path('account/register/', RegisterView.as_view()),
    path('account/hello', HelloWorldView.as_view()),
    #path('update-role/<int:pk>', views.UpdateUserRole.as_view())
]