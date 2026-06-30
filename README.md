# UniResolve - Digital Issue Reporting System (MVP)

**UniResolve** is a system designed to streamline issue reporting for Higher Education Institutions. It allows students to digitally log academic or administrative complaints and enables staff to track, resolve, and provide feedback on these issues.

##  Tech Stack
* **Language:** Python 
* **Framework:** Django & Django REST Framework (DRF)
* **Database:** MySQL
* **Authentication:** Token-based (JWT)
* **Asynchronous Tasks:** Threading (for non-blocking email functionality)
* **Tools:** Postman (for testing)

##  Key Features
* **User Authentication:** Secure registration and login for Students and Staff, with a forced password-change captive portal on first login.
* **Smart Issue Tracking:** Students can view their own tickets; Staff view department-specific tickets.
* **Comprehensive Notification System:** Threaded asynchronous email and in-app alerts for system events (SLA deadlines, escalations).
* **Ticket Management & Escalation:** Automated escalation workflows for overdue tickets and proactive deadline warnings.
* **Resolution Workflow:** Staff can resolve/transfer tickets, and request/receive additional information from students seamlessly.

### Installation
1. **Clone the repo:**
   ```bash
   git clone https://github.com/KaKaCodes1/UniResolve.git
   cd UniResolve

2. **Setup Virtual Environment:**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
3. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
4. **Database Configuration: Create a .env file and add your MySQL credentials:**
   * DB_NAME=uniresolve_db
   * DB_USER=root
   * DB_PASSWORD=yourpassword
5. **Migrate and Run:**
   ```bash
   python manage.py migrate
   python manage.py runserver
