from django.contrib import admin
from .models import Department, Category, Course

# Register your models here.
admin.site.register(Department)
admin.site.register(Category)
admin.site.register(Course)
