import re
import os
from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _

def validate_excel_file(value):
    ext = os.path.splitext(value.name)[1]
    valid_extensions = ['.xlsx']
    if not ext.lower() in valid_extensions:
        raise ValidationError('Unsupported file extension. Only .xlsx files are allowed.')
    
    # 5MB limit
    limit = 5 * 1024 * 1024
    if value.size > limit:
        raise ValidationError('File too large. Size should not exceed 5MB.')

class ComplexityValidator:
    def validate(self, password, user=None):
        if not re.search(r'[A-Z]', password):
            raise ValidationError(
                _("This password must contain at least one uppercase letter."),
                code='password_no_upper',
            )
        if not re.search(r'[a-z]', password):
            raise ValidationError(
                _("This password must contain at least one lowercase letter."),
                code='password_no_lower',
            )
        if not re.search(r'[0-9]', password):
            raise ValidationError(
                _("This password must contain at least one number."),
                code='password_no_number',
            )
        if not re.search(r'[!@#$%^&*(),.?":{}|<>]', password):
            raise ValidationError(
                _("This password must contain at least one special character."),
                code='password_no_symbol',
            )

    def get_help_text(self):
        return _(
            "Your password must contain at least one uppercase letter, one lowercase letter, one number, and one special character."
        )
