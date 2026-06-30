from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
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

router = DefaultRouter()
router.register(r'admin', AdminViewSet, basename='admin')
router.register(r'users', UsersViewSet, basename='user')

urlpatterns = [
    # Router URLs
    path('', include(router.urls)),

    # Frontend Pages
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
]
