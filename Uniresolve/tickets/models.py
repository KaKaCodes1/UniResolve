from django.db import models
from django.conf import settings #To be able to reference the User model
from django.utils import timezone
from datetime import timedelta

# Create your models here.
class Ticket(models.Model):
    status_choices = [
        ('OPEN', 'open'),
        ('PENDING', 'pending'),
        ('RESOLVED','resolved'),
        ('ESCALATED','escalated'),
        ('TRANSFERRED','transferred'),
        ('CLOSED', 'closed'),
        ('REOPENED', 'reopened'),
        ('IN_PROGRESS', 'in progress')
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
    pending_since = models.DateTimeField(null=True, blank=True)

    def save(self, *args, **kwargs):
        if self.pk:
            # Get the previous state of the ticket to compare statuses
            try:
                old_ticket = Ticket.objects.get(pk=self.pk)
                
                # Switching TO PENDING (Pause the clock)
                if self.status == 'PENDING' and old_ticket.status != 'PENDING':
                    if not self.pending_since:
                        self.pending_since = timezone.now()
                        
                # Leaving PENDING TO IN_PROGRESS (Unpause the clock)
                elif old_ticket.status == 'PENDING' and self.status != 'PENDING':
                    # Unpausing the clock
                    if self.pending_since and self.due_date:
                        time_spent_paused = timezone.now() - self.pending_since
                        self.due_date += time_spent_paused
                    self.pending_since = None # Clear the tracker
                    
                # Changing to TRANSFERRED, ESCALATED, or REOPENED (Reset SLA clock)
                if self.status in ['TRANSFERRED', 'ESCALATED', 'REOPENED'] and old_ticket.status != self.status:
                    if self.category:
                        # 50% of the category's standard resolution timeframe
                        half_timeframe_hours = self.category.resolution_timeframe / 2.0
                        
                        # Apply minimum floor of 24 hours
                        final_timeframe_hours = max(half_timeframe_hours, 24.0)
                        
                        self.due_date = timezone.now() + timedelta(hours=final_timeframe_hours)
                        self.pending_since = None # Ensure pending tracker is cleared

            except Ticket.DoesNotExist:
                pass
        else:
            # If a brand new ticket is being created for the first time, set the initial deadline
            if not self.due_date and getattr(self, 'category', None):
                self.due_date = timezone.now() + timedelta(hours=self.category.resolution_timeframe)

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.title} - {self.status}"

class Resolution(models.Model):
    # To track the history, we save the status of the ticket at the exact moment this resolution was created
    status = models.CharField(max_length=20, choices=Ticket.status_choices, default='RESOLVED')
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

class StudentFeedback(models.Model):
    ticket = models.ForeignKey(
        Ticket,
        on_delete=models.PROTECT, # PROTECT means you CANNOT delete a ticket if it has a resolution. For record-keeping
        related_name='student_feedbacks'
    )
    student = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        related_name='feedbacks',
        null=True
    )    
    is_satisfied = models.BooleanField(help_text="True if Yes/Closed, False if No/Reopened")
    comments = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        status = "Satisfied" if self.is_satisfied else "Not Satisfied"
        return f"Feedback for {self.ticket.id} - {status}"

class AdditionalInfo(models.Model):
    ticket = models.ForeignKey(
        Ticket,
        on_delete=models.PROTECT,
        related_name='additional_info'
    )
    added_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name='additional_info_added'
    )
    info = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    attachment = models.FileField(upload_to='additional_info_attachments/', null=True, blank=True)


    def __str__(self):
        return f"Additional Info for {self.ticket.id} by {self.added_by}"
    
