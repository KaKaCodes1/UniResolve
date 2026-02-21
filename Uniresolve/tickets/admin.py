from django.contrib import admin
from .models import Resolution, Ticket
# Register your models here.
@admin.register(Ticket)
class TicketAdmin(admin.ModelAdmin):
    list_display = ('title', 'owner', 'category', 'status', 'created_at', 'current_department', 'due_date')
    list_filter = ('status', 'category', 'current_department', 'due_date')
    search_fields = ('title', 'description', 'owner__email')

@admin.register(Resolution)
class ResolutionAdmin(admin.ModelAdmin):
    list_display = ('ticket', 'resolved_by', 'resolved_at')

# admin.site.register(Ticket)
# admin.site.register(Resolution)
# admin.site.register(TicketAdmin)
# admin.site.register(ResolutionAdmin)