# Project Structure - UniResolve

This document provides an overview of the UniResolve project, detailing the purpose of each app and its key files. This will serve as a map for understanding the codebase and identifying areas for modularization.

## 📂 Project Root
- `manage.py`: Django's command-line utility for administrative tasks.
- `requirements.txt`: Python dependencies for the project.
- `Uniresolve/`: The core project directory.
    - `settings.py`: Global project settings (database, apps, middleware).
    - `urls.py`: Master URL routing configuration.

---

## 📂 `accounts` App
Handles authentication, user profiles (Student/Staff/Admin), and admin-specific management views.

- **Models (`models.py`)**: Defines the `User` model (with `must_change_password` flag for captive portal on first login) and related profiles (`StudentProfile`, `StaffProfile`).
- **Views (`views.py`)**: 
    - API Views: `UserRegistrationView`, `UserViewSet` (User management), `AdminViewSet` (Approval logic and high-level issue views).
    - Features: Bulk Import endpoints for mass user creation.
- **Serializers (`serializers.py`)**: Logic for converting User and Profile models to JSON.
- **Utils (`utils/`)**: Includes `email_notification_util.py` utilizing Python's `threading` for non-blocking asynchronous email notifications.
- **Templates**:
    - `admin_dashboard.html`: The main landing page for administrators.
    - `admin_allusers.html`, `admin_allstaff.html`, `admin_allstudents.html`: User management interfaces.
    - `admin_allissues.html` / `admin_allresolutions.html`: Global view of all system activities.
    - `bulk_import.html`: Interface for Excel-based mass user onboarding.
    - `force_password_change.html`: Captive portal view for first-time login credentials update.

---

## 📂 `tickets` App
The core engine of the system where issues are created, tracked, routed, and resolved.

- **Models (`models.py`)**: `Ticket` (with SLA fields like `due_date` and `current_department`), `Resolution` (the response from staff), and `AdditionalInfo` (follow-up responses from students).
- **Views (`views.py`)**: 
    - API Views: `TicketViewSet` (CRUD for tickets), `ResolutionViewSet` (Resolving logic).
    - Features: Dynamic routing calculations, comprehensive Staff Notifications, and Escalation APIs for high-priority/delayed tickets.
- **Serializers (`serializers.py`)**: JSON mapping for Tickets, Resolutions, and AdditionalInfo.
- **Utils (`utils/`)**: Provides `auto_escalate_util.py` for automated tier escalations when tickets breach SLAs.
- **Templates**:
    - `student_dashboard.html`: View of a student's own tickets.
    - `staff_dashboard.html`: Department-specific queue for staff members.
    - `senior_staff_dashboard.html`: Specialized hub for high-level oversight and escalated issues.
    - `submit_issue.html`: The multi-step issue creation form.
    - Detailed Views: Various split ticket detail templates (e.g., `ticket_detail.html` for students and `staff_ticket_detail.html` for staff).

### 📝 Management Scripts (`tickets/management/commands/`)
- `fix_old_tickets.py` & `fix_resolved_tickets.py`: Data migration scripts written to patch legacy tickets with the new SLA `due_date` and `current_department` fields.
---

## 📂 `organization` App
Provides the structural backbone of the university.

- **Models (`models.py`)**: `Department`, `Category` (linked to departments), and `Course`.
- **Purpose**: These models are used to group staff and route tickets to the correct team.

---

## 🚩 Potential Improvements & Observations

Based on current complexity, here are some areas where modularity and code repetition could be addressed:

### 1. 🔄 Code Repetition in Views
- `AdminViewSet` (`accounts`) and `TicketViewSet` (`tickets`) both have `all_issues` or similar methods. 
- **Suggestion**: Consider centralizing ticket query/filtering logic into a `services.py` or a custom `QuerySet` in `models.py`.

### 2. 📋 Template Fragments
- The dashboards (Student, Staff, Admin) share many UI components (tables, loading spinners, filter bars).
- **Suggestion**: Extract repeated HTML/JS into **Template Tags** or **Partial Templates** (using `{% include %}`) to make the frontend easier to maintain.

### 3. 🛡️ Permission Logic
- Role checks (Admin vs Staff vs Student) are spread across various view methods.
- **Suggestion**: Create custom DRF `BasePermission` classes to enforce these rules consistently at the class level.

### 4. 🔀 App Modularity
- Some "Admin" views for tickets are in `accounts/views.py`, while the ticket models are in `tickets/`.
- **Suggestion**: Moving admin ticket logic into the `tickets` app (perhaps in an `admin_views.py`) might make the app boundaries cleaner.
