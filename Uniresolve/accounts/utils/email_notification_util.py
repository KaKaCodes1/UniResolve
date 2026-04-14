import threading
from django.core.mail import EmailMessage
from email.utils import format_datetime
from django.utils import timezone

class EmailThread(threading.Thread):
    def __init__(self, subject, body, recipient_list, sender_email='noreply@uniresolve.edu'):
        self.subject = subject
        self.body = body
        self.recipient_list = recipient_list
        self.sender_email = sender_email
        threading.Thread.__init__(self)

    def run(self):
        now = timezone.localtime()
        formatted_date = format_datetime(now)

        msg = EmailMessage(
            subject=self.subject, 
            body=self.body, 
            from_email=self.sender_email, 
            to=self.recipient_list,
            headers={'Date': formatted_date}
        )
        # Opted for plain text initially, so we won't set msg.content_subtype = "html"
        try:
            msg.send()
        except Exception as e:
            # In a production environment, use the logging module here
            print(f"Error sending email asynchronously: {e}")

def trigger_async_emails(notifications):
    """
    Takes a single Notification object or a list of Notification objects,
    extracts the necessary user and message data, and fires off an email thread.
    """
    # Normalize to a list to handle both .create() and .bulk_create() outputs
    if not isinstance(notifications, list):
        notifications = [notifications]
        
    for notif in notifications:
        if not getattr(notif.user, 'email', None):
            continue
            
        subject = "New Notification from UniResolve"
        
        # Build a plain text message
        message = f"Hello {notif.user.first_name},\n\n"
        message += f"You have a new alert:\n{notif.message}\n\n"
        
        if getattr(notif, 'link', None):
            # For a real setup, we'd want the full site absolute URL, 
            # but appending the path gives them context for now.
            message += f"Log onto the portal to view details: {notif.link}\n\n"
            
        message += "Thank you,\nUniResolve Team"
            
        EmailThread(
            subject=subject,
            body=message,
            recipient_list=[notif.user.email]
        ).start()
