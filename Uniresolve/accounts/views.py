from django.shortcuts import render
from rest_framework import generics
from rest_framework import generics, permissions, viewsets, serializers
from rest_framework.permissions import AllowAny, IsAuthenticated
from .serializers import UserRegistrationSerializer, UserProfileSerializer, CustomTokenObtainPairSerializer
from django.contrib.auth import get_user_model, login
from django.views.generic import TemplateView 
from organization.models import Course, Department, Category 
from rest_framework_simplejwt.views import TokenObtainPairView 
from rest_framework.response import Response 
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from django.db.models import Q
from tickets.models import Ticket, Resolution
from tickets.serializers import TicketSerializer, ResolutionSerializer
from rest_framework.decorators import action
from django.core.paginator import Paginator



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



        
        
        

