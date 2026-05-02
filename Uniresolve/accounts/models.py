from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
#Commented to avoid circular imports
# from organization.models import Department, Course

#User Manager
class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("The Email field must be set")
        
        # Normalize the email for consistency ie lowercase the domain name 
        email = self.normalize_email(email)

        #creating a user instance
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff',True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('role', 'Admin')
        return self.create_user(email, password, **extra_fields)

# User Model
class User(AbstractUser):
    roles_choices = [
        ('Student', 'Student'),
        ('Staff', 'Staff'),
        ('Admin','Admin'),
    ]

    role = models.CharField(max_length=20, choices=roles_choices, default='Student')
    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=100, blank=False)
    last_name = models.CharField(max_length=100, blank=False)
    must_change_password = models.BooleanField(default=False)
    
    #username optional
    username = models.CharField(max_length=100, unique=True, null=True, blank=True)

    # Use email as the login field instead of username
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = [ 'first_name', 'last_name']

    objects = UserManager() #connecting the manager with the User model

    def __str__(self):
        return f"{self.get_full_name()}"
    
#Student Profile
class StudentProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name= 'student_profile')
    reg_number = models.CharField(max_length=20, unique=True)
    course = models.ForeignKey(
        'organization.Course',
        on_delete=models.PROTECT,
        related_name='students',
        null=True, 
        blank=True
    )

    def __str__(self):
        return f"{self.user.get_full_name()} - {self.reg_number}"
    
#Staff Profile
class StaffProfile(models.Model):
    #Helps with the escalation workflow
    staff_roles_choices = [
        ('SENIOR', 'Senior'),
        ('STAFF', 'Staff'),
    ]

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name= 'staff_profile')
    employee_id = models.CharField(max_length=20, unique=True)
    staff_role = models.CharField(max_length=20, choices=staff_roles_choices, default='STAFF')
    department = models.ForeignKey(
        'organization.Department', 
        on_delete=models.PROTECT, # Protect prevents deleting a dept that has staff
        related_name='staff_members',
    )

    def __str__(self):
        return f"{self.user.get_full_name()} - {self.employee_id} - Department({self.department.department_name})"


#Notification Model
class Notification(models.Model):
    user = models.ForeignKey(
        User, 
        on_delete=models.CASCADE, 
        related_name='notifications'
    )
    message = models.CharField(max_length=255)
    link = models.CharField(max_length=255, blank=True, null=True, help_text="URL to redirect to when clicked")
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at'] # Shows newest alerts first

    def __str__(self):
        return f"Notification for {self.user.email}: {self.message}"
    



