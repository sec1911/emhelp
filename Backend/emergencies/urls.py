from django.urls import path, include

from .views import SubmitEmergencyView

urlpatterns = [
    path('add', SubmitEmergencyView.as_view({'post': 'create'}))
]