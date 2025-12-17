from rest_framework import serializers
from .models import StaffProfile, StudentProfile
from django.contrib.auth import get_user_model
from django.db import transaction #Used to enforce atomicity
from organization.models import Department

#Getting the user model defined in the settings.py
User = get_user_model()

class UserRegistrationSerializer(serializers.ModelSerializer):
    #manually defining fields not in the User model
    #required=False because a Student won't provide Employee ID & department, and Staff won't provide Reg Number & program.
    reg_number = serializers.CharField(max_length=20, required=False, write_only=True)
    program = serializers.CharField(max_length=100, required=False, write_only=True)
    employee_id = serializers.CharField(max_length=20, required=False, write_only=True)
    
    # PrimaryKeyRelatedField means the frontend sends an ID, and DRF finds the Department object for us.
    department_id = serializers.PrimaryKeyRelatedField(
        queryset = Department.objects.all(), #where the ID will be looked for
        source = 'department', #field name in the StaffProfile model
        required = False,
        write_only = True
    )
    password = serializers.CharField(
        write_only=True, #Accept the password when the user sends it (POST), but never include it when you send data back (GET).
        style={'input_type': 'password'} #[OPTIONAL] for the HTML Browsable API, DRF generates a web page to test the API).
    )
    class Meta:
        model = User
        fields = [
            'id', 
            'email', 
            'first_name', 
            'last_name', 
            'password', 
            'role', 
            'reg_number', 
            'program', 
            'employee_id', 
            'department_id'
        ]
    #Validation
    def validate(self,data):
        #Extract the role chosen by the user
        role = data.get('role')

        if role == 'Student':
            if not data.get('reg_number') or not data.get('program'):
                raise serializers.ValidationError("Students must provide a 'reg_number' and 'program'.")
        
        if role == 'Staff':
            if not data.get('employee_id') or not data.get('department'):
                raise serializers.ValidationError("Staff must provide an 'employee_id' and 'department_id'.")
        
        return data
    
    #Creation - runs after validation
    #default create() is overridden because data will be saved in 2 tables: User and Staff/StdentProfile
    def create(self, validated_data):
        #.pop is used to remove fields that are not on the User model to prevent errors in creation
        #None is used to prevent the system from crashing when either of these fields is missing depending on the role chosen
        reg_number = validated_data.pop('reg_number', None)
        program = validated_data.pop('program', None)
        employee_id = validated_data.pop('employee_id', None)
        department = validated_data.pop('department', None)

        #Remove the password too for hashing
        password = validated_data.pop('password')

        #Enforcing Atomicity(all or nothing) - if saving the profile fails then the user account is deleted
        with transaction.atomic():
            #User Instance
            user = User.objects.create(**validated_data)

            #hashing the password
            user.set_password(password)

            #save user to DB
            user.save()

            #create the profile based on role
            if user.role == 'Student':
                StudentProfile.objects.create(
                    user=user,
                    reg_number=reg_number,
                    program=program
                )
            elif user.role == 'Staff':
                StaffProfile.objects.create(
                    user=user,
                    employee_id=employee_id,
                    department=department
                )

        # Return the created user object to the frontend
        return user