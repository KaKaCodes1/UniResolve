from rest_framework import permissions, viewsets
import openpyxl
from datetime import timedelta
from django.utils import timezone
from administration.validators import validate_excel_file
from .serializers import UserProfileSerializer
from django.contrib.auth import get_user_model
from django.views.generic import TemplateView 
from organization.models import Department, Category 
from rest_framework.response import Response 
from django.http import HttpResponse
from administration.excel_generator import generate_template_workbook
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from django.db.models import Q
from tickets.models import Ticket, Resolution
from tickets.serializers import TicketSerializer, ResolutionSerializer
from rest_framework.decorators import action
from django.core.paginator import Paginator
from django.db import transaction
from .models import StudentProfile, StaffProfile
from organization.models import Department, Category, Course 
from django.core.validators import validate_email
from django.core.exceptions import ValidationError
from django.db.models import Count

User = get_user_model()

@method_decorator(never_cache, name='dispatch')
class AdminDashboardPageView(TemplateView):
    template_name = 'accounts/admin/admin_dashboard.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Admin':
            now = timezone.now()
            one_week_ago = now - timedelta(days=7)
            two_weeks_ago = now - timedelta(days=14)

            def get_rate(number_of_tickets, total_tickets):
                if total_tickets == 0:
                    return 0
                return round((number_of_tickets / total_tickets) * 100)

            def get_trend(this_week, last_week):
                if last_week == 0:
                    if this_week > 0:
                        trend = 100
                    else:
                        trend = 0
                    
                    return trend, this_week >= last_week
                
                diff = this_week - last_week
                trend = round((abs(diff) / last_week) * 100)
                return trend, diff >= 0

            # Dashboard Stats
            total_tickets = Ticket.objects.count()
            resolved_tickets = Ticket.objects.filter(status='RESOLVED').count()
            pending_tickets = Ticket.objects.filter(status='PENDING').count()
            closed_tickets = Ticket.objects.filter(status='CLOSED').count()
            escalated_tickets = Ticket.objects.filter(status='ESCALATED').count()
            
            context['total_tickets_count'] = total_tickets
            context['pending_tickets_count'] = pending_tickets
            context['resolution_rate'] = get_rate(resolved_tickets, total_tickets)
            context['satisfaction_rate'] = get_rate(closed_tickets, total_tickets)
            context['escalation_rate'] = get_rate(escalated_tickets, total_tickets)

            #Additional stats for the charts
            open_tickets = Ticket.objects.filter(status='OPEN').count()
            in_progress_tickets = Ticket.objects.filter(status='IN_PROGRESS').count()
            transferred_tickets = Ticket.objects.filter(status='TRANSFERRED').count()
            reopened_tickets = Ticket.objects.filter(status='REOPENED').count()
            rejected_tickets = Ticket.objects.filter(status='REJECTED').count()


            # Charts Data
            # Get top 6 categories by ticket count (arrange in descending order)
            category_data = list(Ticket.objects.values('category__category_name').annotate(count=Count('id')).order_by('-count')[:6])
            context['category_data'] = category_data

            # Get the maximum count of tickets in any category to help calculate the percentage for the bar chart
            context['max_category_count'] = max([item['count'] for item in category_data]) if category_data else 1

            context['chart_open_tickets'] = open_tickets
            context['chart_in_progress_tickets'] = in_progress_tickets
            context['chart_closed_tickets'] = closed_tickets
            context['chart_resolved_tickets'] = resolved_tickets
            context['chart_pending_tickets'] = pending_tickets
            context['chart_transferred_tickets'] = transferred_tickets
            context['chart_escalated_tickets'] = escalated_tickets
            context['chart_reopened_tickets'] = reopened_tickets
            context['chart_rejected_tickets'] = rejected_tickets


            # This Week
            tw_total = Ticket.objects.filter(created_at__gte=one_week_ago).count()
            tw_resolved = Ticket.objects.filter(created_at__gte=one_week_ago, status='RESOLVED').count()
            tw_closed = Ticket.objects.filter(created_at__gte=one_week_ago, status='CLOSED').count()
            tw_escalated = Ticket.objects.filter(created_at__gte=one_week_ago, status='ESCALATED').count()

            tw_res_rate = get_rate(tw_resolved, tw_total)
            tw_sat_rate = get_rate(tw_closed, tw_total)
            tw_esc_rate = get_rate(tw_escalated, tw_total)

            # Last Week
            lw_total = Ticket.objects.filter(created_at__gte=two_weeks_ago, created_at__lt=one_week_ago).count()
            lw_resolved = Ticket.objects.filter(created_at__gte=two_weeks_ago, created_at__lt=one_week_ago, status='RESOLVED').count()
            lw_closed = Ticket.objects.filter(created_at__gte=two_weeks_ago, created_at__lt=one_week_ago, status='CLOSED').count()
            lw_escalated = Ticket.objects.filter(created_at__gte=two_weeks_ago, created_at__lt=one_week_ago, status='ESCALATED').count()

            lw_res_rate = get_rate(lw_resolved, lw_total)
            lw_sat_rate = get_rate(lw_closed, lw_total)
            lw_esc_rate = get_rate(lw_escalated, lw_total)

            # Trends
            total_trend, total_up = get_trend(tw_total, lw_total)
            res_trend, res_up = get_trend(tw_res_rate, lw_res_rate)
            sat_trend, sat_up = get_trend(tw_sat_rate, lw_sat_rate)
            esc_trend, esc_up = get_trend(tw_esc_rate, lw_esc_rate)

            context['total_trend'] = total_trend
            context['total_up'] = total_up
            context['res_trend'] = res_trend
            context['res_up'] = res_up
            context['sat_trend'] = sat_trend
            context['sat_up'] = sat_up
            context['esc_trend'] = esc_trend
            context['esc_up'] = esc_up

            # Pending Staff Approvals
            context['pending_staff'] = User.objects.filter(role='Staff', is_active=False).select_related('staff_profile', 'staff_profile__department')
             
        return context

