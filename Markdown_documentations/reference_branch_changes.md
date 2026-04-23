# Reference Branch Documentation: Project Evolution

This document provides a detailed, chronological account of all changes made on the `reference` branch of the UniResolve project. The `reference` branch contains key implementations for user management, issue tracking, and UI enhancements.

---

## 📅 Initial Setup & Core Models (Jan 19, 2026)

### 1. `e39519f`: Core Organization & Course Models
- **Summary**: Initialized the `Course` table and updated the `organization` app models.
- **Key Changes**:
    - Created the `Course` model to link students to their respective academic programs.
    - Updated `organization` models to reflect the relationship between departments and courses.
    - Added `escalated` as a valid status for issues, allowing for a more complex resolution workflow.

### 2. `36ea28c`: Profile Enhancements
- **Summary**: Linked profiles to courses and roles.
- **Key Changes**:
    - Added `course` field to `StudentProfile`.
    - Added `staff_roles` to `StaffProfile` to define specific responsibilities (e.g., Head of Department, Admin).

### 3. `fed64b7`: Admin Registration
- **Summary**: Registered new models with the Django Admin.
- **Key Changes**:
    - Enabled administrative management of the `Course` model.

### 4. `444c86d`: Reference Code Integration
- **Summary**: Added placeholder and reference logic for upcoming features.

### 5. `64c233b`: User Admin UI Improvements
- **Summary**: Enhanced the user list view in the Django admin.
- **Key Changes**:
    - Added `role` to the list display for the Custom User model, making it easier to identify user types at a glance.

---

## 🔑 Authentication & User Onboarding (Jan 19 - Jan 21, 2026)

### 6. `f5c32fd`: Serializer Updates for Courses
- **Summary**: Updated serializers to include course information.
- **Key Changes**:
    - Ensured that user data returned by the API includes the student's enrolled course.

### 7. `e61f4a2`: TemplateViews for Sign-Up
- **Summary**: Set up the backend views for multi-step sign-up pages.
- **Key Changes**:
    - Integrated `TemplateView` to serve localized sign-up forms for students and staff.

### 8. `bf3cf8e`: Sign-Up Frontend Implementation
- **Summary**: Developed the UI/UX for user registration.
- **Key Changes**:
    - Implemented clean, responsive HTML/CSS for the sign-up pages.

### 9. `24974fb`: Routing for Sign-Up
- **Summary**: Defined URL paths for registration.
- **Key Changes**:
    - Added explicit paths for student and staff sign-up workflows.

### 10. `ffc25c7`: Password Validation Logic
- **Summary**: Enhanced security during registration.
- **Key Changes**:
    - Implemented client-side and server-side password strength validation.

---

---

## 🔒 Authentication & Security Enhancements (Jan 19 - Jan 23, 2026)

### 11. `cd9f2bf`: Login Implementation
- **Summary**: Developed the secure login system.
- **Key Changes**:
    - Created the `LoginView` to handle standard Django authentication.
    - Integrated logic to return JWT tokens (Access and Refresh) for frontend state management.

### 12. `49c7ab5`: Password Visibility Toggle
- **Summary**: Improved login/sign-up UX.
- **Key Changes**:
    - Added a "show/hide password" feature using vanilla JavaScript on all authentication forms.

### 13. `59885ea`: Centralized `auth.js`
- **Summary**: Created a modular JavaScript utility for authentication.
- **Key Changes**:
    - Formulated `auth.js` to manage storing tokens in `localStorage` and attaching them to API request headers automatically.

### 14. `4f585f3`: Seamless Onboarding Flow
- **Summary**: Improved the transition between registration and login.
- **Key Changes**:
    - Implemented automatic redirection to the login page after a successful sign-up with a success notification.

### 20. `31700f9`: Duplicate Data Validation
- **Summary**: Added strict validation for unique identifiers.
- **Key Changes**:
    - Updated serializers to provide clear error messages when a user attempts to register with an existing Registration Number or Employee ID.

---

