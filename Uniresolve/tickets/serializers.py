from rest_framework import serializers
from .models import Ticket, Resolution

class ResolutionSerializer(serializers.ModelSerializer):
    # Display the Staff member's email/name instead of their ID
    resolved_by = serializers.StringRelatedField(read_only = True)
    #To allow updates on the status
    status = serializers.CharField(write_only=True, required=False)
    class Meta:
        model = Resolution
        fields = ['id', 'ticket', 'feedback', 'resolved_by', 'resolved_at', 'status']
        read_only_fields = [ 'resolved_at']

    def validate_status(self,value):
        status_input = value.upper()
        valid_choices = ['PENDING', 'RESOLVED']

        if status_input not in valid_choices:
            raise serializers.ValidationError(
                f"Invalid status"
            )
        return status_input
class TicketSerializer(serializers.ModelSerializer):
    # Display the student's name and category name instead of their ID
    owner = serializers.StringRelatedField(read_only=True)
    category_name = serializers.StringRelatedField(source = 'category', read_only = True)

    #Nested serializer to allow a student to see staff's remarks when they view their ticket
    resolutions = ResolutionSerializer(many=True, read_only=True)
    
    class Meta:
        model = Ticket
        fields = [
            'id', 
            'title', 
            'description', 
            'status', 
            'category',       # Input: Accepts ID (e.g., 1)
            'category_name',  # Output: distinct name corresponding with the category ID
            'owner', 
            'created_at',
            'resolutions'
        ]
        read_only_fields = ['status', 'created_at', 'owner']