@method_decorator(never_cache, name='dispatch')
class AdminAllStaffPageView(TemplateView):
    template_name = 'accounts/admin/admin_allstaff.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Admin':
            context['staff_roles'] = [choice[0] for choice in StaffProfile.staff_roles_choices]
            context['departments'] = Department.objects.all()
        return context

@method_decorator(never_cache, name='dispatch')
class AdminAllStudentsPageView(TemplateView):
    template_name = 'accounts/admin/admin_allstudents.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Admin':
            context['courses'] = Course.objects.all()
            context['departments'] = Department.objects.all()
        return context

@method_decorator(never_cache, name='dispatch')
class AdminBulkImportPageView(TemplateView):
    template_name = 'accounts/admin/bulk_import.html'

@method_decorator(never_cache, name='dispatch')
class AdminTicketDetailView(TemplateView):
    template_name = 'accounts/admin/admin_ticket_detail.html'

@method_decorator(never_cache, name='dispatch')
class AdminAllIssuesPageView(TemplateView):
    template_name = 'accounts/admin/admin_allissues.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Admin':
            context['departments'] = Department.objects.all()
            context['status_choices'] = Ticket.status_choices
            context['categories'] = Category.objects.all()
        return context

@method_decorator(never_cache, name='dispatch')
class AdminCriticalTicketsPageView(TemplateView):
    template_name = 'accounts/admin/admin_critical_tickets.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Admin':
            context['departments'] = Department.objects.all()
            context['categories'] = Category.objects.all()
        return context

@method_decorator(never_cache, name='dispatch')
class AdminAllResolutionsPageView(TemplateView):
    template_name = 'accounts/admin/admin_allresolutions.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Admin':
            context['departments'] = Department.objects.all()
            context['status_choices'] = Ticket.status_choices
        return context

@method_decorator(never_cache, name='dispatch')
class AdminManageDepartmentsPageView(TemplateView):
    template_name = 'accounts/admin/manage_departments.html'   

@method_decorator(never_cache, name='dispatch')
class AdminManageCoursesPageView(TemplateView):
    template_name = 'accounts/admin/manage_courses.html'   

@method_decorator(never_cache, name='dispatch')
class AdminManageIssueCategoriesPageView(TemplateView):
    template_name = 'accounts/admin/manage_issue_categories.html'   
            