## 🎫 Issue Reporting & Tracking (Jan 21 - Jan 23, 2026)

### 15. `46d54b3`: File Attachment Support
- **Summary**: Extended the `Ticket` model to support evidence.
- **Key Changes**:
    - Added an `attachment` field (FileField) to the ticket model, allowing users to upload documents or images related to their issues.

### 16. `e311785`: Submit Issue Interface
- **Summary**: Built the frontend for reporting complaints.
- **Key Changes**:
    - Developed the "Submit Issue" form with category selection and file upload capabilities.

### 18. `bd1637a`: File Type Validation
- **Summary**: Secured file uploads.
- **Key Changes**:
    - Added a custom validator to ensure only PDFs and image files are uploaded, preventing malicious file execution.

### 19. `2981b4d`: Navigation Header Refinement
- **Summary**: UI polish for the global header.
- **Key Changes**:
    - Fixed layout issues where the header would break on smaller screens or when the user had a long name.

---

---

## 📊 Dashboards & Role-Based Logic (Jan 23 - Jan 25, 2026)

### 21. `c1f6502`: Frontend Error Visibility
- **Summary**: Improved the feedback loop for users during form submission.
- **Key Changes**:
    - Enhanced JavaScript event handlers to catch API error responses and display them as user-friendly toast messages or inline alerts.

### 23. `e4c09fb`: Issue History ("My History")
- **Summary**: Developed the historical view for students.
- **Key Changes**:
    - Created a dedicated page for students to view their past and present issues, filtered by status.

### 25. `dd00b25`: Student Dashboard
- **Summary**: Centralized hub for student activity.
- **Key Changes**:
    - Implemented a dashboard layout showing quick stats (Open, Resolved, Pending issues) and a summary of recent activity.

### 27. `9bec2cc`: Staff Dashboard
- **Summary**: Control center for issue resolution.
- **Key Changes**:
    - Built the initial staff-facing dashboard where staff members can view issues assigned to their department.

### 28. `0b8acc7`: Custom Login Data
- **Summary**: Enriched the authentication response.
- **Key Changes**:
    - Modified the login API to return not only tokens but also key user details (Name, Role, Department) to reduce initial load times on the frontend.

### 29. `597b2c2`: Intelligent Redirection
- **Summary**: Automated the post-login experience.
- **Key Changes**:
    - Implemented logic in `auth.js` to automatically route users to `/dashboard/student/` or `/dashboard/staff/` based on their profile data.

---

## 🛠️ Performance & Internal Logic (Jan 24 - Jan 25, 2026)

### 22. `dad05cd`: Token Security Hardening
- **Summary**: Reduced the window of vulnerability for access tokens.
- **Key Changes**:
    - Shortened the JWT access token expiry to 5 minutes, enforcing frequent refresh cycles for better security.

### 30. `fe8485e`: Hybrid Session Management
- **Summary**: Combined API tokens with standard Django sessions.
- **Key Changes**:
    - Initiated a server-side session during the API login process to support legacy components and provide an extra layer of authentication persistence.

---

---

## 🎨 UI Refactoring & Frontend Optimization (Jan 25, 2026)

### 31. `58ee616`: Role-Based Base Templates
- **Summary**: Specialized the layout for different user types.
- **Key Changes**:
    - Introduced `base_student.html` and `base_staff.html` to allow for distinct navigation menus and sidebars per role.

### 34. `0634ab1`: Static File Consolidation
- **Summary**: Moved inline styles and scripts to external files.
- **Key Changes**:
    - Decoupled CSS and JS from HTML templates, improving page load speeds and code readability.

### 39. `5acceb7`: Global Stylesheet
- **Summary**: Unified the design system.
- **Key Changes**:
    - Merged multiple CSS files into a single `styles.css` to reduce HTTP requests and ensure consistent branding.

### 40. `ef6ca31`: CSS Conflict Resolution
- **Summary**: Fixed regression after styles consolidation.
- **Key Changes**:
    - Resolved z-index and spacing issues that appeared after merging stylesheets.

