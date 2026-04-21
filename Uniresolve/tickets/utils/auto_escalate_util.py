from django.utils import timezone
from ..models import Ticket, Resolution
from accounts.models import Notification
from accounts.utils.email_notification_util import trigger_async_emails
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
            notification = Notification.objects.create(
                user=ticket.owner,
                message=f'Your ticket "#{ticket.id}" status was updated to ESCALATED through auto-escalation.',
                link=f'/api/v1/ticket/{ticket.id}/'
            )
            trigger_async_emails([notification])
            
            # Notify SENIOR staff (link to ticket)
            User = get_user_model()
            senior_users = User.objects.filter(
                staff_profile__department=ticket.current_department, 
                staff_profile__staff_role='SENIOR',
                must_change_password=False,
                is_active=True
            )
            senior_notifications = [
                Notification(
                    user=su,
                    message=f'Ticket "#{ticket.id}" was AUTO-ESCALATED to Senior Staff due to deadline breach.',
                    link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
                ) for su in senior_users
            ]
            if senior_notifications:
                Notification.objects.bulk_create(senior_notifications)
                trigger_async_emails(senior_notifications)

            # Notify REGULAR staff (link to all issues)
            regular_users = User.objects.filter(
                staff_profile__department=ticket.current_department, 
                staff_profile__staff_role='STAFF',
                must_change_password=False,
                is_active=True
            )
            regular_notifications = [
                Notification(
                    user=ru,
                    message=f'Ticket "#{ticket.id}" was AUTO-ESCALATED to Senior Staff due to deadline breach.',
                    link='/api/v1/staff-dashboard/all-issues/'
                ) for ru in regular_users
            ]
            if regular_notifications:
                Notification.objects.bulk_create(regular_notifications)
                trigger_async_emails(regular_notifications)
            
            resolutions.append(Resolution(
                ticket=ticket,
                resolved_by=None,  # System generated
                status='ESCALATED',
                feedback="[AUTOMATIC ESCALATION]: Ticket exceeded the due date and was escalated automatically."
            ))
        
        # Bulk Create Resolutions
        if resolutions:
            Resolution.objects.bulk_create(resolutions)


def issue_deadline_warnings():
    """
    Finds tickets that have less than 40% of their resolution timeframe left
    and issues a warning notification to the department's Regular staff.
    """
    active_tickets = Ticket.objects.filter(
        status__in=['OPEN', 'IN_PROGRESS', 'TRANSFERRED', 'REOPENED'],
        is_escalated=False,
        is_deadline_warning_sent=False,
        due_date__isnull=False
    ).select_related('category', 'current_department')

    if not active_tickets.exists():
        return

    tickets_to_update = []
    notifications_to_create = []
    User = get_user_model()

    for ticket in active_tickets:
        if not getattr(ticket, 'category', None):
            continue
            
        time_left_td = ticket.due_date - timezone.now()
        time_left_hours = time_left_td.total_seconds() / 3600.0
        
        # 40% of the category's standard resolution timeframe
        threshold_hours = ticket.category.resolution_timeframe * 0.40
        
        if time_left_hours > 0 and time_left_hours <= threshold_hours:
            ticket.is_deadline_warning_sent = True
            tickets_to_update.append(ticket)
            
            # Notify REGULAR staff
            staff_users = User.objects.filter(
                staff_profile__department=ticket.current_department, 
                staff_profile__staff_role='STAFF',
                must_change_password=False,
                is_active=True
            )
            
            hours = int(time_left_hours)
            minutes = int((time_left_hours - hours) * 60)
            time_str = f"{hours}h {minutes}m" if hours > 0 else f"{minutes}m"
            
            for staff in staff_users:
                notifications_to_create.append(
                    Notification(
                        user=staff,
                        message=f'WARNING: Ticket "#{ticket.id}" is approaching its deadline. Only {time_str} remaining.',
                        link=f'/api/v1/staff-dashboard/ticket/{ticket.id}/'
                    )
                )

    if tickets_to_update:
        Ticket.objects.bulk_update(tickets_to_update, ['is_deadline_warning_sent'])
    
    if notifications_to_create:
        Notification.objects.bulk_create(notifications_to_create)
        trigger_async_emails(notifications_to_create)
