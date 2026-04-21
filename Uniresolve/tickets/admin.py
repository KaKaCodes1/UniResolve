from django.contrib import admin
from .models import Resolution, Ticket, StudentFeedback, AdditionalInfo
# Register your models here.
@admin.register(Ticket)
class TicketAdmin(admin.ModelAdmin):
    list_display = ('title', 'owner', 'category', 'status', 'created_at', 'current_department', 'due_date')
    list_filter = ('status', 'category', 'current_department', 'due_date')
    search_fields = ('title', 'description', 'owner__email')

@admin.register(Resolution)
class ResolutionAdmin(admin.ModelAdmin):
    list_display = ('ticket', 'resolved_by', 'resolved_at', 'ticket__category', 'ticket__owner')
    list_filter = ('ticket__category', 'resolved_by', 'resolved_at')
    search_fields = ('ticket__title', 'resolved_by__email')

@admin.register(StudentFeedback)
class StudentFeedbackAdmin(admin.ModelAdmin):
    list_display = ('ticket', 'student', 'is_satisfied', 'created_at')
    list_filter = ('is_satisfied', 'created_at')
    search_fields = ('ticket__title', 'student__email', 'comments')

@admin.register(AdditionalInfo)
class AdditionalInfoAdmin(admin.ModelAdmin):
    list_display = ('ticket', 'added_by', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('ticket__title', 'added_by__email', 'info')


# admin.site.register(Ticket)
# admin.site.register(Resolution)
# admin.site.register(TicketAdmin)
# admin.site.register(ResolutionAdmin)