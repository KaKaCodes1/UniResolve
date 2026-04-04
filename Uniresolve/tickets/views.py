from .serializers import TicketSerializer, ResolutionSerializer, StudentFeedbackSerializer, AdditionalInfoSerializer
from rest_framework import viewsets, permissions, serializers, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Ticket, Resolution, StudentFeedback
from django.db import transaction
from django.db.models import Q
from django.core.paginator import Paginator
from django.views.generic import TemplateView
from organization.models import Category
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from django.contrib.auth import get_user_model
from django.utils import timezone
from datetime import timedelta
from organization.models import Department
from accounts.models import Notification
from .utils.auto_escalate_util import auto_escalate_overdue_tickets, issue_deadline_warnings


#Import User model
User = get_user_model()

#Helper to broadcast a notification to all staff in a specific department.
def notify_department_staff(department, message, link):
    staff_users = User.objects.filter(staff_profile__department=department).exclude(role='Student')
    notifications = []
    for staff in staff_users:
        notifications.append(Notification(user=staff, message=message, link=link))
    if notifications:
        Notification.objects.bulk_create(notifications)

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
        
        auto_escalate_overdue_tickets()  # Evaluate overdue tickets before querying
        
        # Initialize default values
        context['total_tickets'] = 0
        context['open_tickets'] = 0
        context['pending_tickets'] = 0
        context['resolved_tickets'] = 0
        context['recent_tickets'] = []

        if user.is_authenticated and user.role == 'Student':
            # Statistics are fetched via JS API call for dynamic updates
            pass
            
        return context

@method_decorator(never_cache, name='dispatch')
class MyHistoryPageView(TemplateView):
    template_name = 'tickets/my_history.html'

@method_decorator(never_cache, name='dispatch')
class TicketDetailPageView(TemplateView):
    template_name = 'tickets/ticket_detail.html'

@method_decorator(never_cache, name='dispatch')
class StaffTicketDetailPageView(TemplateView):
    template_name = 'tickets/staff_ticket_detail.html'

@method_decorator(never_cache, name='dispatch')
class StaffDashboardPageView(TemplateView):
    template_name = 'tickets/staff_dashboard.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        auto_escalate_overdue_tickets() # Evaluate overdue tickets before querying
        issue_deadline_warnings() # Evaluate deadline warnings
        
        # Initialize default values
        context['total_tickets'] = 0
        context['open_tickets'] = 0
        context['pending_tickets'] = 0
        context['resolved_tickets'] = 0
        context['incoming_tickets'] = []

        if user.is_authenticated and user.role == 'Staff':
            # Statistics are fetched via JS API call
            pass 

        return context

@method_decorator(never_cache, name='dispatch')
class SeniorStaffDashboardPageView(TemplateView):
    template_name = 'tickets/senior_staff_dashboard.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        auto_escalate_overdue_tickets() # Evaluate overdue tickets before querying
        issue_deadline_warnings() # Evaluate deadline warnings
        
        # Initialize default values
        context['total_tickets'] = 0
        context['open_tickets'] = 0
        context['pending_tickets'] = 0
        context['resolved_tickets'] = 0
        context['escalated_tickets'] = 0
        context['incoming_tickets'] = []

        if user.is_authenticated and user.role == 'Senior Staff':
            # Statistics are fetched via JS API call
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
             context['status_choices'] = Ticket.status_choices
        return context


@method_decorator(never_cache, name='dispatch')
class AllResolutionsPageView(TemplateView):
    template_name = 'tickets/all_resolutions.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Staff' and hasattr(user, 'staff_profile') and user.staff_profile.department:
             # Pass staff members for the dropdown filter
             staff_dept = user.staff_profile.department
             # Assuming we can find other staff by filtering profiles linked to this dept
             # If `StaffProfile` has `department`, we can query User where staff_profile__department=staff_dept
             context['staff_members'] = User.objects.filter(staff_profile__department=staff_dept, role='Staff')
             context['status_choices'] = Ticket.status_choices
             
        return context