---

## 👩‍🔧 Staff Management & Resolution Flow (Jan 25, 2026)

### 36. `069e685`: Issue Resolution Modal
- **Summary**: Tooling for staff to address complaints.
- **Key Changes**:
    - Created an interactive modal that allows staff to input resolution details, update ticket status, and attach response documents.

### 37. `b373cfb`: Attachment Inspection
- **Summary**: Enabled staff to view evidence.
- **Key Changes**:
    - Implemented a secure view for staff to download or preview attachments uploaded by students.

### 38. `c93ffde`: UI Polish for Attachments
- **Summary**: Iconography and layout improvements.
- **Key Changes**:
    - Added file-type icons (PDF, Image, Doc) to the attachment list for better visual scanning.

### 32. `0283377`: Data Binding Fixes
- **Summary**: Resolved a critical UI bug.
- **Key Changes**:
    - Fixed a JavaScript "undefined" error that prevented department names from loading on the staff dashboard.

---

---

## 🔍 Advanced Reporting & Global Views (Jan 25 - Jan 26, 2026)

### 41. `b63ef51`: "All Issues" Management Page
- **Summary**: Comprehensive view for staff administrators.
- **Key Changes**:
    - Created a master list of all university issues, accessible to authorized staff, to facilitate cross-departmental oversight.

### 42. `5c31f46`: Search & Multi-Filter Logic
- **Summary**: Enhanced data discoverability.
- **Key Changes**:
    - Implemented server-side search (by Ticket ID or Student Name) and filtering (by Status, Category, and Date Range) on the "All Issues" page.

### 43. `b6edb9c`: Resolution Archive
- **Summary**: Public/Staff record of fixed problems.
- **Key Changes**:
    - Developed a view to display all resolved tickets and their respective resolution notes, serving as a knowledge base.

---

## ⚖️ Governance & Notifications (Jan 26 - Feb 3, 2026)

### 46. `b94d5e6`: User Approval Workflow
- **Summary**: Enhanced security for staff accounts.
- **Key Changes**:
    - Implemented an approval flag for staff profiles. Newly registered staff remain inactive until an administrator manually approves their account.

### 47. `56811e1`: Notification System Architecture
- **Summary**: Keeping users informed.
- **Key Changes**:
    - Built the `Notification` model to track system alerts (e.g., "Issue Resolved", "New Issue Assigned") and display them in a real-time notification bell/drawer.

### 49. `74b3a17`: Administrative File Reorganization
- **Summary**: Structural cleanup for scalability.
- **Key Changes**:
    - Moved admin-related templates and logic into a dedicated subdirectory within the `accounts` app, standardizing the project's architecture.

### 51. `3521b47`: Smart Department Extraction
- **Summary**: Finalized data relationship logic.
- **Key Changes**:
    - Updated the `StudentSerializer` to automatically infer and display the student's primary department based on their enrolled course, eliminating redundant data entry.

---

## 👑 Advanced Admin Features & Bulk Actions (Feb 4 - Feb 21, 2026)

### 52. `b8a953b`: User Pagination
- **Summary**: Handled large lists of users.
- **Key Changes**:
    - Worked on pagination for the "All Users" page to optimize loading speeds.

### 53. `7f09ee6`: Changes Documentation
- **Summary**: Historical tracking.
- **Key Changes**:
    - Added an md detailing the changes made.

### 54. `4fe5ee5` & `47af3f5`: Admin Issue Portals
- **Summary**: Comprehensive issue insight for administrators.
- **Key Changes**:
    - Worked on the admin dashboard to see all issues submitted in the system.
    - Started working on the all resolutions page to track successfully closed tickets.

### 55. `3a15a04` & `b1c0806`: Resolution Display & Styling
- **Summary**: UI improvements for tracking resolved issues.
- **Key Changes**:
    - Finalized the display of resolutions on the admin panel.
    - Fixed styling on the view button for better accessibility.

