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

- **Models (`models.py`)**: Defines the `User` model (with roles) and related profiles (`StudentProfile`, `StaffProfile`).
- **Views (`views.py`)**: 
    - API Views: `UserRegistrationView`, `UserViewSet` (User management), `AdminViewSet` (Approval logic and high-level issue views).
    - Template Views: Page renders for Login, Signup, and Admin Dashboards.
- **Serializers (`serializers.py`)**: Logic for converting User and Profile models to JSON.
- **Forms (`forms.py`)**: (If used) Django forms for traditional HTML template processing.
- **Templates**:
    - `admin_dashboard.html`: The main landing page for administrators.
    - `admin_allusers.html`: User management interface.
    - `admin_allissues.html` / `admin_allresolutions.html`: Global view of all system activities.

---

## 📂 `tickets` App
The core engine of the system where issues are created, tracked, and resolved.

- **Models (`models.py`)**: `Ticket` (the issue itself) and `Resolution` (the response from staff).
- **Views (`views.py`)**: 
    - API Views: `TicketViewSet` (CRUD for tickets), `ResolutionViewSet` (Resolving logic).
    - Template Views: Dashboards for Students and Staff, issue submission pages.
- **Serializers (`serializers.py`)**: JSON mapping for Tickets and Resolutions.
- **Templates**:
    - `student_dashboard.html`: View of a student's own tickets.
    - `staff_dashboard.html`: Department-specific queue for staff members.
    - `submit_issue.html`: The multi-step issue creation form.

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
