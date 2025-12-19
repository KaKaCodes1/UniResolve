from django.urls import path, include
from .views import TicketViewSet
from rest_framework.routers import DefaultRouter

#The router will handle creating the appropriate URL patterns
#for all CRUD operations on the Ticket model.
router = DefaultRouter()
router.register(r'tickets',TicketViewSet, basename='ticket')

urlpatterns = [
    path('', include(router.urls)),
]