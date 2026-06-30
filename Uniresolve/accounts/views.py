from rest_framework import generics, permissions
from .serializers import UserRegistrationSerializer, UserProfileSerializer, CustomTokenObtainPairSerializer, NotificationSerializer, ChangePasswordSerializer
from .models import Notification
from django.contrib.auth import get_user_model, login
from django.views.generic import TemplateView 
from organization.models import Course, Department
from rest_framework_simplejwt.views import TokenObtainPairView 
from rest_framework.response import Response 
from tickets.utils.auto_escalate_util import auto_escalate_overdue_tickets, issue_deadline_warnings

User = get_user_model()

class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.IsAdminUser] # only admins can register users
    # permission_classes = [permissions.AllowAny]


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

class ForcePasswordChangePageView(TemplateView):
    template_name = 'accounts/force_change_password.html'

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

# View to list all notifications of a user
class NotificationListView(generics.ListAPIView):
    serializer_class = NotificationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        issue_deadline_warnings()
        auto_escalate_overdue_tickets()
        return self.request.user.notifications.all()

# View to mark a notification as read
class NotificationMarkReadView(generics.UpdateAPIView):
    queryset = Notification.objects.all()
    permission_classes = [permissions.IsAuthenticated]

    def update(self, request, *args, **kwargs):
        notification = self.get_object()
        if notification.user != request.user:
            return Response({"error": "Unauthorized"}, status=403)
        
        notification.is_read = True
        notification.save()
        return Response({"status": "marked as read"})

class ChangePasswordView(generics.UpdateAPIView):
    serializer_class = ChangePasswordSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self, queryset=None):
        return self.request.user

    def update(self, request, *args, **kwargs):
        self.object = self.get_object()
        serializer = self.get_serializer(data=request.data, context={'request': request})

        if serializer.is_valid():
            # Check old password
            if not self.object.check_password(serializer.validated_data.get("old_password")):
                return Response({"old_password": ["Wrong old password."]}, status=400)
            
            # Update password and flag
            self.object.set_password(serializer.validated_data.get("new_password"))
            self.object.must_change_password = False
            self.object.save()
            
            return Response({"status": "Password changed successfully."}, status=200)

        return Response(serializer.errors, status=400)

