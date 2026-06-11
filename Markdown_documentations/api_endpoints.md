# UniResolve API & Route Reference

This document provides a comprehensive list of all API endpoints, frontend template views, and routing structures configured in the **UniResolve** project.

---

## 1. Accounts & User Management

**Base URL Prefix**: `/api/accounts/`

### JSON API Endpoints

| URL Pattern | Method | Handler / View | Description | Permissions |
| :--- | :--- | :--- | :--- | :--- |
| `/login/` | `POST` | [CustomLoginView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/views.py#L55) | Authenticates user using email and password, logs them into session, and returns JWT access and refresh tokens. | Allow Any |
| `/token/refresh/` | `POST` | `TokenRefreshView` | Refreshes JWT access token using a refresh token. | Allow Any |
| `/profile/` | `GET` | [UserProfileView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/views.py#L19) | Retrieves profile details of the currently authenticated user. | Authenticated Users |
| `/register/` | `POST` | [UserRegistrationView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/views.py#L12) | Registers a new user. | Admin Only |
| `/change-password/` | `PUT` / `PATCH` | [ChangePasswordView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/views.py#L95) | Changes the password of the current authenticated user and clears the `must_change_password` flag. | Authenticated Users |
| `/notifications/` | `GET` | [NotificationListView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/views.py#L74) | Lists all notifications for the currently logged-in user. | Authenticated Users |
| `/notifications/<int:pk>/read/` | `PUT` / `PATCH` | [NotificationMarkReadView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/views.py#L82) | Marks a specific notification as read. | Owner of notification |
| `/users/` | `GET` | [UsersViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L227) (list) | Lists all user accounts. | Authenticated Users |
| `/users/<int:pk>/` | `GET` | [UsersViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L227) (retrieve) | Retrieves specific user account details. | Authenticated Users |
| `/users/all_staff/` | `GET` | [UsersViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L234) (`all_staff`) | Retrieves paginated staff users. Query filters: `staff_role`, `department`, `status`, `search`. | Admin Only |
| `/users/all_students/` | `GET` | [UsersViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L289) (`all_students`) | Retrieves paginated student users. Query filters: `status`, `department`, `course`, `search`. | Admin Only |
| `/users/<int:pk>/update_user/` | `PATCH` | [UsersViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L346) (`update_user`) | Updates `is_active` status and `staff_role` (for staff users). | Admin Only |
| `/admin/download_template/` | `GET` | [AdminViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L390) (`download_template`) | Downloads an Excel template for bulk-importing students/staff. Query param: `role`. | Admin Only |
| `/admin/bulk_import/` | `POST` | [AdminViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L407) (`bulk_import`) | Uploads an Excel file to bulk-import student or staff accounts under transaction safety. | Admin Only |
| `/admin/all-issues/` | `GET` | [AdminViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L543) (`get_all_issues`) | Retrieves a paginated list of all tickets. Filters: `status`, `category`, `department`, `search`. | Admin Only |
| `/admin/critical-tickets/` | `GET` | [AdminViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L604) (`get_critical_tickets`) | Retrieves a paginated list of overdue, unresolved tickets. Filters: `category`, `department`, `search`. | Admin Only |
| `/admin/all-resolutions/` | `GET` | [AdminViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L665) (`all_resolutions`) | Retrieves a paginated list of resolutions. Filters: `status`, `department`, `search`. | Admin Only |

### Frontend Template Pages (HTML)

| URL Pattern | View Class | Renders Template File | Purpose |
| :--- | :--- | :--- | :--- |
| `/signin/` | [LoginPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/views.py#L49) | `accounts/login.html` | Page for user sign in / authentication |
| `/force-change-password/` | [ForcePasswordChangePageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/views.py#L52) | `accounts/force_change_password.html` | Enforces update password on first login |
| `/admin-dashboard/` | [AdminDashboardPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L30) | `accounts/admin/admin_dashboard.html` | Admin Main dashboard (stats, chart data, approvals) |
| `/admin-dashboard/all-staff/` | [AdminAllStaffPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L141) | `accounts/admin/admin_allstaff.html` | Admin Manage staff dashboard UI |
| `/admin-dashboard/all-students/` | [AdminAllStudentsPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L154) | `accounts/admin/admin_allstudents.html` | Admin Manage students dashboard UI |
| `/admin-dashboard/all-issues/` | [AdminAllIssuesPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L175) | `accounts/admin/admin_allissues.html` | Admin tickets oversight dashboard UI |
| `/admin-dashboard/critical-tickets/`| [AdminCriticalTicketsPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L189) | `accounts/admin/admin_critical_tickets.html`| Overdue tickets oversight dashboard UI |
| `/admin-dashboard/all-resolutions/`| [AdminAllResolutionsPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L202) | `accounts/admin/admin_allresolutions.html`| Admin resolutions list dashboard UI |
| `/admin-dashboard/bulk-import/` | [AdminBulkImportPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L167) | `accounts/admin/bulk_import.html` | Admin upload interface for student/staff Excel lists |
| `/admin-dashboard/manage-departments/`| [AdminManageDepartmentsPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L215)| `accounts/admin/manage_departments.html` | UI to manage university departments |
| `/admin-dashboard/manage-courses/` | [AdminManageCoursesPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L219) | `accounts/admin/manage_courses.html` | UI to manage courses |
| `/admin-dashboard/manage-issue-categories/`| [AdminManageIssueCategoriesPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L223)| `accounts/admin/manage_issue_categories.html`| UI to manage issue/ticket categories |
| `/admin-dashboard/ticket/<str:ticket_id>/`| [AdminTicketDetailView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/accounts/admin_views.py#L171) | `accounts/admin/admin_ticket_detail.html` | Specific ticket details & resolution history for Admin |

---

## 2. Issues & Tickets Management

**Base URL Prefix**: `/api/v1/`

### JSON API Endpoints

| URL Pattern | Method | Handler / View | Description | Permissions |
| :--- | :--- | :--- | :--- | :--- |
| `/tickets/` | `GET` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L183) (list) | Retrieves tickets. Students see own tickets; Staff/Senior Staff see department tickets (unescalated only for Staff); Admins see all. | Authenticated Users |
| `/tickets/` | `POST` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L290) (create) | Submits a new issue. Auto-calculates `due_date` and handles dynamic routing. | Students Only |
| `/tickets/<int:pk>/` | `GET` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L183) (retrieve) | Retrieves full details for a specific ticket. | Authenticated Users |
| `/tickets/<int:pk>/` | `PUT`/`PATCH`| [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L183) (update) | Modifies a ticket's fields. | Authenticated Users |
| `/tickets/<int:pk>/` | `DELETE` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L183) (destroy) | Deletes a ticket from the system. | Authenticated Users |
| `/tickets/dashboard_stats/` | `GET` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L214) (`dashboard_stats`) | Returns basic ticket statistics (total, open, pending, resolved) for students. | Students Only |
| `/tickets/staffdashboard_stats/` | `GET` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L233) (`staffdashboard_stats`) | Returns department queue stats and incoming tickets for regular staff. | Staff Only |
| `/tickets/seniorstaffdashboard_stats/`| `GET` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L264) (`seniorstaffdashboard_stats`)| Returns department queue stats (including escalated) for senior staff. | Senior Staff Only |
| `/tickets/all_issues/` | `GET` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L323) (`all_issues`) | Paginated listing of department tickets. Supports filters (`status`, `category`) and `search`. | Staff Only |
| `/tickets/<int:pk>/submit_feedback/`| `POST` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L396) (`submit_feedback`) | Submits user satisfaction feedback. Closes ticket if satisfied; reopens it if unsatisfied. | Ticket Owner Only |
| `/tickets/<int:pk>/add_additional_info/`| `POST`| [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L435) (`add_additional_info`)| Adds text clarification to a pending ticket, changing status back to `IN_PROGRESS`. | Ticket Owner Only |
| `/tickets/<int:pk>/escalate_ticket/`| `POST` | [TicketViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L477) (`escalate_ticket`) | Escalates ticket. Regular staff escalates internally (`is_escalated=True`). Senior/Staff can transfer to another department. | Staff Only |
| `/resolutions/` | `GET` | [ResolutionViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L613) (list) | Lists resolution logs. | Authenticated Users |
| `/resolutions/` | `POST` | [ResolutionViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L618) (create) | Submits a new resolution update (which changes the ticket status to Pending, In Progress, Resolved, or Rejected). | Staff Only |
| `/resolutions/<int:pk>/` | `GET` | [ResolutionViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L613) (retrieve) | Retrieves specific resolution details. | Authenticated Users |
| `/resolutions/all_resolutions/`| `GET` | [ResolutionViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L668) (`all_resolutions`)| Paginated resolutions filters. Staff see own logs; Senior staff see department logs. Filters: `status`, `staff`, `search`. | Staff Only |

