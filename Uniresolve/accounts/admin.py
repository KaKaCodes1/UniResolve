from django.contrib import admin
from .models import User, StudentProfile, StaffProfile

# Register your models here.
admin.site.register(User)
admin.site.register(StaffProfile)
admin.site.register(StudentProfile)
