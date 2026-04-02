from rest_framework import generics, permissions
from rest_framework.permissions import AllowAny
from .serializers import UserRegistrationSerializer, UserProfileSerializer, CustomTokenObtainPairSerializer, NotificationSerializer
from .models import Notification
from django.contrib.auth import get_user_model, login
from django.views.generic import TemplateView 
from organization.models import Course, Department
from rest_framework_simplejwt.views import TokenObtainPairView 
from rest_framework.response import Response 

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

class NotificationListView(generics.ListAPIView):
    serializer_class = NotificationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
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
