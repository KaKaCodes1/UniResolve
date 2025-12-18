from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, StudentProfile, StaffProfile


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    list_display = ('first_name', 'last_name', 'email')
    list_filter = ('role', 'is_staff')
    search_fields = ('first_name', 'last_name', 'email', 'student_profile__reg_number', 'staff_profile__employee_id')

    fieldsets = UserAdmin.fieldsets + (
        ('Custom Fields', {'fields': ('role',)}),
    )
    add_fieldsets = UserAdmin.add_fieldsets + (
        ('Custom Fields', {'fields': ('role',)}),
    )

@admin.register(StudentProfile)
class StudentProfileAdmin(admin.ModelAdmin):
    list_display =('get_user_email', 'get_full_name', 'reg_number', 'program')
    search_fields =('user__email', 'user__first_name', 'reg_number')
    list_select_related =('user',)

    def get_user_email(self,obj):
        return obj.user.email
    #Set the column header name in the admin
    get_user_email.short_description = 'Email'
    #Allow sorting by this column
    get_user_email.admin_order_field = 'user__email'

    def get_full_name(self,obj):
        return f"{obj.user.first_name} {obj.user.last_name}"
    get_full_name.short_description = 'Name'

@admin.register(StaffProfile)
class StaffProfileAdmin(admin.ModelAdmin):
    list_display = ('get_user_email', 'get_full_name', 'employee_id', 'department')
    search_fields = ('user__email', 'employee_id', 'department__name')
    list_filter = ('department',)
    list_select_related = ('user', 'department')

    def get_user_email(self,obj):
        return obj.user.email
    #Set the column header name in the admin
    get_user_email.short_description = 'Email'
    #Allow sorting by this column
    get_user_email.admin_order_field = 'user__email'

    def get_full_name(self,obj):
        return f"{obj.user.first_name} {obj.user.last_name}"
    get_full_name.short_description = 'Name'
