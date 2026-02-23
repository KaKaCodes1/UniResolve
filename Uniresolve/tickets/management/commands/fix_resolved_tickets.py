from django.core.management.base import BaseCommand
from tickets.models import Ticket

class Command(BaseCommand):
    help = 'Restores resolved or escalated tickets to the department of the staff member who last handled them.'

    def handle(self, *args, **kwargs):
        # We only care about tickets that have already been worked on
        tickets_with_history = Ticket.objects.exclude(resolutions__isnull=True)
        count = tickets_with_history.count()

        if count == 0:
            self.stdout.write(self.style.SUCCESS("No resolved tickets found. Nothing to fix!"))
            return

        self.stdout.write(self.style.WARNING(f"Found {count} tickets with a resolution history. Scanning to restore proper departments..."))

        updated_count = 0
        for ticket in tickets_with_history:
            # Get the MOST RECENT resolution for this ticket
            latest_resolution = ticket.resolutions.order_by('-resolved_at').first()
            
            # Identify the staff member who resolved it
            resolving_staff = latest_resolution.resolved_by
            
            # If the staff member exists and has a staff profile with a department
            if resolving_staff and hasattr(resolving_staff, 'staff_profile'):
                correct_dept = resolving_staff.staff_profile.department
                
                # Only update if the current department is wrong
                if ticket.current_department != correct_dept:
                    ticket.current_department = correct_dept
                    ticket.save()
                    updated_count += 1
                    self.stdout.write(self.style.SUCCESS(f"Restored Ticket #{ticket.id} back to {correct_dept.department_name}."))
            else:
                 self.stdout.write(self.style.ERROR(f"Skipping Ticket #{ticket.id}: Resolving staff member profile missing."))

        self.stdout.write(self.style.SUCCESS(f"\nMigration complete! {updated_count} old resolved tickets successfully returned to their final departments."))
