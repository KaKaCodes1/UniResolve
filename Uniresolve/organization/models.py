from django.db import models

# Create your models here.
class Department(models.Model):
    department_name = models.CharField(max_length=100)

    def __str__(self):
        return self.department_name

class Category(models.Model):
    category_name = models.CharField(max_length=100)
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name='categories')

    def __str__(self):
        return f"{self.category_name} - Department({self.department.department_name})"
    

class Course(models.Model):
    course_name = models.CharField(max_length=100)
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name='courses')

    def __str__(self):
        return self.course_name