#Viewsets
class UsersViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = UserProfileSerializer

    def check_admin(self, user):
        return user.is_authenticated and user.role == 'Admin'

    @action(detail=False, methods=['get'])
    def all_staff(self, request):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)

        queryset = User.objects.filter(role='Staff').select_related('staff_profile', 'staff_profile__department')

        # Filters
        staff_role = request.query_params.get('staff_role')
        department_id = request.query_params.get('department')
        status = request.query_params.get('status')
        search_query = request.query_params.get('search')

        if staff_role:
            queryset = queryset.filter(staff_profile__staff_role=staff_role)
        
        if department_id:
            queryset = queryset.filter(
                Q(staff_profile__department_id=department_id) 
            )

        if status:
            if status == 'active':
                queryset = queryset.filter(is_active=True)
            elif status == 'inactive':
                queryset = queryset.filter(is_active=False)

        if search_query:
            queryset = queryset.filter(
                Q(first_name__icontains=search_query) |
                Q(last_name__icontains=search_query) |
                Q(email__icontains=search_query) |
                Q(staff_profile__employee_id__icontains=search_query)
            )

        # Pagination
        page_number = request.query_params.get('page', 1)
        page_size = 10
        paginator = Paginator(queryset, page_size)

        try:
            page_obj = paginator.page(page_number)
        except Exception:
            page_obj = paginator.page(1)

        serializer = self.get_serializer(page_obj, many=True)
        return Response({
            'users': serializer.data,
            'has_next': page_obj.has_next(),
            'has_previous': page_obj.has_previous(),
            'total_pages': paginator.num_pages,
            'current_page': page_obj.number,
            'total_count': paginator.count
        })

    @action(detail=False, methods=['get'])
    def all_students(self, request):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)

        queryset = User.objects.all().filter(role='Student').select_related('student_profile', 'student_profile__course', 'student_profile__course__department')

        # Filters
        status = request.query_params.get('status')
        department_id = request.query_params.get('department')
        course_id = request.query_params.get('course')
        search_query = request.query_params.get('search')

        if status:
            if status == 'active':
                queryset = queryset.filter(is_active=True)
            elif status == 'inactive':
                queryset = queryset.filter(is_active=False)

        if department_id:
            queryset = queryset.filter(
                Q(student_profile__course__department_id=department_id)
            )
        
        if course_id:
            queryset = queryset.filter(
                Q(student_profile__course_id=course_id)
            )

        if search_query:
            queryset = queryset.filter(
                Q(first_name__icontains=search_query) |
                Q(last_name__icontains=search_query) |
                Q(email__icontains=search_query) |
                Q(student_profile__reg_number__icontains=search_query) 
            )

        # Pagination
        page_number = request.query_params.get('page', 1)
        page_size = 10
        paginator = Paginator(queryset, page_size)

        try:
            page_obj = paginator.page(page_number)
        except Exception:
            page_obj = paginator.page(1)

        serializer = self.get_serializer(page_obj, many=True)
        return Response({
            'users': serializer.data,
            'has_next': page_obj.has_next(),
            'has_previous': page_obj.has_previous(),
            'total_pages': paginator.num_pages,
            'current_page': page_obj.number,
            'total_count': paginator.count
        })

    @action(detail=True, methods=['patch'])
    def update_user(self, request, pk=None):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)

        try:
            user_to_update = User.objects.get(id=pk)
        except User.DoesNotExist:
            return Response({'error': 'User not found'}, status=404)

        # 1. Update Global Active Status
        is_active = request.data.get('is_active')
        if is_active is not None:
            # Convert string to boolean if necessary
            if isinstance(is_active, str):
                is_active = is_active.lower() == 'true'
            user_to_update.is_active = is_active

        # 2. Update Staff Role (Only applicable to Staff)
        if user_to_update.role == 'Staff':
            staff_role = request.data.get('staff_role')
            if staff_role and hasattr(user_to_update, 'staff_profile'):
                if staff_role in [choice[0] for choice in StaffProfile.staff_roles_choices]:
                    user_to_update.staff_profile.staff_role = staff_role
                    user_to_update.staff_profile.save()
                else:
                    return Response({'error': 'Invalid staff role provided.'}, status=400)

        user_to_update.save()
        
        # Return updated serialized data
        serializer = self.get_serializer(user_to_update)
        return Response({
            'message': 'User updated successfully', 
            'user': serializer.data
        })

