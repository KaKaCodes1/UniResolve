from django.shortcuts import render
from rest_framework import generics
from rest_framework.permissions import AllowAny
from .serializers import UserRegistrationSerializer
from django.contrib.auth import get_user_model

User = get_user_model()

class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [AllowAny] #allow access to this view to anyone as it is the registration view

from django.views.generic import CreateView
from django.urls import reverse_lazy
from .forms import StudentSignUpForm, StaffSignUpForm

class StudentSignUpView(CreateView):
    model = User
    form_class = StudentSignUpForm
    template_name = 'accounts/signup_student.html'
    success_url = reverse_lazy('login') # TODO: Ensure this points to a template-based login view later

class StaffSignUpView(CreateView):
    model = User
    form_class = StaffSignUpForm
    template_name = 'accounts/signup_staff.html'
    success_url = reverse_lazy('login')

