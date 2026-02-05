from django.urls import path, include

from .views import (
    UserRegistrationView,
    StudentSignUpPageView,
    StaffSignUpPageView,
    LoginPageView,
    UserProfileView,
    CustomLoginView,
    AdminDashboardPageView,
    AdminAllUsersPageView,
    AdminAllIssuesPageView,
    AdminAllResolutionsPageView,
    AdminViewSet,
    UserViewSet,
)
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'admin', AdminViewSet, basename='admin')
router.register(r'users', UserViewSet, basename='user')

urlpatterns = [
    # Router URLs
    path('', include(router.urls)),

    # API Endpoint for registration
    path('register/', UserRegistrationView.as_view(),name='register'),

    # Frontend Pages
    path('signin/', LoginPageView.as_view(), name='signin'),
    path('signup/student/', StudentSignUpPageView.as_view(), name='signup_student'),
    path('signup/staff/', StaffSignUpPageView.as_view(), name='signup_staff'),
    path('admin-dashboard/', AdminDashboardPageView.as_view(), name='admin_dashboard'),
    path('admin-dashboard/all-users/', AdminAllUsersPageView.as_view(), name='admin_all_users'),
    path('admin-dashboard/all-issues/', AdminAllIssuesPageView.as_view(), name='admin_all_issues'),
    path('admin-dashboard/all-resolutions/', AdminAllResolutionsPageView.as_view(), name='admin_all_resolutions'),

    # Profile Endpoint
    path('profile/', UserProfileView.as_view(), name='user_profile'),

    #user sends email and password and gets access and refresh tokens 
    path('login/', CustomLoginView.as_view(), name='token_obtain_pair'),
    #allows a user to send refresh token and get a new access token 
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]