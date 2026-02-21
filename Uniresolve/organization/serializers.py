from rest_framework import serializers
from .models import Department, Category, Course

class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = '__all__'

class CategorySerializer(serializers.ModelSerializer):
    department_name = serializers.ReadOnlyField(source='department.department_name')
    class Meta:
        model = Category
        fields = ['id', 'category_name', 'department', 'department_name']

class CourseSerializer(serializers.ModelSerializer):
    department_name = serializers.ReadOnlyField(source='department.department_name')
    class Meta:
        model = Course
        fields = ['id', 'course_name', 'department', 'department_name']