class TicketViewSet(viewsets.ModelViewSet):
    # queryset = Ticket.objects.all()
    serializer_class = TicketSerializer
    permission_classes =[permissions.IsAuthenticated]

    def get_queryset(self):
        auto_escalate_overdue_tickets() # Evaluate overdue tickets before querying
        issue_deadline_warnings() # Evaluate deadline warnings
        user = self.request.user

        #Students only see tickets they created
        if user.role == 'Student':
            return Ticket.objects.order_by('-created_at').filter(owner = user)
        
        #Departmental filtering
        if user.role == 'Staff':
            staff_dept = user.staff_profile.department
            staff_role = user.staff_profile.staff_role

            base_query = Ticket.objects.filter(current_department=staff_dept)

            if staff_role == 'STAFF':
                # Normal staff only see unescalated tickets
                return base_query.filter(is_escalated=False)
            elif staff_role == 'SENIOR':
                # Seniors see everything in their department (or filter specific to escalated if preferred)
                return base_query
        
        #Admins see all tickets
        return Ticket.objects.all()

    @action(detail=False, methods=['get'])
    def dashboard_stats(self, request):
        auto_escalate_overdue_tickets() # Evaluate overdue tickets before querying
        issue_deadline_warnings() # Evaluate deadline warnings
        user = request.user
        if not user.is_authenticated or user.role != 'Student':
             return Response({'error': 'Unauthorized'}, status=403)
        
        tickets = Ticket.objects.filter(owner=user)
        
        stats = {
            'total_tickets': tickets.count(),
            'open_tickets': tickets.filter(status='OPEN').count(),
            'pending_tickets': tickets.filter(status='PENDING').count(),
            'resolved_tickets': tickets.filter(status='RESOLVED').count(),
            'recent_tickets': TicketSerializer(tickets.order_by('-created_at')[:5], many=True).data
        }
        return Response(stats)

    @action(detail=False, methods=['get'])
    def staffdashboard_stats(self, request):
        auto_escalate_overdue_tickets() # Evaluate overdue tickets before querying
        issue_deadline_warnings() # Evaluate deadline warnings
        user = request.user
        if not user.is_authenticated or user.role != 'Staff':
             return Response({'error': 'Unauthorized'}, status=403)
        
        # Ensure staff has a department
        if not hasattr(user, 'staff_profile') or not user.staff_profile.department:
             return Response({'error': 'Staff profile or department not found'}, status=400)

        staff_dept = user.staff_profile.department

        # Filter tickets by the department's current queue
        tickets = Ticket.objects.filter(current_department=staff_dept)

        # Enforce visibility rules based on seniority
        if user.staff_profile.staff_role == 'STAFF':
            tickets = tickets.filter(is_escalated=False)
        
        # Prepare statistics
        stats = {
            'total_tickets': tickets.count(),
            'open_tickets': tickets.filter(status='OPEN').count(),
            'pending_tickets': tickets.filter(status='PENDING').count(),
            'resolved_tickets': tickets.filter(status='RESOLVED').count(),
            'incoming_tickets': TicketSerializer(tickets.exclude(status__in=['RESOLVED', 'CLOSED','REJECTED']).order_by('-created_at')[:5], many=True).data
        }
        return Response(stats)

    @action(detail=False, methods=['get'])
    def seniorstaffdashboard_stats(self, request):
        auto_escalate_overdue_tickets() # Evaluate overdue tickets before querying
        issue_deadline_warnings() # Evaluate deadline warnings
        user = request.user
        if not user.is_authenticated or user.role != 'Staff':
             return Response({'error': 'Unauthorized'}, status=403)
        
        if not hasattr(user, 'staff_profile') or not user.staff_profile.department or user.staff_profile.staff_role != 'SENIOR':
             return Response({'error': 'Unauthorized. Senior Staff access required.'}, status=403)

        staff_dept = user.staff_profile.department
        tickets = Ticket.objects.filter(current_department=staff_dept)

        stats = {
            'total_tickets': tickets.count(),
            'open_tickets': tickets.filter(status='OPEN').count(),
            'pending_tickets': tickets.filter(status='PENDING').count(),
            'resolved_tickets': tickets.filter(status='RESOLVED').count(),
            'transferred_tickets': tickets.filter(status='TRANSFERRED').count(),
            'escalated_tickets': tickets.filter(status='ESCALATED').count(),
            'incoming_tickets': TicketSerializer(tickets.exclude(status__in=['RESOLVED', 'CLOSED','REJECTED']).order_by('-created_at')[:5], many=True).data
        }
        return Response(stats)

    #connects a ticket to a logged in user
    def perform_create(self, serializer):
        user = self.request.user
        
        #Check if the user is a student first
        if user.role != 'Student':
            raise serializers.ValidationError("Only students are allowed to raise tickets")
        
        category = serializer.validated_data.get('category')
        
        # Calculate dynamic due date
        due_date = timezone.now() + timedelta(hours=category.resolution_timeframe)

        # Dynamic Department Routing
        if category.is_academic:
            # Route to student's home department
            current_dept = user.student_profile.course.department
        else:
            # Route to category's regular department
            current_dept = category.department

        #preventing impersonation, a ticket is associated with the person logged in
        ticket = serializer.save(
            owner=user, 
            current_department=current_dept,
            due_date=due_date
        )

        notify_department_staff(
            department=current_dept,
            message=f'New ticket "#{ticket.id}" submitted by {user.first_name} {user.last_name}.',
            link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
        )

    @action(detail=False, methods=['get'])
    def all_issues(self, request):
        """
        API endpoint for the "All Issues" page with search, filter, and pagination.
        This allows staff to view only department-specific tickets.
        """
        auto_escalate_overdue_tickets() # Evaluate overdue tickets before querying
        issue_deadline_warnings() # Evaluate deadline warnings
        user = request.user
        
        # 1. Security Check: Only Staff members are allowed
        if not user.is_authenticated or user.role != 'Staff':
             return Response({'error': 'Unauthorized'}, status=403)

        # 2. Context Check: Staff must have a department assigned
        if not hasattr(user, 'staff_profile') or not user.staff_profile.department:
             return Response({'error': 'Staff profile/department not found'}, status=400)

        staff_dept = user.staff_profile.department
        
        # 3. Base Query: Get all tickets currently in this department's queue
        queryset = Ticket.objects.filter(current_department=staff_dept).order_by('-created_at')

        # Enforce visibility rules based on seniority
        if user.staff_profile.staff_role == 'STAFF':
            queryset = queryset.filter(is_escalated=False)

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
    @action(detail=True, methods=['post'])
    def submit_feedback(self, request, pk=None):
        ticket = self.get_object()
        user = request.user
        
        # Security checks
        if ticket.owner != user:
            return Response({'error': 'You are not authorized to create feedback for this ticket.'}, status=403)
        if ticket.status != 'RESOLVED':
            return Response({'error': 'You can only create feedback for resolved tickets.'}, status=400)
        
        # Validate data with serializer
        serializer = StudentFeedbackSerializer(data=request.data)
        if serializer.is_valid():
            with transaction.atomic():
                # Save the feedback
                feedback = serializer.save(ticket=ticket, student=user)
                
                # Update ticket status based on satisfaction
                if feedback.is_satisfied:
                    ticket.status = 'CLOSED'
                    notify_department_staff(
                        department=ticket.current_department,
                        message=f'Ticket "#{ticket.id}" was CLOSED by {user.first_name} {user.last_name} based on feedback.',
                        link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
                    )
                else:
                    ticket.status = 'REOPENED'
                    notify_department_staff(
                        department=ticket.current_department,
                        message=f'Ticket "#{ticket.id}" was REOPENED by {user.first_name} {user.last_name} based on feedback.',
                        link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
                    )
                ticket.save()
                
            return Response(serializer.data, status=201)
        
        return Response(serializer.errors, status=400)

    @action(detail=True, methods=['post'])
    def add_additional_info(self, request, pk=None):
        ticket = self.get_object()
        user = request.user
        
        # Security checks
        if ticket.owner != user:
            return Response({'error': 'You are not authorized to add information to this ticket.'}, status=403)
        if ticket.status != 'PENDING':
            return Response({'error': 'You can only add additional information to pending tickets.'}, status=400)

        # Validate data with serializer
        serializer = AdditionalInfoSerializer(data=request.data)
        if serializer.is_valid():
            with transaction.atomic():
                # Save the additional info
                info = serializer.save(ticket=ticket, added_by=user)

                # Update ticket status if the additional info is submitted
                if info:
                    ticket.status = 'IN_PROGRESS'
                    ticket.save()
                    
                    # Log an automatic resolution to show the timeline event
                    Resolution.objects.create(
                        ticket=ticket,
                        resolved_by=None,  # System message
                        status='IN_PROGRESS',
                        feedback=f"Student ({user.first_name} {user.last_name}) provided additional information. Status updated to IN PROGRESS."
                    )
                    
                    notify_department_staff(
                        department=ticket.current_department,
                        message=f'{user.first_name} {user.last_name} provided additional info for ticket "#{ticket.id}".',
                        link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
                    )
                
            return Response(serializer.data, status=201)
        
        return Response(serializer.errors, status=400)
        
        
    @action(detail=True, methods=['post'])
    def escalate_ticket(self, request, pk=None):
        """
        Escalation endpoint for tickets.
        STAFF -> Flips `is_escalated = True`.
        SENIOR -> Transfers `current_department` to target_department_id.
        Logs an automatic Resolution in both cases.
        """
        user = request.user
        ticket = self.get_object() # Ensures the ticket exists

        # Security check
        if user.role != 'Staff':
             return Response({'error': 'Only staff can escalate tickets.'}, status=403)
        if not hasattr(user, 'staff_profile'):
             return Response({'error': 'Invalid staff profile.'}, status=400)

        staff_profile = user.staff_profile

        # Ensure ticket is actually in this staff member's department
        if ticket.current_department != staff_profile.department:
             return Response({'error': 'You cannot escalate a ticket outside your department queue.'}, status=403)

        reason = request.data.get('reason')
        if not reason:
            return Response({'error': 'Reason for escalation is required.'}, status=400)

        with transaction.atomic():
            # Check if this is a cross-department transfer request
            target_dept_id = request.data.get('target_department_id')
            
            if target_dept_id:
                # ANY STAFF CAN TRANSFER CROSS-DEPARTMENT
                try:
                    target_dept = Department.objects.get(id=target_dept_id)
                    if target_dept == ticket.current_department:
                        return Response({'error': 'You cannot transfer a ticket to the same department.'}, status=400)
                except Department.DoesNotExist:
                    return Response({'error': 'Invalid destination department.'}, status=400)

                old_dept = ticket.current_department
                old_dept_name = old_dept.department_name
                
                # Execute Transfer
                ticket.current_department = target_dept
                ticket.is_escalated = False # Reset escalation status for the new department
                ticket.status = 'TRANSFERRED' # Update visible status

                # Log the transfer note
                Resolution.objects.create(
                    ticket=ticket,
                    resolved_by=user,
                    status='TRANSFERRED',
                    feedback=f"[TRANSFERRED from {old_dept_name} to {target_dept.department_name}]: {reason}"
                )
                
                ticket.save()

                #Create notification message for Student
                Notification.objects.create(
                    user=ticket.owner,
                    message=f'Your ticket "#{ticket.id}" has been transferred to {target_dept.department_name}.',
                    link=f'/api/v1/ticket/{ticket.id}/'
                )

                #Notify staff in the old department
                notify_department_staff(
                    department=old_dept,
                    message=f'Ticket "#{ticket.id}" was transferred out to {target_dept.department_name}.',
                    link=f'/api/v1/staff-dashboard/all-issues/'
                )

                #Notify staff in the new department
                notify_department_staff(
                    department=target_dept,
                    message=f'Ticket "#{ticket.id}" was transferred into your department from {old_dept_name}.',
                    link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
                )

                return Response({'message': f'Ticket successfully transferred to {target_dept.department_name}.'})
                
            else:
                # NO TARGET DEPT PROVIDED -> INTERNAL ESCALATION (STAFF TIER TO SENIOR TIER)
                if staff_profile.staff_role == 'STAFF':
                    ticket.is_escalated = True
                    ticket.status = 'ESCALATED' # Update visible status
                    
                    # Log the internal escalation note
                    Resolution.objects.create(
                        ticket=ticket,
                        resolved_by=user,
                        status='ESCALATED',
                        feedback=f"[INTERNAL ESCALATION]: {reason}"
                    )

                    ticket.save()

                    #Create notification message for Student
                    Notification.objects.create(
                        user=ticket.owner,
                        message=f'Your ticket "#{ticket.id}" has been escalated.',
                        link=f'/api/v1/ticket/{ticket.id}/'
                    )

                    # Notify SENIOR staff (link to ticket)
                    senior_users = User.objects.filter(staff_profile__department=ticket.current_department, staff_profile__staff_role='SENIOR')
                    senior_notifications = [
                        Notification(
                            user=su, 
                            message=f'Ticket "#{ticket.id}" has been escalated to Senior Staff.', 
                            link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
                        ) for su in senior_users
                    ]
                    if senior_notifications:
                        Notification.objects.bulk_create(senior_notifications)

                    # Notify REGULAR staff (link to all issues)
                    regular_users = User.objects.filter(staff_profile__department=ticket.current_department, staff_profile__staff_role='STAFF')
                    regular_notifications = [
                        Notification(
                            user=ru, 
                            message=f'Ticket "#{ticket.id}" has been escalated to Senior Staff.', 
                            link='/api/v1/staff-dashboard/all-issues/'
                        ) for ru in regular_users
                    ]
                    if regular_notifications:
                        Notification.objects.bulk_create(regular_notifications)

                    return Response({'message': 'Ticket successfully escalated to Senior Staff.'})
                else:
                    return Response({'error': 'Seniors cannot escalate internally, they can only transfer or resolve.'}, status=400)

