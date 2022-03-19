from django.urls import path, include

from .views import SubmitEmergencyView, EmergencyListView

urlpatterns = [
    path('add', SubmitEmergencyView.as_view({'post': 'create'})),
    path('list-inactive', EmergencyListView.as_view({'get': 'list_inactive'})),
    path('list-active', EmergencyListView.as_view({'get': 'list_active'})),
]