from rest_framework import serializers
from .models import Ticket, Resolution, StudentFeedback
from .validators import validate_file_attachment

class ResolutionSerializer(serializers.ModelSerializer):
    # Display the Staff member's email/name instead of their ID
    resolved_by = serializers.StringRelatedField(read_only = True)
    
    ticket_title = serializers.CharField(source='ticket.title', read_only=True)
    ticket_status = serializers.CharField(source='ticket.status', read_only=True)
    department_name = serializers.StringRelatedField(source='ticket.current_department', read_only=True)

    class Meta:
        model = Resolution
        fields = ['id', 'ticket', 'ticket_title', 'ticket_status', 'feedback', 'resolved_by', 'resolved_at', 'status','department_name']
        read_only_fields = ['resolved_at']

    def validate_status(self,value):
        status_input = value.upper()
        valid_choices = ['PENDING', 'RESOLVED', 'ESCALATED', 'TRANSFERRED']

        if status_input not in valid_choices:
            raise serializers.ValidationError(
                f"Invalid status"
            )
        return status_input
class StudentFeedbackSerializer(serializers.ModelSerializer):
    ticket_title = serializers.CharField(source='ticket.title', read_only=True)
    student_name = serializers.StringRelatedField(source='student', read_only=True)

    class Meta:
        model = StudentFeedback
        fields = ['id', 'ticket', 'ticket_title', 'student', 'student_name', 'is_satisfied', 'comments', 'created_at']
        read_only_fields = ['student', 'created_at']


class TicketSerializer(serializers.ModelSerializer):
    # Display the student's name and category name instead of their ID
    owner = serializers.StringRelatedField(read_only=True)
    category_name = serializers.StringRelatedField(source = 'category', read_only = True)
    current_department_name = serializers.StringRelatedField(source='current_department', read_only=True)
    attachment = serializers.FileField(required=False, validators=[validate_file_attachment])

    #Nested serializer to allow a student to see staff's remarks when they view their ticket
    resolutions = ResolutionSerializer(many=True, read_only=True)
    student_feedbacks = StudentFeedbackSerializer(many=True, read_only=True)
    
    class Meta:
        model = Ticket
        fields = [
            'id', 
            'title', 
            'description', 
            'attachment',
            'status', 
            'category',       # Input: Accepts ID (e.g., 1)
            'category_name',  # Output: distinct name corresponding with the category ID
            'current_department',
            'current_department_name',
            'due_date',
            'owner', 
            'created_at',
            'resolutions',
            'student_feedbacks'
        ]
        read_only_fields = ['status', 'created_at', 'owner','due_date', 'current_department']


