from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager


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

    def __str__(self):
        return self.get_full_name()

    



