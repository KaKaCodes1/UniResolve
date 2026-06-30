import threading
from django.core.mail import EmailMessage, get_connection
from django.conf import settings
from email.utils import format_datetime
from django.utils import timezone

class EmailThread(threading.Thread):
    def __init__(self, subject, body, recipient_list, sender_email=None):
        self.subject = subject
        self.body = body
        self.recipient_list = recipient_list
        
        # Set a professional sender name using the configured Gmail address
        if not sender_email:
            bot_email = getattr(settings, 'EMAIL_HOST_USER', 'noreply@uniresolve.edu')
            self.sender_email = f"UniResolve Automated <{bot_email}>"
        else:
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
        
        try:
            # Safely get the first recipient (since we usually send 1 by 1)
            recipient = self.recipient_list[0] if self.recipient_list else None
            whitelist = getattr(settings, 'WHITELISTED_EMAILS', [])
            
            if recipient and recipient in whitelist:
                # Send normally using SMTP backend configured in settings
                msg.send()
            else:
                # Fallback to Console backend for non-whitelisted emails
                console_connection = get_connection('django.core.mail.backends.console.EmailBackend')
                msg.connection = console_connection
                msg.send()
                
        except Exception as e:
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
            # Build the absolute URL so it's clickable in the email client
            base_url = 'http://localhost:8000'
            # Ensure the link always starts with a slash to prevent malformed URLs
            if notif.link.startswith('/'):
                link_path = notif.link
            else:
                link_path = f"/{notif.link}"
                
            absolute_link = f"{base_url}{link_path}"
            
            message += f"Log onto the portal to view details: {absolute_link}\n\n"
            
        message += "Thank you,\nUniResolve Team"
            
        EmailThread(
            subject=subject,
            body=message,
            recipient_list=[notif.user.email]
        ).start()
