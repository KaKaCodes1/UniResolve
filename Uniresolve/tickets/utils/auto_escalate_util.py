from django.utils import timezone
from ..models import Ticket, Resolution

def auto_escalate_overdue_tickets():
    """
    Finds all tickets that are past their due date and haven't been resolved, 
    and automatically escalates them. Uses bulk operations for performance.
    """
    overdue_tickets = Ticket.objects.filter(
        due_date__lt=timezone.now(),
        status__in=['OPEN', 'IN_PROGRESS', 'TRANSFERRED', 'REOPENED'],
        is_escalated=False
    )
    
    if overdue_tickets.exists():
        resolutions = []
        # Prepare resolution objects to log the system action
        for ticket in overdue_tickets:
            resolutions.append(Resolution(
                ticket=ticket,
                resolved_by=None,  # System generated
                status='ESCALATED',
                feedback="[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically."
            ))
            
        # Bulk Update Tickets
        overdue_tickets.update(is_escalated=True, status='ESCALATED')
        
        # Bulk Create Resolutions
        if resolutions:
            Resolution.objects.bulk_create(resolutions)
