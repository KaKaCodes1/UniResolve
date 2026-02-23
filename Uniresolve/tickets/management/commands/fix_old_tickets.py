from django.core.management.base import BaseCommand
from tickets.models import Ticket
from django.utils import timezone
from datetime import timedelta

class Command(BaseCommand):
    help = 'Retroactively populates current_department and due_date for all existing tickets.'

    def handle(self, *args, **kwargs):
        # Find all tickets that are missing a current_department
        tickets = Ticket.objects.filter(current_department__isnull=True)
        count = tickets.count()
        
        if count == 0:
            self.stdout.write(self.style.SUCCESS("No tickets found missing a current_department. Everything is up to date!"))
            return

        self.stdout.write(self.style.WARNING(f"Found {count} old tickets. Beginning data migration..."))

        updated_count = 0
        for ticket in tickets:
            category = ticket.category
            owner = ticket.owner
            
            # Recreate the exact routing logic from views.py
            if category.is_academic:
                try:
                    # Academic issues go to the student's home department
                    current_dept = owner.student_profile.course.department
                except Exception as e:
                    self.stdout.write(self.style.ERROR(f"Skipping Ticket #{ticket.id}: Could not find student department for owner {owner.get_full_name()}."))
                    continue
            else:
                # Normal issues go to the category's assigned department
                current_dept = category.department

            # 1. Update the department
            ticket.current_department = current_dept
            
            # 2. Add a due date retroactively (Calculate from exactly when ticket was created)
            if not ticket.due_date:
                timeframe = getattr(category, 'resolution_timeframe', 48)
                ticket.due_date = ticket.created_at + timedelta(hours=timeframe)

            ticket.save()
            updated_count += 1
            
        self.stdout.write(self.style.SUCCESS(f"Successfully migrated and routed {updated_count} old tickets!"))
