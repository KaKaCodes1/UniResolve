from rest_framework import serializers
from .models import Ticket, Resolution

class TicketSerializer(serializers.ModelSerializer):
    # Display the student's name and category name instead of their ID
    owner = serializers.StringRelatedField(read_only=True)
    category_name = serializers.StringRelatedField(source = 'category', read_only = True)
    
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
            'created_at'
        ]
        read_only_fields = ['status', 'created_at']

class ResolutionSerializer(serializers.ModelSerializer):
    # Display the Staff member's email/name instead of their ID
    resolved_by = serializers.StringRelatedField(read_only = True)
    class Meta:
        model = Resolution
        fields = ['id', 'ticket', 'feedback', 'resolved_by', 'resolved_at']
        read_only_fields = [ 'resolved_at']