### 56. `1110cf9`: Project Structure Context
- **Summary**: Developer documentation.
- **Key Changes**:
    - Created the `PROJECT_STRUCTURE.md` file to map out the application architecture.

### 57. `4faf3e0` & `0468902`: Navigation & Refactoring
- **Summary**: UI and codebase cleanliness.
- **Key Changes**:
    - Updated the nav bar to include more options under "Users".
    - Moved admin views to a separate file to improve maintainability.

### 58. `cf2318e`, `bff7009`, `d804f57`, `4880bdb`, `fcc5a21`, `126b033`: Bulk Import Capabilities
- **Summary**: Mass onboarding mechanism for users.
- **Key Changes**:
    - Created an Excel template for bulk user imports.
    - Built the UI with drag-and-drop functionality and role selection buttons.
    - Implemented the bulk import API endpoint and file validator function.
    - Finalized the bulk creation of user accounts.

### 59. `bb49cce`: Admin Styling Consolidation
- **Summary**: CSS optimization.
- **Key Changes**:
    - Consolidated administrative styles into one file to clean up the templates.

### 60. `a47700f`: Mandatory Password Rotation
- **Summary**: Enforced security standards.
- **Key Changes**:
    - Added a `must_change_password` field on the `User` model, requiring a password update upon first login.

---

## ⏱️ Dynamic Routing & Timeframes (Feb 22 - Feb 23, 2026)

### 61. `d1eaf0f`: System Configuration Setup
- **Summary**: Centralized settings management.
- **Key Changes**:
    - Started work on system configuration settings API endpoints.

### 62. `1d027c1`, `d40e961`, `6671eba`: Timeframes & Dynamic Routing Data Models
- **Summary**: Infrastructure for SLAs.
- **Key Changes**:
    - Added new fields (`due_date`, `current_department`) to the Ticket and Category models to support dynamic routing and timeframes.
    - Updated serializers and `admin.py` to expose these new fields.

### 63. `118641e`, `c33404c`: SLA Calculations
- **Summary**: Resolution timeframe implementation.
- **Key Changes**:
    - Updated views to calculate `due_date` automatically.
    - Added features to display resolution timeframes in the frontend.

### 64. `da2e72a`, `50206ba`, `b113a3a`: Cross-Departmental Tracking
- **Summary**: Handling issue handoffs.
- **Key Changes**:
    - Included logic for cross-department transfers in the APIs.
    - Added `current_department` to filters for admin pages.
    - Built a script for fixing old tickets to patch their data with the new fields.

---

## 🚀 Escalation & Senior Staff Views (Feb 23 - Feb 24, 2026)

### 65. `0cda709`, `f06a42b`: Issue Escalation Workflow
- **Summary**: Elevating critical tickets.
- **Key Changes**:
    - Began working on the escalation APIs.
    - Separated the escalation script into its own module for cleaner architecture.

### 66. `e4fbcb2`, `25be11d`, `48c9487`, `b8bdb5d`: Comprehensive Staff/Student Directories
- **Summary**: Enhanced user viewing and role identification.
- **Key Changes**:
    - Displayed all students and staff within the admin panels.
    - Updated logic so different staff roles are visible and fixed a bug with user status displaying incorrectly.
    - Added a uniform styling methodology for the "View All Staff & Students" pages.

### 67. `c722f8f`: Immediate Data Updates
- **Summary**: Quick editing for admins.
- **Key Changes**:
    - Added an "Edit User Details" modal on the admin dashboard, streamlining data management.

### 68. `fba4e70`: Senior Staff Hub
- **Summary**: Specialized oversight.
- **Key Changes**:
    - Developed a dedicated Senior Staff Dashboard for high-level issue tracking and escalated oversight.

---

## 🏁 Conclusion

The `reference` branch continues to serve as the core feature-set of UniResolve. Through these 85 commits, the project has evolved from a basic data model to a fully functional, role-based ticket management system complete with SLA tracking, bulk onboarding, complex issue routing, and a tiered administrative backend.
