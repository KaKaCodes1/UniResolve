# UniResolve: Defense Survival & Study Guide

Welcome to your final-year project defense prep! This guide translates your system snapshot into a structured, easy-to-digest cheat sheet. Keep this open during your presentation. If a panelist asks you to explain a feature or show the code, refer to the exact paths and "Flex Points" below.

---

## 1. Authentication & Captive Portal
**The Elevator Pitch:** Secure, token-based authentication that forces newly imported users to change their default, auto-generated passwords before they can access the system.
**The Data Flow:** 
1. Frontend submits credentials to the backend.
2. Backend validates and returns a JWT. 
3. If the token's payload contains `must_change_password: true`, the frontend immediately redirects the user to the captive portal. 
4. User submits a new complex password, and the backend toggles the flag to `false`.
**Where the Code Lives:** 
- `accounts/views.py` (Look for `CustomLoginView` and `ChangePasswordView`)
- `accounts/serializers.py` (Look for `CustomTokenObtainPairSerializer` where the custom claim is added)
**The "Gotcha" / Flex Point:** *Custom JWT Claims.* Point out that you embedded the `must_change_password` flag directly into the token payload. This saves an entire database query on the frontend and makes the routing instantaneous.

## 2. Ticket Submission & Data Integrity
**The Elevator Pitch:** A streamlined, secure interface for students to submit issues with attachments, where the backend guarantees the identity of the submitter.
**The Data Flow:** 
1. Student fills out the HTML form and adds an attachment.
2. Vanilla JS packages this as `FormData` and sends a POST request.
3. Django DRF intercepts it, extracts the user from the JWT token, automatically links them as the ticket owner, and calculates the initial SLA deadline before saving.
**Where the Code Lives:** 
- `tickets/views.py` (Look for `TicketViewSet.perform_create()`)
**The "Gotcha" / Flex Point:** *Server-Side Ownership Enforcement.* Tell the panel: "I don't trust the frontend to tell me who is submitting the ticket. I use DRF's `perform_create` to extract the owner directly from the authenticated session token, making ID spoofing impossible."

