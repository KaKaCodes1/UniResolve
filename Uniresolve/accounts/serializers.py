from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import StaffProfile, StudentProfile, Notification
from django.contrib.auth import get_user_model
from django.db import transaction #Used to enforce atomicity
from organization.models import Department, Course 
from django.contrib.auth.password_validation import validate_password # Import standard validator

#Getting the user model defined in the settings.py
User = get_user_model()

class UserRegistrationSerializer(serializers.ModelSerializer):
    #manually defining fields not in the User model
    #required=False because a Student won't provide Employee ID & department, and Staff won't provide Reg Number & program.
    reg_number = serializers.CharField(max_length=20, required=False, write_only=True)
    course_id = serializers.PrimaryKeyRelatedField(
        queryset=Course.objects.all(),
        source='course',
        required=False,
        write_only=True
    )
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
            'course_id', 
            'employee_id', 
            'department_id'
        ]

    #Validation
    def validate_password(self, value):
        # a temporary user to check for attribute similarity
        # self.initial_data contains the raw input data
        user_data = self.initial_data
        user = User(
            first_name=user_data.get('first_name'),
            last_name=user_data.get('last_name'),
            email=user_data.get('email'),
            username=user_data.get('email') # Username is email in this system
        )
        # Enforce Django's password validation rules (length, complexity, similarity, etc)
        validate_password(value, user=user)
        return value

    def validate(self,data):
        #Extract the role chosen by the user
        role = data.get('role')

        if role == 'Student':
            # Changed check from 'program' to 'course' (source of course_id)
            if not data.get('reg_number') or not data.get('course'):
                raise serializers.ValidationError("Students must provide a 'reg_number' and 'course_id'.")
        
        if role == 'Staff':
            if not data.get('employee_id') or not data.get('department'):
                raise serializers.ValidationError("Staff must provide an 'employee_id' and 'department_id'.")
        
        return data

    def validate_reg_number(self, value):
        if StudentProfile.objects.filter(reg_number=value).exists():
            raise serializers.ValidationError("This registration number is already in use.")
        return value

    def validate_employee_id(self, value):
        if StaffProfile.objects.filter(employee_id=value).exists():
            raise serializers.ValidationError("This employee ID is already in use.")
        return value
    
    #Creation - runs after validation
    #default create() is overridden because data will be saved in 2 tables: User and Staff/StdentProfile
    def create(self, validated_data):
        #.pop is used to remove fields that are not on the User model to prevent errors in creation
        #None is used to prevent the system from crashing when either of these fields is missing depending on the role chosen
        reg_number = validated_data.pop('reg_number', None)
        course = validated_data.pop('course', None)
        employee_id = validated_data.pop('employee_id', None)
        department = validated_data.pop('department', None)

        #Remove the password too for hashing
        password = validated_data.pop('password')

        #Enforcing Atomicity(all or nothing) - if saving the profile fails then the user account is deleted
        with transaction.atomic():
            #User Instance
            user = User.objects.create(**validated_data)

            # Staff members are created as inactive until approved by an admin
            if user.role == 'Staff':
                user.is_active = False

            #hashing the password
            user.set_password(password)

            #save user to DB
            user.save()

            #create the profile based on role
            if user.role == 'Student':
                StudentProfile.objects.create(
                    user=user,
                    reg_number=reg_number,
                    course=course # Updated to match model field
                )
            elif user.role == 'Staff':
                StaffProfile.objects.create(
                    user=user,
                    employee_id=employee_id,
                    department=department
                )

        # Return the created user object to the frontend
        return user

class UserProfileSerializer(serializers.ModelSerializer):
    profile_data = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id', 
            'email',
            'username',
            'first_name', 
            'last_name', 
            'role',
            'is_active',
            'profile_data'
        ]

    def get_profile_data(self, obj):
        if obj.role == 'Student':
            try:
                profile = obj.student_profile
                return {
                    'reg_number': profile.reg_number,
                    'course': profile.course.course_name if profile.course else None,
                    'department': profile.course.department.department_name if profile.course and profile.course.department else None
                }
            except StudentProfile.DoesNotExist:
                return {}
        
        elif obj.role == 'Staff':
            try:
                profile = obj.staff_profile
                return {
                    'employee_id': profile.employee_id,
                    'department': profile.department.department_name if profile.department else None,
                    'staff_role': profile.staff_role
                }
            except StaffProfile.DoesNotExist:
                return {}
        
        return {}

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        
        # Add extra responses
        data['role'] = self.user.role
        data['first_name'] = self.user.first_name
        data['user_id'] = self.user.id
        data['must_change_password'] = self.user.must_change_password

        # Include staff authority role if applicable (Required for Senior Staff Dashboard routing)
        if self.user.role == 'Staff' and hasattr(self.user, 'staff_profile'):
            data['staff_role'] = self.user.staff_profile.staff_role

        return data

class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['id', 'message', 'link', 'is_read', 'created_at']
        read_only_fields = ['id', 'message', 'link', 'created_at']