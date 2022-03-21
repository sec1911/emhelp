from django.urls import path, include

from .views import SubmitEmergencyView, EmergencyListView, AssignUnitsView

urlpatterns = [
    path('add', SubmitEmergencyView.as_view({'post': 'create'})),
    path('list-inactive', EmergencyListView.as_view({'get': 'list_inactive'})),
    path('list-active', EmergencyListView.as_view({'get': 'list_active'})),
    path('<emergency_id>/assign-units', AssignUnitsView.as_view()),
]