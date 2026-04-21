from django.urls import path, include

from .views import (
    UserRegistrationView,
    StudentSignUpPageView,
    StaffSignUpPageView,
    LoginPageView,
    UserProfileView,
    CustomLoginView,
    NotificationListView,
    NotificationMarkReadView,
    ChangePasswordView,
    ForcePasswordChangePageView
)
from .admin_views import (
    AdminViewSet,
    UsersViewSet,
    AdminDashboardPageView,
    AdminAllIssuesPageView,
    AdminAllResolutionsPageView,
    AdminBulkImportPageView,
    AdminAllStudentsPageView,
    AdminAllStaffPageView,
    AdminManageDepartmentsPageView,
    AdminManageCoursesPageView,
    AdminManageIssueCategoriesPageView,
    AdminTicketDetailView,
    AdminCriticalTicketsPageView
)
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'admin', AdminViewSet, basename='admin')
router.register(r'users', UsersViewSet, basename='user')

urlpatterns = [
    # Router URLs
    path('', include(router.urls)),

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
    path('admin-dashboard/', AdminDashboardPageView.as_view(), name='admin_dashboard'),
    path('admin-dashboard/all-staff/', AdminAllStaffPageView.as_view(), name='admin_all_staff'),
    path('admin-dashboard/all-students/', AdminAllStudentsPageView.as_view(), name='admin_all_students'),
    path('admin-dashboard/all-issues/', AdminAllIssuesPageView.as_view(), name='admin_all_issues'),
    path('admin-dashboard/critical-tickets/', AdminCriticalTicketsPageView.as_view(), name='admin_critical_tickets'),
    path('admin-dashboard/all-resolutions/', AdminAllResolutionsPageView.as_view(), name='admin_all_resolutions'),
    path('admin-dashboard/bulk-import/', AdminBulkImportPageView.as_view(), name='admin_bulk_import'),
    path('admin-dashboard/manage-departments/', AdminManageDepartmentsPageView.as_view(), name='admin_manage_departments'),
    path('admin-dashboard/manage-courses/', AdminManageCoursesPageView.as_view(), name='admin_manage_courses'),
    path('admin-dashboard/manage-issue-categories/', AdminManageIssueCategoriesPageView.as_view(), name='admin_manage_issue_categories'),
    path('admin-dashboard/ticket/<str:ticket_id>/', AdminTicketDetailView.as_view(), name='admin_ticket_detail'),

    # Profile Endpoint
    path('profile/', UserProfileView.as_view(), name='user_profile'),

    #user sends email and password and gets access and refresh tokens 
    path('login/', CustomLoginView.as_view(), name='token_obtain_pair'),
    #allows a user to send refresh token and get a new access token 
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]