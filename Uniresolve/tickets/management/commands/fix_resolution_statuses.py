from django.core.management.base import BaseCommand
from tickets.models import Resolution

class Command(BaseCommand):
    help = 'Retroactively sets the correct status for historical Resolution records.'

    def handle(self, *args, **options):
        resolutions = Resolution.objects.all()
        updated_count = 0

        for res in resolutions:
            old_status = res.status
            new_status = 'RESOLVED' # Default fallback

            # 1. Check for specific system-generated notes in the feedback text
            if "[INTERNAL ESCALATION]" in res.feedback:
                new_status = 'ESCALATED'
            elif "[TRANSFERRED" in res.feedback:
                new_status = 'TRANSFERRED'
            else:
                # 2. For standard feedback, we fall back to the Ticket's current status
                # It's an approximation for old data prior to the tracking feature
                new_status = res.ticket.status

            if old_status != new_status:
                res.status = new_status
                res.save()
                updated_count += 1
                self.stdout.write(self.style.SUCCESS(f'Updated Resolution ID {res.id} from {old_status} to {new_status}'))

        self.stdout.write(self.style.SUCCESS(f'Successfully updated {updated_count} Resolution records.'))
