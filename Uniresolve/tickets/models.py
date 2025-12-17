from django.db import models
from django.conf import settings #To be able to reference the User model
# Create your models here.
class Ticket(models.Model):
    status_choices = [
        ('OPEN', 'open'),
        ('PENDING', 'pending'),
        ('RESOLVED','resolved'),
    ]
    title = models.CharField(max_length=200)
    description = models.TextField()
    status = models.CharField(max_length=20, choices=status_choices, default='OPEN')
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
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.title} - {self.status}"

class Resolution(models.Model):
    feedback = models.TextField()
    ticket = models.OneToOneField(
        Ticket,
        on_delete=models.PROTECT, # PROTECT means you CANNOT delete a ticket if it has a resolution. For record-keeping
        related_name='resolution'
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
