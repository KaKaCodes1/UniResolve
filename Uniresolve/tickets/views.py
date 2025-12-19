from .serializers import TicketSerializer, ResolutionSerializer
from rest_framework import viewsets, permissions, serializers
from .models import Ticket, Resolution


# Create your views here.
class TicketViewSet(viewsets.ModelViewSet):
    queryset = Ticket.objects.all()
    serializer_class = TicketSerializer
    permission_classes =[permissions.IsAuthenticated]

    #connects a ticket to a logged in user
    def perform_create(self, serializer):
        #Check if the user is a student first
        if self.request.user.role != 'Student':
            raise serializers.ValidationError("Only students are allowed to raise tickets")
        
        #preventing impersonation, a ticket is associated with the person logged in
        serializer.save(owner= self.request.user)
