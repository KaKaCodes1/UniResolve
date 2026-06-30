# Standard utility library for interacting with the operating system (used here for file path/extension extraction)
import os
# Django exception raised when validation checks fail on models or forms
from django.core.exceptions import ValidationError

def validate_excel_file(value):
    ext = os.path.splitext(value.name)[1]
    valid_extensions = ['.xlsx']
    if not ext.lower() in valid_extensions:
        raise ValidationError('Unsupported file extension. Only .xlsx files are allowed.')
    
    # 5MB limit
    limit = 5 * 1024 * 1024
    if value.size > limit:
        raise ValidationError('File too large. Size should not exceed 5MB.')
