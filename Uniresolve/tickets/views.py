from .serializers import TicketSerializer, ResolutionSerializer
from rest_framework import viewsets, permissions, serializers
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Ticket, Resolution
from django.db import transaction
from django.db.models import Q
from django.core.paginator import Paginator
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
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user

        if user.is_authenticated and user.role == 'Staff':
            base_template = 'tickets/base_staffdashboard.html'
        else:
            base_template = 'tickets/base_dashboard.html'
        
        context['base_template'] = base_template
        return context

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
        context['open_tickets'] = 0
        context['pending_tickets'] = 0
        context['resolved_tickets'] = 0
        context['new_tickets'] = []

        if user.is_authenticated and user.role == 'Staff':
            # Get the staff member's department
            # We assume a staff member has a 'staff_profile' with a 'department' field
            if hasattr(user, 'staff_profile') and user.staff_profile.department:
                staff_dept = user.staff_profile.department
                
                # Filter tickets that belong to categories within this department
                # Note: 'category__department' traces the relationship Ticket -> Category -> Department
                tickets = Ticket.objects.filter(category__department=staff_dept)

                # Calculate counts based on status
                context['total_tickets'] = tickets.count()
                context['open_tickets'] = tickets.filter(status='OPEN').count()
                context['pending_tickets'] = tickets.filter(status='PENDING').count()
                context['resolved_tickets'] = tickets.filter(status='RESOLVED').count()
                
                # Get "New" tickets: recent tickets with status 'OPEN'
                # Show top 5 for the initial server-side render (though we might use JS mainly)
                context['new_tickets'] = tickets.filter(status='OPEN').order_by('-created_at')[:5]
            else:
               # Handle case where staff has no profile/department
               pass 

        return context

@method_decorator(never_cache, name='dispatch')
class StaffAllIssuesPageView(TemplateView):
    template_name = 'tickets/staff_all_issues.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Staff' and hasattr(user, 'staff_profile') and user.staff_profile.department:
             # Pass categories for the dropdown filter
             staff_dept = user.staff_profile.department
             context['categories'] = Category.objects.filter(department=staff_dept)
        return context




class TicketViewSet(viewsets.ModelViewSet):
    # queryset = Ticket.objects.all()
    serializer_class = TicketSerializer
    permission_classes =[permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        #Students only see tickets they created
        if user.role == 'Student':
            return Ticket.objects.order_by('-created_at').filter(owner = user)
        
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

    @action(detail=False, methods=['get'])
    def staffdashboard_stats(self, request):
        user = request.user
        if not user.is_authenticated or user.role != 'Staff':
             return Response({'error': 'Unauthorized'}, status=403)
        
        # Ensure staff has a department
        if not hasattr(user, 'staff_profile') or not user.staff_profile.department:
             return Response({'error': 'Staff profile or department not found'}, status=400)

        staff_dept = user.staff_profile.department

        # Filter tickets by the department via the category
        tickets = Ticket.objects.filter(category__department=staff_dept)
        
        # Prepare statistics
        stats = {
            'total_tickets': tickets.count(),
            'open_tickets': tickets.filter(status='OPEN').count(),
            'pending_tickets': tickets.filter(status='PENDING').count(),
            'resolved_tickets': tickets.filter(status='RESOLVED').count(),
            # 'new_tickets' will populated the Incoming Issues Queue
            # We filter for 'OPEN' tickets and order by newest first
            'new_tickets': TicketSerializer(tickets.filter(status='OPEN').order_by('-created_at')[:5], many=True).data
        }
        return Response(stats)

    #connects a ticket to a logged in user
    def perform_create(self, serializer):
        #Check if the user is a student first
        if self.request.user.role != 'Student':
            raise serializers.ValidationError("Only students are allowed to raise tickets")
        
        #preventing impersonation, a ticket is associated with the person logged in
        serializer.save(owner= self.request.user)

    @action(detail=False, methods=['get'])
    def all_issues(self, request):
        """
        API endpoint for the "All Issues" page with search, filter, and pagination.
        This allows staff to view only department-specific tickets.
        """
        user = request.user
        
        # 1. Security Check: Only Staff members are allowed
        if not user.is_authenticated or user.role != 'Staff':
             return Response({'error': 'Unauthorized'}, status=403)

        # 2. Context Check: Staff must have a department assigned
        if not hasattr(user, 'staff_profile') or not user.staff_profile.department:
             return Response({'error': 'Staff profile/department not found'}, status=400)

        staff_dept = user.staff_profile.department
        
        # 3. Base Query: Get all tickets linked to categories in this department
        queryset = Ticket.objects.filter(category__department=staff_dept).order_by('-created_at')

        # Filtering Logic
        # If a specific status is requested (and not "All"), filter by it
        status_param = request.query_params.get('status')
        if status_param and status_param != 'All Statuses':
            queryset = queryset.filter(status=status_param.upper())

        # If a specific category ID is requested, filter by it
        category_param = request.query_params.get('category')
        if category_param and category_param != 'All Categories':
            try:
                queryset = queryset.filter(category__id=int(category_param))
            except ValueError:
                pass # Ignore invalid category ID

        # Search Logic
        # Uses Q objects to perform an "OR" search across multiple fields
        search_query = request.query_params.get('search')
        if search_query:
            queryset = queryset.filter(
                Q(id__icontains=search_query) |       # Matches Ticket ID
                Q(title__icontains=search_query) |    # Matches Title
                Q(owner__first_name__icontains=search_query) | # Matches Student First Name
                Q(owner__last_name__icontains=search_query)    # Matches Student Last Name
            )

        # --- Pagination Logic ---
        page_number = request.query_params.get('page', 1)
        page_size = 10 
        paginator = Paginator(queryset, page_size)

        try:
            page_obj = paginator.page(page_number)
        except Exception:
            page_obj = paginator.page(1) # Default to first page on error

        serializer = TicketSerializer(page_obj.object_list, many=True)
        
        # Return data including pagination metadata
        return Response({
            'tickets': serializer.data,
            'has_next': page_obj.has_next(),
            'has_previous': page_obj.has_previous(),
            'total_pages': paginator.num_pages,
            'current_page': page_obj.number,
            'total_count': paginator.count
        })

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