## 3. Smart Routing
**The Elevator Pitch:** An intelligent assignment engine that dynamically routes tickets to the correct department without manual triage.
**The Data Flow:** 
1. A ticket is submitted with a specific `Category` ID.
2. The backend checks the `is_academic` boolean on that Category.
3. If academic (e.g., "Missing Marks"), it routes to the student's specific course department. If non-academic (e.g., "WiFi Down"), it routes to the global category department.
**Where the Code Lives:** 
- `tickets/views.py` (`TicketViewSet.perform_create()`)
- `organization/models.py` (The `Category` model's `is_academic` field)
**The "Gotcha" / Flex Point:** *Decoupled Categorization.* Emphasize how this design prevents hardcoding. A single category like "Missing Marks" dynamically adapts its destination based on *who* the student is, making the system highly scalable for new faculties.

## 4. SLA Management & Time-Tracking
**The Elevator Pitch:** A self-regulating time-tracker that enforces resolution deadlines, pauses the clock when awaiting student feedback, and recalculates time upon escalation.
**The Data Flow:** 
1. A ticket is created, setting `due_date` to `now + X hours`. 
2. If staff marks it `PENDING`, a `pending_since` timestamp is recorded. 
3. When the student replies, the ticket moves to `IN_PROGRESS`, and the time spent paused is mathematically added back to the `due_date`.
**Where the Code Lives:** 
- `tickets/models.py` (Look for the `Ticket.save()` method)
**The "Gotcha" / Flex Point:** *Fat Models, Skinny Views.* Highlight that the SLA math lives inside the `Ticket.save()` override. Explain: "By putting this in the model layer, I guarantee the SLA logic is perfectly enforced whether the ticket is updated via the API, the Django Admin panel, or a future mobile app."

## 5. Request-Driven Automated Escalation
**The Elevator Pitch:** A lightweight automation system that flags overdue tickets and pushes them to senior staff without requiring heavy background cron jobs.
**The Data Flow:** 
1. Staff member logs in and loads their dashboard. 
2. Before returning the data, the backend calls `auto_escalate_overdue_tickets()`. 
3. It scans for tickets where `due_date < now` and `is_escalated=False`, updates their status, logs a system resolution, and issues notifications.
**Where the Code Lives:** 
- `tickets/utils/auto_escalate_util.py`
**The "Gotcha" / Flex Point:** *Lazy Evaluation.* "Instead of running a heavy, continuous background cron job that eats server resources, I implemented request-driven escalation. The system evaluates breaches lazily at the exact moment staff need to see the data, keeping the infrastructure incredibly lean."

## 6. Hybrid Asynchronous Emails
**The Elevator Pitch:** A non-blocking notification engine that routes real emails to whitelisted stakeholders while safely logging testing emails to the console.
**The Data Flow:** 
1. An event triggers an in-app Notification. 
2. `trigger_async_emails` is called, spawning a new Python thread. 
3. The thread checks the recipient against a `.env` whitelist. 
4. It dynamically dispatches via Gmail SMTP if approved, or falls back to the server console.
**Where the Code Lives:** 
- `accounts/utils/email_notification_util.py`
**The "Gotcha" / Flex Point:** *Threading for Performance.* "Sending an SMTP email can take 2-3 seconds. I subclassed Python's `threading.Thread` so the email fires in the background. The user gets their API response in milliseconds, and the frontend never hangs."

## 7. Role-Based Access Control (RBAC) Data Isolation
**The Elevator Pitch:** A multi-tiered security model that strictly segregates data visibility between Students, Regular Staff, Senior Staff, and Admins.
**The Data Flow:** 
1. User requests a list of tickets. 
2. The view inspects `user.role` and `user.staff_profile.staff_role`. 
3. It dynamically alters the Django QuerySet (e.g., Staff only see `current_department=staff_dept` AND `is_escalated=False`).
**Where the Code Lives:** 
- `tickets/views.py` (`TicketViewSet.get_queryset()`)
**The "Gotcha" / Flex Point:** *QuerySet Level Security.* "I didn't just hide buttons on the frontend. I isolated the data at the database query level. Even if a student somehow gets a direct API link to a staff ticket, the backend will return a 404 because that ticket mathematically doesn't exist in their allowed QuerySet."

## 8. Atomic Bulk User Import
**The Elevator Pitch:** A robust admin tool to onboard hundreds of users simultaneously via Excel, featuring built-in rollback protection against corrupt files.
**The Data Flow:** 
1. Admin uploads an `.xlsx` file. 
2. Django parses rows, checking for existing emails/IDs. 
3. It opens a database transaction. If all rows are valid, users are committed. If one row has an error, the entire batch is rejected.
**Where the Code Lives:** 
- `accounts/views.py` (`AdminViewSet.bulk_import`)
**The "Gotcha" / Flex Point:** *Database Atomicity.* Point out your use of `with transaction.atomic():`. "This is a critical enterprise pattern. It guarantees database consistency—meaning I will never end up in a corrupted state where 50 users imported successfully but the other 50 failed."

---

## 💡 Anticipated Panel Questions & Cheat Sheet Answers

**Q1: "Why did you choose Vanilla JS instead of a modern framework like React or Angular?"**
> **A:** "I adhered strictly to the KISS (Keep It Simple, Stupid) principle. For the scope of this project, introducing a heavy frontend framework would have added unnecessary build steps, node_modules bloat, and complexity. Vanilla JS allowed me to build a blazingly fast, lightweight UI while proving to the panel that I have a strong, fundamental mastery of the DOM and JavaScript without needing abstractions to do the work for me."

**Q2: "Why Django REST Framework instead of Node.js or Spring Boot?"**
> **A:** "Django's 'batteries-included' philosophy allowed me to focus purely on the university's business logic. Its built-in ORM, robust admin panel, and enterprise-grade security middleware (like CSRF and XSS protection) provided a highly secure foundation out-of-the-box. When handling sensitive student data, security and maintainability were my top priorities."

**Q3: "How does your system handle SLA deadlines without a continuous background task?"**
> **A:** "I used an event-driven and lazy-evaluation approach. Deadlines are mathematically calculated on save, and any breaches are evaluated at the exact moment a staff member requests their dashboard data. This 'Just-In-Time' architecture achieves the same result as a cron job but requires a fraction of the server resources."

**Q4: "What happens if the email server crashes or Gmail blocks your SMTP request?"**
> **A:** "Because I decoupled the email dispatch into a separate Python background thread, the main request-response cycle is completely insulated. The database transaction will still succeed, the ticket state will update, and the in-app notification will be logged. The user simply won't get the email, but no data is lost and the application does not crash."

**Q5: "How are you securing the API endpoints?"**
> **A:** "Through a defense-in-depth approach. First, JWTs (JSON Web Tokens) with a short 30-minute expiration for stateless authentication. Second, explicit Role checks on every view action. Third, QuerySet isolation to ensure users can only query database rows that belong to them or their department."

Good luck! You've built a highly defensible, structurally sound application. Speak with confidence and guide them to your "Gotcha" flex points!
