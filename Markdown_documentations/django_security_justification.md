# Django Security Justification: Form & Search Bar Protections

When defending the architectural choice of utilizing Django for the backend of UniResolve, its built-in, out-of-the-box security mechanisms can be heavily cited. Below is an outline of every form and search bar in the application, mapping them to the specific Django security features protecting them.

---

## 1. Search Bars
Search functionality is critical for administrative and staff efficiency. The search bars in the system allow users to query active records dynamically.

### Locations of Search Bars
- **Staff Interfaces**:
  - **All Issues (`staff_all_issues.html`)**: Search by ticket ID, subject, student name, or registration number.
  - **All Resolutions (`all_resolutions.html`)**: Search by ticket ID or title.
- **Admin Interfaces**:
  - **All Students (`admin_allstudents.html`)**: Search by name, email, or admission number.
  - **All Staff (`admin_allstaff.html`)**: Search by name, email, or employee ID.
  - **All Issues (`admin_allissues.html`)**: Search by ticket ID, subject, or student name.
  - **All Resolutions (`admin_allresolutions.html`)**: Search by ticket ID, title, or staff name.

### Security Features Implemented (Justification for Django)
**SQL Injection Prevention via Django ORM**:
Unlike traditional backend frameworks where developers might manually construct raw SQL queries (which are highly susceptible to SQL injection attacks), Django relies entirely on its Object-Relational Mapper (ORM).
- Whenever a user enters text into a search bar, Django translates the input into a parameterized query (e.g., `Ticket.objects.filter(title__icontains=search_query)`). 
- The parameters are evaluated as values, not as executable SQL code.
- By relying on the Django ORM, the application is **natively immune to SQL Injection (SQLi)** attacks without requiring complex regex sanitizers or manual character escaping.

---

## 2. System Forms
The application relies on numerous forms for data input ranging from authentication to complex file uploads.

### Locations of Forms
- **Authentication & Onboarding**:
  - **Login Form (`login.html`)**: Authentication entry point.
  - **Signup Forms (`signup_student.html` & `signup_staff.html`)**: Registration forms.
  - **Captive Portal / Password Change (`force_change_password.html`)**: Used for mandatory password updates upon initial login.
- **Ticket Management**:
  - **Submit Issue Form (`submit_issue.html`)**: Core issue creation flow.
  - **Additional Info Form (`ticket_detail.html` / `staff_ticket_detail.html`)**: For back-and-forth communication.
  - **Escalate / Transfer Forms (`staff_ticket_detail.html`)**: Inside Modals.
- **Admin Operations**:
  - **Bulk Import Form (`bulk_import.html`)**: Used for CSV/Excel data onboarding.
  - **Organization Management Forms**: Used to create Categories (`manage_issue_categories.html`), Courses (`manage_courses.html`), and Departments (`manage_departments.html`).

### Security Features Implemented (Justification for Django)

**1. Cross-Site Request Forgery (CSRF) Protection**:
Django enforces strict CSRF protections out-of-the-box.
- **`CsrfViewMiddleware`**: Activated in `settings.py`, this middleware rejects any state-changing requests (`POST`, `PUT`, `DELETE`) that lack a verifiable token.
- **The `{% csrf_token %}` Tag**: Employed across every single HTML form in the system. When a form is rendered, Django injects a cryptographically secure token that the server expects to see returned upon submission.
- **JavaScript Fetch Integrations**: For the dynamically rendered forms in UniResolve, a utility function extracts the CSRF token from a secure, `HttpOnly` cookie and attaches it as an `X-CSRFToken` header. This verifies that requests are genuinely originating from the localized application, completely neutralizing CSRF attempts by malicious third-party websites.

**2. Django REST Framework (DRF) Deserialization & Type Validation**:
All data submitted via these forms hit a DRF endpoint (via `serializers.py`).
- Django's serializers rigidly define data schema types. If a user attempts to inject malicious non-alphanumeric code into an expected Boolean or Integer field (like `category_id`), the Serializer automatically invalidates the submission and triggers a `400 Bad Request`.
- This ensures only "clean", predictable data formats enter the backend pipeline.

**3. Password Hashing Mechanisms**:
When the Signup or Force Change Password forms are submitted, the passwords are never stored in plaintext. They utilize Django's `make_password` utility, leveraging the PBKDF2 algorithm with a SHA256 hash automatically.

---

## What is Left Unprotected? (Self-Awareness for Defense)
A crucial part of defending your architectural design is acknowledging its boundaries. 

While Django protects the **Backend Server** & **Database** perfectly from SQL Injection and CSRF, it does **not** automatically strip script tags from API responses rendered dynamically in JavaScript. 

Because UniResolve’s recent dashboards utilize JavaScript to manually inject HTML (using `.innerHTML`), the system currently lacks **DOM-based XSS (Cross-Site Scripting)** protection in the frontend dashboards. Demonstrating this awareness during your presentation—by stating: *"Django secures the Data Layer and the Request Origin, but I must handle DOM sanitization separately via JavaScript"*—will reflect strong architectural maturity.