class ResolutionViewSet(viewsets.ModelViewSet):
    queryset = Resolution.objects.all()
    serializer_class = ResolutionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        user = self.request.user

        if user.role != 'Staff':
            raise serializers.ValidationError("Only staff members can resolve tickets.")
        
        #Extract the status from the validated data (default to 'Resolved' if empty)
        new_status = serializer.validated_data.get('status', 'RESOLVED')

        with transaction.atomic(): #Either both the Resolution and the Ticket update, or neither does
            # Save the resolution record, explicitly linking the status
            resolution = serializer.save(resolved_by=user, status=new_status)

            # Access the linked ticket
            ticket = resolution.ticket
            
            #Update the linked Ticket status based on the staff's choice
            if new_status == 'PENDING':
                ticket.status = 'PENDING'
            elif new_status == 'RESOLVED':
                ticket.status = 'RESOLVED'
            elif new_status == 'IN_PROGRESS':
                ticket.status = 'IN_PROGRESS'
            elif new_status == 'REJECTED':
                ticket.status = 'REJECTED'
            else:
                print(f"WARNING! new_status '{new_status}' did not match PENDING, IN_PROGRESS or RESOLVED or REJECTED.")

            # Save the ticket
            ticket.save()

            #Create notification message
            if new_status == 'PENDING':
                notif_msg = f'Your ticket "#{ticket.id}" requires additional information.'
            elif new_status == 'RESOLVED':
                notif_msg = f'Your ticket "#{ticket.id}" has been resolved. Please provide feedback to close it.'
            else:
                notif_msg = f'Your ticket "#{ticket.id}" status was updated to {new_status}.'

            Notification.objects.create(
                user=ticket.owner,
                message=notif_msg,
                link=f'/api/v1/ticket/{ticket.id}/'
            )
            
            # Refresh from DB to confirm it stuck
            ticket.refresh_from_db()

    @action(detail=False, methods=['get'])
    def all_resolutions(self, request):
        """
        API endpoint for "All Resolutions" page.
        Filters resolutions by department, status, staff member, and search query.
        """
        user = request.user
        if not user.is_authenticated or user.role != 'Staff':
             return Response({'error': 'Unauthorized'}, status=403)

        if not hasattr(user, 'staff_profile') or not user.staff_profile.department:
             return Response({'error': 'Staff profile/department not found'}, status=400)

        staff_dept = user.staff_profile.department
        
        # Base Query: Resolutions linked to tickets currently in the staff's department
        # queryset = Resolution.objects.filter(ticket__current_department=staff_dept).order_by('-resolved_at')

        #Base Query: Resolutions a staff themselves have made if regular staff, else all resolutions in their department
        if user.staff_profile.staff_role == 'STAFF':
            queryset = Resolution.objects.filter(resolved_by=user).order_by('-resolved_at')
        else:
            queryset = Resolution.objects.filter(ticket__current_department=staff_dept).order_by('-resolved_at')
        # Filtering 
        # 1. Status (of the Resolution itself, not the Ticket's current status)
        status_param = request.query_params.get('status')
        if status_param and status_param != 'All Statuses':
            # Filter based on the historical status of the resolution
            queryset = queryset.filter(status=status_param.upper())

        # 2. Staff Member
        staff_param = request.query_params.get('staff')
        if staff_param and staff_param != 'All Staff':
            try:
                queryset = queryset.filter(resolved_by__id=int(staff_param))
            except ValueError:
                pass

        # 3. Search (Ticket ID or Title)
        search_query = request.query_params.get('search')
        if search_query:
            queryset = queryset.filter(
                Q(ticket__id__icontains=search_query) |
                Q(ticket__title__icontains=search_query)
            )

        # Pagination
        page_number = request.query_params.get('page', 1)
        page_size = 10
        paginator = Paginator(queryset, page_size)

        try:
            page_obj = paginator.page(page_number)
        except Exception:
            page_obj = paginator.page(1)

        serializer = ResolutionSerializer(page_obj.object_list, many=True)
        
        return Response({
            'resolutions': serializer.data,
            'has_next': page_obj.has_next(),
            'has_previous': page_obj.has_previous(),
            'total_pages': paginator.num_pages,
            'current_page': page_obj.number,
            'total_count': paginator.count
        })
