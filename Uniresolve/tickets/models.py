from django.db import models
from django.conf import settings #To be able to reference the User model
# Create your models here.
class Ticket(models.Model):
    status_choices = [
        ('OPEN', 'open'),
        ('PENDING', 'pending'),
        ('RESOLVED','resolved'),
        ('ESCALATED','escalated'),
    ]
    title = models.CharField(max_length=200)
    description = models.TextField()
    attachment = models.FileField(upload_to='ticket_attachments/', null=True, blank=True)
    status = models.CharField(max_length=20, choices=status_choices, default='OPEN')
    is_escalated = models.BooleanField(default=False)
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='tickets'
    )
    category = models.ForeignKey(
        'organization.Category', # Using string reference to avoid circular imports
        on_delete=models.PROTECT, #Prevent deletion of a category and yet there are tickets in that category
        related_name='tickets'
    )
    current_department = models.ForeignKey(
        'organization.Department',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='active_tickets',
        help_text="The department currently responsible for reviewing this ticket."
    )
    due_date = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.title} - {self.status}"

class Resolution(models.Model):
    feedback = models.TextField()
    ticket = models.ForeignKey(
        Ticket,
        on_delete=models.PROTECT, # PROTECT means you CANNOT delete a ticket if it has a resolution. For record-keeping
        related_name='resolutions'
    )
    #staff who resolved it
    resolved_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name="resolutions_provided"
    )
    resolved_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Resolution for {self.ticket.title}"
