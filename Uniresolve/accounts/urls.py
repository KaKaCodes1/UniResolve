from django.urls import path
from .views import (
    UserRegistrationView,
    StudentSignUpPageView,
    StaffSignUpPageView,
    StaffSignUpPageView,
    LoginPageView,
    UserProfileView,
    CustomLoginView,
)
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    # API Endpoint for registration
    path('register/', UserRegistrationView.as_view(),name='register'),

    # Frontend Pages
    path('signin/', LoginPageView.as_view(), name='signin'),
    path('signup/student/', StudentSignUpPageView.as_view(), name='signup_student'),
    path('signup/staff/', StaffSignUpPageView.as_view(), name='signup_staff'),

    # Profile Endpoint
    path('profile/', UserProfileView.as_view(), name='user_profile'),

    #user sends email and password and gets access and refresh tokens 
    path('login/', CustomLoginView.as_view(), name='token_obtain_pair'),
    #allows a user to send refresh token and get a new access token 
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]