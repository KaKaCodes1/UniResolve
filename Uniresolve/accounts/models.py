from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from organization.models import Department

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
        return self.create_user(email, password, **extra_fields)

# User Model
class User(AbstractUser):
    roles_choices = [
        ('Student', 'Student'),
        ('Staff', 'Staff'),
        ('Admin','Admin'),
    ]

    role = models.CharField(max_length=50, choices=roles_choices, default='Student')
    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=100, blank=False)
    last_name = models.CharField(max_length=100, blank=False)
    
    #Keeping username optional
    username = models.CharField(max_length=100, unique=True, null=True, blank=True)

    # Use email as the login field instead of username
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = [ 'first_name', 'last_name']

    objects = UserManager() #connecting the manager with the User model

    def __str__(self):
        return f"{self.get_full_name()} - {self.role}"
    
#Student Profile
class StudentProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name= 'student_profile')
    reg_number = models.CharField(max_length=20, unique=True)
    program = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.user.get_full_name()} - {self.reg_number}"
    
#Staff Profile
class StaffProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name= 'staff_profile')
    employee_id = models.CharField(max_length=20, unique=True)

    department = models.ForeignKey(
        Department, 
        on_delete=models.PROTECT, # Protect prevents deleting a dept that has staff
        related_name='staff_members',
    )

    def __str__(self):
        return f"{self.user.get_full_name()} - {self.employee_id} - Department({self.department.name})"



    



