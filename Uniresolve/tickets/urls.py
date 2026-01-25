from django.urls import path, include
from .views import (
    TicketViewSet,
    ResolutionViewSet,
    SubmitIssuePageView,
    MyHistoryPageView,
    ProfilePageView,
    StudentDashboardPageView,
    StaffDashboardPageView,
    StaffAllIssuesPageView,
)
from rest_framework.routers import DefaultRouter

#The router will handle creating the appropriate URL patterns
#for all CRUD operations on the Ticket model.
router = DefaultRouter()
router.register(r'tickets',TicketViewSet, basename='ticket')
router.register(r'resolutions', ResolutionViewSet, basename='resolutions')

urlpatterns = [
    path('', include(router.urls)),
    path('submit-issue/', SubmitIssuePageView.as_view(), name='submit_issue'),
    path('my-history/', MyHistoryPageView.as_view(), name='my_history'),
    path('profile/', ProfilePageView.as_view(), name='profile'),
    path('student-dashboard/', StudentDashboardPageView.as_view(), name='student_dashboard'),
    path('staff-dashboard/', StaffDashboardPageView.as_view(), name='staff_dashboard'),
    path('staff-dashboard/all-issues/', StaffAllIssuesPageView.as_view(), name='staff_all_issues'),
]