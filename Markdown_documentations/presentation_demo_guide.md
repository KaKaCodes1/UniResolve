# UniResolve Capstone Presentation & Defense Demonstration Guide

This guide outlines the optimal demonstration flow for your Capstone project presentation and defense of **UniResolve**. The walkthrough is designed to tell a structured story that showcases the business value of the platform while demonstrating its most complex backend mechanisms (SLA clocks, dynamic routing, role-based workflows, and bulk imports).

---

## 👥 Demo Personas Needed
To make the presentation smooth, have three browser windows (or different browsers/incognito windows) logged into different roles:
1. **Student Account**: Represents the end-user reporting issues.
2. **Staff Account (STAFF / Junior Staff)**: Represents the first line of resolution in a department.
3. **Senior Staff Account (SENIOR)**: Represents department managers who handle escalations and transfers.
4. **Admin Account**: Shows system-wide dashboards, configurations, and imports.

---

## 🔄 Scenario 1: Issue Submission & Dynamic Routing
*Shows that the system automatically knows where to send issues without students needing to guess the correct department.*

### Steps:
1. **Submit Academic Issue (Student)**:
   - Log in as the Student.
   - Navigate to **Submit Issue**.
   - Create a ticket with an **Academic Category** (e.g., *Grading Conflict*, *Missing Marks*).
   - **Show during defense**: The ticket is automatically routed to the student's **home department** (determined dynamically from their student profile course).
2. **Submit Non-Academic Issue (Student)**:
   - Create another ticket under a **Non-Academic Category** (e.g., *Hostel Repair*, *Fee Balance Query*).
   - **Show during defense**: The ticket is routed directly to the default department configured for that specific category, bypassing the student's home department.
3. **Show Notifications**:
   - Demonstrate that staff in the target departments immediately receive notifications (both in-app and email) about the new incoming tickets.

---

## ⏳ Scenario 2: SLA Clock Management & the "Pending" Pause
*Demonstrates the core SLA features where the system calculates due dates, pauses the timer, and dynamically adjusts the deadline when resolved.*

### Steps:
1. **View Ticket & Request Info (Staff)**:
   - Log in as the **Junior Staff** member of the assigned department.
   - Open the newly submitted ticket.
   - Point out the **SLA Due Date** (calculated automatically based on the category's standard resolution timeframe, e.g., +48 hours).
   - Submit a resolution with the status set to **PENDING** (e.g., requesting the student upload a missing receipt).
2. **Observe the Clock Pause (Technical Point)**:
   - **Explain to the panel**: Moving the ticket to `PENDING` records a timestamp (`pending_since`) and pauses the SLA countdown.
3. **Submit Additional Information (Student)**:
   - Switch to the Student window. Open the ticket and click **Add Additional Info** (available only for pending tickets).
   - Submit the requested details/attachment.
4. **Observe the Clock Unpause**:
   - Switch back to the Staff window. Note that the ticket status has flipped back to **IN PROGRESS**.
   - **Demonstrate the SLA adjustment**: Show that the **Due Date** has shifted forward by the exact amount of time the ticket spent in the pending state. (The clock was paused, and no resolution time was lost).

---

## 📈 Scenario 3: Internal Escalation vs. Cross-Departmental Transfer
*Showcases cooperation, hierarchy, and departmental queue isolation.*

### Steps:
1. **Internal Escalation (Junior Staff)**:
   - Log in as the **Junior Staff** member.
   - For a complex ticket, select **Escalate**. Enter an escalation reason.
   - Point out that:
     - The ticket status is updated to **ESCALATED**.
     - The ticket disappears from the Junior Staff dashboard queue (or is greyed out/read-only).
     - The **Senior Staff** member of that department receives an escalation notification.
2. **Cross-Departmental Transfer (Senior Staff)**:
   - Log in as the **Senior Staff** member.
   - Open the escalated ticket.
   - Choose **Transfer** and select a target department (e.g., transferring a fee dispute from Registry to Finance) and enter a reason.
   - **Demonstrate SLA Reset**: Point out that transferring the ticket resets the SLA clock. It calculates a new deadline equal to **50% of the new category's timeframe** (with a minimum safety floor of 24 hours) to prevent transferred tickets from instantly breaching deadlines.
   - Check notifications: The Student receives a notification that their issue has moved departments, and Finance staff are notified of a new transfer.

---

## 🔁 Scenario 4: Resolution, Feedback, & Reopening Loop
*Shows the full lifecycle and quality control mechanism.*

### Steps:
1. **Mark as Resolved (Staff)**:
   - Log in as the assigned staff member.
   - Post a resolution feedback note and mark the status as **RESOLVED**.
2. **Submit Negative Feedback / Reopen (Student)**:
   - Log in as the Student. Open the resolved ticket.
   - Submit feedback stating the resolution did not fix the problem (select "Not Satisfied").
   - **Show during defense**: The ticket automatically changes status to **REOPENED**, staff are notified, and the SLA clock is reset (using the 50% timeframe / 24-hour floor rule) so staff have a fresh, prioritized deadline to fix the issue.
3. **Mark as Resolved (Staff) & Accept (Student)**:
   - Resolve the issue again.
   - Log in as the Student and submit positive feedback ("Satisfied").
   - Show that the ticket is now permanently **CLOSED**.

---

## 📊 Scenario 5: Administrative Oversight & System Utility
*Demonstrates system health tracking, analytics, and operational efficiency.*

### Steps:
1. **Admin Dashboard Analytics**:
   - Log in as the **Admin**.
   - Show the **Dashboard Charts**:
     - Status breakdown (Donut/Pie Chart).
     - Critical (overdue) ticket rate.
     - Category volume distribution (Bar Chart).
     - Trends comparing this week vs. last week (e.g. resolution rate increase/decrease).
2. **Critical Tickets Management**:
   - Show the **Critical Tickets** page which filters tickets that have breached their SLAs and are overdue. Explain how the background `auto_escalate_overdue_tickets` task flags these and sends urgent alerts.
3. **Bulk Import (Excel)**:
   - Navigate to the **Bulk Import** tool.
   - Explain how a new semester or academic year onboarding is done at scale.
   - Upload a test Excel sheet using the template. Explain the safety validation: the import runs inside a **database transaction**, meaning if even one row is corrupt (e.g., invalid email format, missing course), the entire operation rolls back, preventing partial or dirty imports.
   - Show that newly imported users have `must_change_password = True` set, forcing them to update credentials on their first login.

---

## 🛠️ Key Technical Features to Highlight (Your "A+ Answers")
When the examiners ask you about the complexity of your system, highlight these backend designs:
1. **Django Signals & Save Hook Overrides**: The SLA calculations are handled directly inside the `Ticket` model's `.save()` method. This ensures that no matter how a ticket's status is modified (API, django admin, or script), the SLA integrity is always maintained.
2. **Database Transactions (`transaction.atomic`)**: Crucial workflows like submitting feedback (which updates ticket state and creates notifications) and Excel imports are wrapped in atomic transactions to guarantee data consistency.
3. **Query-Driven Background Triggers**: Since standard cron jobs can be unreliable on basic hosting, features like `auto_escalate_overdue_tickets` and `issue_deadline_warnings` run inline whenever dashboards are loaded, ensuring deadlines are evaluated without needing separate daemon processes.
4. **Departmental & Role-based Data Isolation**: Custom QuerySets in `TicketViewSet` ensure that junior staff are restricted from seeing senior escalated issues, and users can only view tickets within their authorized domains.
