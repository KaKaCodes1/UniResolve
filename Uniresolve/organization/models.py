from django.db import models

# Create your models here.
class Department(models.Model):
    department_name = models.CharField(max_length=100)

    def __str__(self):
        return self.department_name

class Category(models.Model):
    category_name = models.CharField(max_length=100)
    department = models.ForeignKey(Department, on_delete=models.SET_NULL, null=True, blank=True, related_name='categories')
    is_academic = models.BooleanField(
        default=False, 
        help_text="If True, issues in this category are routed to the student's home department first."
    )
    resolution_timeframe = models.PositiveIntegerField(
        default=48, 
        help_text="Expected timeframe (in hours) to resolve issues in this category."
    )

    def __str__(self):
        return f"{self.category_name}"

class Course(models.Model):
    course_name = models.CharField(max_length=100)
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name='courses')

    def __str__(self):
        return self.course_name