class AdminViewSet(viewsets.GenericViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = TicketSerializer

    def check_admin(self, user):
        return user.is_authenticated and user.role == 'Admin'

    @action(detail=False, methods=['get'])
    def download_template(self, request):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)
        
        role = request.query_params.get('role', 'Student') # Default to Student
        if role not in ['Student', 'Staff']:
             return Response({'error': 'Invalid role. Must be Student or Staff.'}, status=400)

        wb = generate_template_workbook(role)
        
        response = HttpResponse(content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        response['Content-Disposition'] = f'attachment; filename={role}_Import_Template.xlsx'
        
        wb.save(response)
        return response

    @action(detail=False, methods=['post'])
    def bulk_import(self, request):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)
        
        file = request.FILES.get('file')
        if not file:
            return Response({'error': 'No file provided'}, status=400)
        
        try:
            validate_excel_file(file)
        except ValidationError as e:
            return Response({'error': e.messages[0]}, status=400)

        role = request.data.get('role')
        if not role:
            return Response({'error': 'Role not specified'}, status=400)
        
        if role not in ['Student', 'Staff']:
            return Response({'error': 'Invalid role. Must be Student or Staff.'}, status=400)
        
        try:
            #Open the excel file and get the visible sheet
            wb = openpyxl.load_workbook(file)
            ws = wb.active

            # Read all rows, skipping the header (Row 1), and extract just the values
            rows = list(ws.iter_rows(min_row=2, values_only=True))

            if not rows:
                return Response({'error': 'The uploaded file is empty.'}, status=400)

            # Initialize counters and error list
            success_count = 0
            error_details = []
            generic_password = "Cuea@2026"

            try:
                with transaction.atomic():
                    for index, row in enumerate(rows, start=2):
                        if not any(row):
                            continue # Skip empty rows at the end of the file

                        try:
                            first_name, last_name, email, unique_id, target_name = row[:5]
                            
                            # Check for missing fields
                            if not all([first_name, last_name, email, unique_id, target_name]):
                                error_details.append(f"Row {index}: Missing required fields.")
                                continue

                            #Check if email is actually an email
                            try:
                                validate_email(email)
                            except ValidationError:
                                error_details.append(f"Row {index}: '{email}' is not a valid email address.")
                                continue

                            # Check for duplicate emails
                            if User.objects.filter(email=email).exists():
                                error_details.append(f"Row {index}: User with email {email} already exists.")
                                continue

                            # Check for duplicate unique_id
                            if role == 'Student':
                                if StudentProfile.objects.filter(reg_number=unique_id).exists():
                                    error_details.append(f"Row {index}: Student with reg number {unique_id} already exists.")
                                    continue
                            elif role == 'Staff':
                                if StaffProfile.objects.filter(employee_id=unique_id).exists():
                                    error_details.append(f"Row {index}: Staff with employee id {unique_id} already exists.")
                                    continue
                            
                            # Create user
                            user = User.objects.create(
                                email=email,
                                first_name=first_name,
                                last_name=last_name,
                                role=role,
                                must_change_password=True
                            )
                            user.set_password(generic_password)
                            user.save()

                            # Create profile
                            if role == 'Student':
                                # __iexact makes it case-insensitive while first() returns the first object that matches the query
                                course = Course.objects.filter(course_name__iexact=target_name).first()
                                if not course:
                                    error_details.append(f"Row {index}: Course {target_name} not found.")
                                    continue
                                StudentProfile.objects.create(
                                    user=user,
                                    reg_number=unique_id,
                                    course=course
                                )

                            elif role == 'Staff':
                                dept = Department.objects.filter(department_name__iexact=target_name).first()
                                if not dept:
                                    error_details.append(f"Row {index}: Department {target_name} not found.")
                                    continue
                                StaffProfile.objects.create(
                                    user=user,
                                    employee_id=unique_id,
                                    department=dept
                                )

                            success_count += 1

                        # This catches errors if the row doesn't have the expected number of columns
                        except ValueError:
                            error_details.append(f"Row {index}: Invalid data format. Please follow the official template")
                    
                    # If there are any errors on the error list, stop creating users and delete the created users in the transaction
                    if error_details:
                        raise ValueError("Validation Failed")

            # Returns the error details if there are any errors    
            except ValueError:
                return Response({
                    'error': 'Import failed due to data errors. No users were saved. Please fix the following rows:',
                    'details': error_details,
                }, status=400)
            
            # Returns the success message if there are no errors
            return Response({
                'message': f'Successfully imported {success_count} {role}s.',
                'errors': []
            }, status=201)

        # Catches any server errors that may occor
        except Exception as e:
            return Response({'error': f'Failed to process file: {str(e)}'}, status=500)


    @action(detail=False, methods=['get'], url_path='all-issues')
    def get_all_issues(self, request):
        """
        Get all tickets with filters and pagination.
        """
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)
        
        queryset = Ticket.objects.all().select_related('owner', 'category', 'current_department').order_by('-created_at')
        
        # Filters
        status_param = request.query_params.get('status')
        if status_param and status_param != 'All Statuses':
            queryset = queryset.filter(status=status_param.upper())

        category_param = request.query_params.get('category')
        if category_param and category_param != 'All Categories':
            try:
                queryset = queryset.filter(category_id=int(category_param))
            except ValueError:
                pass

        department_param = request.query_params.get('department')
        if department_param and department_param != 'All Departments':
            try:
                queryset = queryset.filter(current_department_id=int(department_param))
            except ValueError:
                pass

        #Search
        search_query = request.query_params.get('search')
        if search_query:
            queryset = queryset.filter(
                Q(title__icontains=search_query) |
                Q(description__icontains=search_query) |
                Q(id__icontains=search_query) |
                Q(owner__first_name__icontains=search_query) |
                Q(owner__last_name__icontains=search_query) |
                Q(category__category_name__icontains=search_query) 
            )
        
        #Pagination
        page_number = request.query_params.get('page', 1)
        page_size = 10
        paginator = Paginator(queryset, page_size)

        try:
            page_obj = paginator.page(page_number)
        except Exception:
            page_obj = paginator.page(1)

        serializer = self.get_serializer(page_obj, many=True)
        return Response({
            'tickets': serializer.data,
            'has_next': page_obj.has_next(),
            'has_previous': page_obj.has_previous(),
            'total_pages': paginator.num_pages,
            'current_page': page_obj.number,
            'total_count': paginator.count
        })

    @action(detail=False, methods=['get'], url_path='critical-tickets')
    def get_critical_tickets(self, request):
        """
        Get all tickets that are overdue (due_date < now) and not resolved/closed/reject/pending
        """
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)
        
        # Base query for critical tickets
        queryset = Ticket.objects.filter(
            due_date__lt=timezone.now()
        ).exclude(
            status__in=['RESOLVED', 'CLOSED', 'REJECTED']
        ).select_related('owner', 'category', 'current_department').order_by('due_date')

        category_param = request.query_params.get('category')
        if category_param and category_param != 'All Categories':
            try:
                queryset = queryset.filter(category_id=int(category_param))
            except ValueError:
                pass

        department_param = request.query_params.get('department')
        if department_param and department_param != 'All Departments':
            try:
                queryset = queryset.filter(current_department_id=int(department_param))
            except ValueError:
                pass

        #Search
        search_query = request.query_params.get('search')
        if search_query:
            queryset = queryset.filter(
                Q(title__icontains=search_query) |
                Q(description__icontains=search_query) |
                Q(id__icontains=search_query) |
                Q(owner__first_name__icontains=search_query) |
                Q(owner__last_name__icontains=search_query) |
                Q(category__category_name__icontains=search_query) 
            )
        
        #Pagination
        page_number = request.query_params.get('page', 1)
        page_size = 10
        paginator = Paginator(queryset, page_size)

        try:
            page_obj = paginator.page(page_number)
        except Exception:
            page_obj = paginator.page(1)

        serializer = self.get_serializer(page_obj, many=True)
        return Response({
            'tickets': serializer.data,
            'has_next': page_obj.has_next(),
            'has_previous': page_obj.has_previous(),
            'total_pages': paginator.num_pages,
            'current_page': page_obj.number,
            'total_count': paginator.count
        })

    @action(detail=False, methods=['get'], url_path='all-resolutions')
    def all_resolutions(self, request):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)

        queryset = Resolution.objects.all().select_related('ticket', 'ticket__owner', 'ticket__current_department').order_by('-resolved_at')

        # Filters
        status_param = request.query_params.get('status')
        if status_param and status_param != 'All Statuses':
            queryset = queryset.filter(status=status_param.upper())

        # category_param = request.query_params.get('category')
        # if category_param and category_param != 'All Categories':
        #     try:
        #         queryset = queryset.filter(category_id=int(category_param))
        #     except ValueError:
        #         pass

        department_param = request.query_params.get('department')
        if department_param and department_param != 'All Departments':
            try:
                queryset = queryset.filter(ticket__current_department_id=int(department_param))
            except ValueError:
                pass
            
        # Search (Ticket ID, staff or Title)
        search_query = request.query_params.get('search')
        if search_query:
            queryset = queryset.filter(
                Q(ticket__id__icontains=search_query) |
                Q(ticket__title__icontains=search_query) |
                Q(resolved_by__first_name__icontains=search_query)
            )

        #Pagination
        page_number = request.query_params.get('page', 1)
        page_size = 10
        paginator = Paginator(queryset, page_size)

        try:
            page_obj = paginator.page(page_number)
        except Exception:
            page_obj = paginator.page(1)

        serializer = ResolutionSerializer(page_obj, many=True)
        return Response({
            'resolutions': serializer.data,
            'has_next': page_obj.has_next(),
            'has_previous': page_obj.has_previous(),
            'total_pages': paginator.num_pages,
            'current_page': page_obj.number,
            'total_count': paginator.count
        })