### Frontend Template Pages (HTML)

| URL Pattern | View Class | Renders Template File | Purpose |
| :--- | :--- | :--- | :--- |
| `/submit-issue/` | [SubmitIssuePageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L41) | `tickets/submit_issue.html` | Page for students to submit a new issue ticket |
| `/my-history/` | [MyHistoryPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L89) | `tickets/my_history.html` | Lists historical issues submitted by logged-in student |
| `/ticket/<int:pk>/` | [TicketDetailPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L93) | `tickets/ticket_detail.html` | Displays a single ticket's timeline details, feedback, & additional info form |
| `/profile/` | [ProfilePageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L50) | `tickets/profile.html` | Standard account settings page for students and staff |
| `/student-dashboard/` | [StudentDashboardPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L66) | `tickets/student_dashboard.html` | Student Main Dashboard (Ticket summary stats & recent logs) |
| `/staff-dashboard/` | [StaffDashboardPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L101) | `tickets/staff_dashboard.html` | Regular staff dashboard (Department metrics & incoming queue) |
| `/staff-dashboard/ticket/<int:pk>/`| [StaffTicketDetailPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L97)| `tickets/staff_ticket_detail.html` | Detailed ticket investigation view, resolve form, transfer form |
| `/staff-dashboard/all-issues/`| [StaffAllIssuesPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L150) | `tickets/staff_all_issues.html` | Department issues list view for Staff |
| `/staff-dashboard/all-resolutions/`| [AllResolutionsPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L166) | `tickets/all_resolutions.html` | Department historical resolution list view for Staff |
| `/senior-staff-dashboard/` | [SeniorStaffDashboardPageView](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/tickets/views.py#L125)| `tickets/senior_staff_dashboard.html`| Senior staff dashboard (Overview including escalated items) |

---

## 3. Organization Configuration

**Base URL Prefix**: `/api/v1/orgs/`

### JSON API Endpoints

All actions modify settings and configurations for the platform (departments, courses, categories).
* **Safe Methods (GET/Head/Options)**: Accessible by all authenticated users.
* **Write Methods (POST/PUT/PATCH/DELETE)**: Restricted to users with the **Admin** role.

| URL Pattern | Method | Handler / View | Description |
| :--- | :--- | :--- | :--- |
| `/departments/` | `GET` | [DepartmentViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L11) (list) | Retrieves lists of all departments. |
| `/departments/` | `POST` | [DepartmentViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L11) (create) | Creates a new department. |
| `/departments/<int:pk>/` | `GET` | [DepartmentViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L11) (retrieve) | Retrieves department details. |
| `/departments/<int:pk>/` | `PUT`/`PATCH`/`DELETE` | [DepartmentViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L11) (update/destroy)| Modifies or deletes department configurations. |
| `/categories/` | `GET` | [CategoryViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L16) (list) | Retrieves lists of issue categories. Supports query filtering by department (`?department=<id>`). |
| `/categories/` | `POST` | [CategoryViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L16) (create) | Creates a new issue category. |
| `/categories/<int:pk>/` | `GET` | [CategoryViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L16) (retrieve) | Retrieves issue category details. |
| `/categories/<int:pk>/` | `PUT`/`PATCH`/`DELETE` | [CategoryViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L16) (update/destroy) | Modifies or deletes category configurations. |
| `/courses/` | `GET` | [CourseViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L29) (list) | Retrieves list of courses. Supports query filtering by department (`?department=<id>`). |
| `/courses/` | `POST` | [CourseViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L29) (create) | Creates a new course. |
| `/courses/<int:pk>/` | `GET` | [CourseViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L29) (retrieve) | Retrieves course details. |
| `/courses/<int:pk>/` | `PUT`/`PATCH`/`DELETE` | [CourseViewSet](file:///c:/Users/USER/Desktop/Capstone_project/Uniresolve/organization/views.py#L29) (update/destroy) | Modifies or deletes course configurations. |

---

## 4. Other Built-in Routes

| URL Pattern | Handler | Purpose |
| :--- | :--- | :--- |
| `/admin/` | `django.contrib.admin.site.urls` | Built-in Django administrative panel dashboard for system developers/superusers |
| `/media/` | `django.conf.urls.static.static` | Serves uploaded media attachments (enabled in `DEBUG` mode only) |
