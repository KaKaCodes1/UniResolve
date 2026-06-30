from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView


from .views import (
    UserRegistrationView,
    # StudentSignUpPageView,
    # StaffSignUpPageView,
    LoginPageView,
    UserProfileView,
    CustomLoginView,
    NotificationListView,
    NotificationMarkReadView,
    ChangePasswordView,
    ForcePasswordChangePageView
)

urlpatterns = [

    # Notification Endpoints
    path('notifications/', NotificationListView.as_view(), name='notifications-list'),
    path('notifications/<int:pk>/read/', NotificationMarkReadView.as_view(), name='notifications-mark-read'),

    # API Endpoint for registration
    path('register/', UserRegistrationView.as_view(),name='register'),
    path('change-password/', ChangePasswordView.as_view(), name='change_password'),

    # Frontend Pages
    path('signin/', LoginPageView.as_view(), name='signin'),
    path('force-change-password/', ForcePasswordChangePageView.as_view(), name='force_password_change'),
    # path('signup/student/', StudentSignUpPageView.as_view(), name='signup_student'),
    # path('signup/staff/', StaffSignUpPageView.as_view(), name='signup_staff'),

    # Profile Endpoint
    path('profile/', UserProfileView.as_view(), name='user_profile'),

    #user sends email and password and gets access and refresh tokens 
    path('login/', CustomLoginView.as_view(), name='token_obtain_pair'),
    #allows a user to send refresh token and get a new access token 
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]