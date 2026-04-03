from django.utils import timezone
from ..models import Ticket, Resolution
from accounts.models import Notification
from django.contrib.auth import get_user_model

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
        # Prepare resolution objects and update tickets individually so .save() logic runs
        for ticket in overdue_tickets:
            ticket.is_escalated = True
            ticket.status = 'ESCALATED'
            ticket.save() # This triggers the SLA recalculation in models.py
            
            #Create notification message for Student
            Notification.objects.create(
                user=ticket.owner,
                message=f'Your ticket "#{ticket.id}" status was updated to ESCALATED through auto-escalation.',
                link=f'/api/v1/ticket/{ticket.id}/'
            )
            
            # Notify SENIOR staff (link to ticket)
            User = get_user_model()
            senior_users = User.objects.filter(staff_profile__department=ticket.current_department, staff_profile__staff_role='SENIOR')
            senior_notifications = [
                Notification(
                    user=su,
                    message=f'Ticket "#{ticket.id}" was AUTO-ESCALATED to Senior Staff due to deadline breach.',
                    link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
                ) for su in senior_users
            ]
            if senior_notifications:
                Notification.objects.bulk_create(senior_notifications)

            # Notify REGULAR staff (link to all issues)
            regular_users = User.objects.filter(staff_profile__department=ticket.current_department, staff_profile__staff_role='STAFF')
            regular_notifications = [
                Notification(
                    user=ru,
                    message=f'Ticket "#{ticket.id}" was AUTO-ESCALATED to Senior Staff due to deadline breach.',
                    link='/api/v1/staff-dashboard/all-issues/'
                ) for ru in regular_users
            ]
            if regular_notifications:
                Notification.objects.bulk_create(regular_notifications)
            
            resolutions.append(Resolution(
                ticket=ticket,
                resolved_by=None,  # System generated
                status='ESCALATED',
                feedback="[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically."
            ))
        
        # Bulk Create Resolutions
        if resolutions:
            Resolution.objects.bulk_create(resolutions)
