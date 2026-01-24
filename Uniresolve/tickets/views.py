from .serializers import TicketSerializer, ResolutionSerializer
from rest_framework import viewsets, permissions, serializers
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Ticket, Resolution
from django.db import transaction
from django.views.generic import TemplateView
from organization.models import Category
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache

#Preventing page caching to prevent users from accessing pages when they logout
@method_decorator(never_cache, name='dispatch')
class SubmitIssuePageView(TemplateView):
    template_name = 'tickets/submit_issue.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['categories'] = Category.objects.all()
        return context

@method_decorator(never_cache, name='dispatch')
class ProfilePageView(TemplateView):
    template_name = 'tickets/profile.html'

@method_decorator(never_cache, name='dispatch')
class StudentDashboardPageView(TemplateView):
    template_name = 'tickets/student_dashboard.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        # Initialize default values
        context['total_tickets'] = 0
        context['open_tickets'] = 0
        context['pending_tickets'] = 0
        context['resolved_tickets'] = 0
        context['recent_tickets'] = []

        if user.is_authenticated and user.role == 'Student':
            # Get all tickets for this student
            tickets = Ticket.objects.filter(owner=user)
            
            # Calculate counts
            context['total_tickets'] = tickets.count()
            context['open_tickets'] = tickets.filter(status='OPEN').count()
            context['pending_tickets'] = tickets.filter(status='PENDING').count()
            context['resolved_tickets'] = tickets.filter(status='RESOLVED').count()
            
            # Get 3 most recent tickets
            context['recent_tickets'] = tickets.order_by('-created_at')[:3]
            
        return context

@method_decorator(never_cache, name='dispatch')
class MyHistoryPageView(TemplateView):
    template_name = 'tickets/my_history.html'

@method_decorator(never_cache, name='dispatch')
class StaffDashboardPageView(TemplateView):
    template_name = 'tickets/staff_dashboard.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        # Initialize default values
        context['total_tickets'] = 0
        context['pending_tickets'] = 0
        context['inprogress_tickets'] = 0
        context['resolved_tickets'] = 0
        context['recent_tickets'] = []

        if user.is_authenticated and user.role == 'Staff':
            # Get all tickets for this staff member
            tickets = Ticket.objects.filter(owner=user)

            # Calculate counts
            context['total_tickets'] = tickets.filter(department=user.staff_profile.department).count()
            context['pending_tickets'] = tickets.filter(department=user.staff_profile.department,status='PENDING').count()
            context['inprogress_tickets'] = tickets.filter(department=user.staff_profile.department,status='INPROGRESS').count()
            context['resolved_tickets'] = tickets.filter(department=user.staff_profile.department,status='RESOLVED').count()
            
            # Get 3 most recent tickets
            context['recent_tickets'] = tickets.order_by('-created_at')[:3]




class TicketViewSet(viewsets.ModelViewSet):
    # queryset = Ticket.objects.all()
    serializer_class = TicketSerializer
    permission_classes =[permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        #Students only see tickets they created
        if user.role == 'Student':
            return Ticket.objects.filter(owner = user)
        
        #Departmental filtering
        if user.role == 'Staff':
            staff_dept = user.staff_profile.department
            return Ticket.objects.filter(category__department = staff_dept)
        
        #Admins see all tickets
        return Ticket.objects.all()

    @action(detail=False, methods=['get'])
    def dashboard_stats(self, request):
        user = request.user
        if not user.is_authenticated or user.role != 'Student':
             return Response({'error': 'Unauthorized'}, status=403)
        
        tickets = Ticket.objects.filter(owner=user)
        
        stats = {
            'total_tickets': tickets.count(),
            'open_tickets': tickets.filter(status='OPEN').count(),
            'pending_tickets': tickets.filter(status='PENDING').count(),
            'resolved_tickets': tickets.filter(status='RESOLVED').count(),
            'recent_tickets': TicketSerializer(tickets.order_by('-created_at')[:3], many=True).data
        }
        return Response(stats)

    #connects a ticket to a logged in user
    def perform_create(self, serializer):
        #Check if the user is a student first
        if self.request.user.role != 'Student':
            raise serializers.ValidationError("Only students are allowed to raise tickets")
        
        #preventing impersonation, a ticket is associated with the person logged in
        serializer.save(owner= self.request.user)

class ResolutionViewSet(viewsets.ModelViewSet):
    queryset = Resolution.objects.all()
    serializer_class = ResolutionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        user = self.request.user

        if user.role != 'Staff':
            raise serializers.ValidationError("Only staff members can resolve tickets.")
        
        #Extract the status from the validated data (default to 'Resolved' if empty)
        #'pop' it so it doesn't try to save into the Resolution model (which doesn't have a status field)
        new_status = serializer.validated_data.pop('status', 'RESOLVED')

        with transaction.atomic(): #Either both the Resolution and the Ticket update, or neither does
            # Save the resolution record and link to the staff member
            resolution = serializer.save(resolved_by=user)

            # Access the linked ticket
            ticket = resolution.ticket
            
            #Update the linked Ticket status based on the staff's choice
            if new_status == 'PENDING':
                ticket.status = 'PENDING'
            elif new_status == 'RESOLVED':
                ticket.status = 'RESOLVED'
            else:
                print(f"WARNING! new_status '{new_status}' did not match PENDING or RESOLVED.")

            # Save the ticket
            ticket.save()
            
            # Refresh from DB to confirm it stuck
            ticket.refresh_from_db()
