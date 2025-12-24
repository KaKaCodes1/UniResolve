# UniResolve - Digital Issue Reporting System (MVP)

**UniResolve** is a backend-focused RESTful API designed to streamline issue reporting for Higher Education Institutions. It allows students to digitally log academic or administrative complaints and enables staff to track, resolve, and provide feedback on these issues.

This project is built as a Minimum Viable Product (MVP) for the ALX Backend Engineering program and serves as the foundation for a Final Year Research Project.

##  Tech Stack
* **Language:** Python 
* **Framework:** Django & Django REST Framework (DRF)
* **Database:** MySQL
* **Authentication:** Token-based (JWT)
* **Tools:** Postman (for testing)

##  Key Features
* **User Authentication:** Secure registration and login for Students.
* **Smart Issue Tracking:** Students can view their own tickets; Staff view department-specific tickets.
* **Ticket Management:** Create, Read, and Update issue details.
* **Resolution Workflow:** Staff can resolve tickets and provide written feedback.

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
