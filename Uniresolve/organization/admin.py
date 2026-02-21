from django.contrib import admin
from .models import Department, Category, Course

# Register your models here.
# admin.site.register(Department)
# admin.site.register(Category)
# admin.site.register(Course)

@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = ('department_name',)
    list_filter = ('department_name',)
    search_fields = ('department_name',)

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('category_name', 'department', 'is_academic', 'resolution_timeframe')
    list_filter = ('department','is_academic','resolution_timeframe')
    search_fields = ('category_name',)


@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ('course_name', 'department')
    list_filter = ('department',)
    search_fields = ('course_name',)

