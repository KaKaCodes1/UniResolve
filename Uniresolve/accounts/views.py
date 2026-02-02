from django.shortcuts import render
from rest_framework import generics
from rest_framework import generics, permissions, viewsets, serializers
from rest_framework.permissions import AllowAny, IsAuthenticated
from .serializers import UserRegistrationSerializer, UserProfileSerializer, CustomTokenObtainPairSerializer
from django.contrib.auth import get_user_model, login
from django.views.generic import TemplateView 
from organization.models import Course, Department 
from rest_framework_simplejwt.views import TokenObtainPairView 
from rest_framework.response import Response 
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from django.db.models import Q
from tickets.models import Ticket, Resolution
from rest_framework.decorators import action


# router = DefaultRouter()

User = get_user_model()

class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [AllowAny] #allow access to this view to anyone as it is the registration view


class UserProfileView(generics.RetrieveAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = UserProfileSerializer

    def get_object(self):
        return self.request.user



# View for the Student Sign-Up Page
# Renders the HTML template and provides the list of Courses for the dropdown
class StudentSignUpPageView(TemplateView):
    template_name = 'accounts/signup_student.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['courses'] = Course.objects.all() # Pass all courses to the template
        return context

# View for the Staff Sign-Up Page
# Renders the HTML template and provides the list of Departments for the dropdown
class StaffSignUpPageView(TemplateView):
    template_name = 'accounts/signup_staff.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['departments'] = Department.objects.all() # Pass all departments to the template
        return context

# View for the Login Page
class LoginPageView(TemplateView):
    template_name = 'accounts/login.html'

class CustomLoginView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

    def post(self, request, *args, **kwargs):
        # We override post to perform session login as well
        serializer = self.get_serializer(data=request.data)
        
        try:
            serializer.is_valid(raise_exception=True)
        except Exception:
             # Fallback to standard error handling if validation fails
             return super().post(request, *args, **kwargs)

        user = serializer.user
        # Log the user in to the session (essential for TemplateViews like Profile)
        login(request, user)
        
        return Response(serializer.validated_data, status=200)


@method_decorator(never_cache, name='dispatch')
class AdminDashboardPageView(TemplateView):
    template_name = 'accounts/admin_dashboard.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Admin':
            # Dashboard Stats
            total_tickets = Ticket.objects.count()
            resolved_tickets = Ticket.objects.filter(status='RESOLVED').count()
            
            context['total_tickets_count'] = total_tickets
            context['pending_tickets_count'] = Ticket.objects.filter(status='PENDING').count()
            context['active_users_count'] = User.objects.filter(is_active=True).count()
            
            # Resolution Rate Calculation
            if total_tickets > 0:
                context['resolution_rate'] = round((resolved_tickets / total_tickets) * 100)
            else:
                context['resolution_rate'] = 0

            # Pending Staff Approvals
            context['pending_staff'] = User.objects.filter(role='Staff', is_active=False).select_related('staff_profile', 'staff_profile__department')
             
        return context

@method_decorator(never_cache, name='dispatch')
class AdminAllUsersPageView(TemplateView):
    template_name = 'accounts/admin_allusers.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        
        if user.is_authenticated and user.role == 'Admin':
            context['roles'] = [choice[0] for choice in User.roles_choices]
            context['departments'] = Department.objects.all()
        return context

#Viewsets

class UserViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = UserProfileSerializer

    def check_admin(self, user):
        return user.is_authenticated and user.role == 'Admin'

    @action(detail=False, methods=['get'])
    def all_users(self, request):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)

        queryset = User.objects.all().select_related('student_profile', 'staff_profile', 'staff_profile__department', 'student_profile__course__department')

        # Filters
        role = request.query_params.get('role')
        department_id = request.query_params.get('department')
        search_query = request.query_params.get('search')

        if role:
            queryset = queryset.filter(role=role)
        
        if department_id:
            queryset = queryset.filter(
                Q(staff_profile__department_id=department_id) | 
                Q(student_profile__course__department_id=department_id)
            )

        if search_query:
            queryset = queryset.filter(
                Q(first_name__icontains=search_query) |
                Q(last_name__icontains=search_query) |
                Q(email__icontains=search_query) |
                Q(student_profile__reg_number__icontains=search_query) |
                Q(staff_profile__employee_id__icontains=search_query)
            )

        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

class AdminViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]

    def check_admin(self, user):
        return user.is_authenticated and user.role == 'Admin'

    @action(detail=False, methods=['post'])
    def approve_staff(self, request):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)
        
        user_id = request.data.get('user_id')
        staff_role = request.data.get('staff_role', 'STAFF') # STAFF or SENIOR

        try:
            user = User.objects.get(id=user_id, role='Staff')
            user.is_active = True
            user.save()

            if hasattr(user, 'staff_profile'):
                profile = user.staff_profile
                profile.staff_role = staff_role
                profile.save()
            
            return Response({'message': f'Staff member {user.get_full_name()} approved as {staff_role}.'})
        except User.DoesNotExist:
            return Response({'error': 'User not found or not a staff member'}, status=404)

    @action(detail=False, methods=['post'])
    def reject_staff(self, request):
        if not self.check_admin(request.user):
            return Response({'error': 'Unauthorized'}, status=403)
        
        user_id = request.data.get('user_id')
        try:
            user = User.objects.get(id=user_id, role='Staff', is_active=False)
            user.delete()
            return Response({'message': 'Registration request rejected and account deleted.'})
        except User.DoesNotExist:
            return Response({'error': 'Pending staff request not found'}, status=404)


