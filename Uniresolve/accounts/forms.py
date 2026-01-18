from django import forms
from django.contrib.auth import get_user_model
from .models import StudentProfile, StaffProfile
from organization.models import Department

User = get_user_model()

class StudentSignUpForm(forms.ModelForm):
    full_name = forms.CharField(max_length=200, required=True, widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'John Doe'}))
    email = forms.EmailField(required=True, widget=forms.EmailInput(attrs={'class': 'form-control'}))
    password = forms.CharField(widget=forms.PasswordInput(attrs={'class': 'form-control'}))
    reg_number = forms.CharField(label="Admission Number", max_length=20, required=True, widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'e.g., CS2021001'}))
    program = forms.CharField(label="Course", max_length=100, required=True, widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Select your course'}))

    class Meta:
        model = User
        fields = ['full_name', 'email', 'password']

    def clean_email(self):
        email = self.cleaned_data.get('email')
        if User.objects.filter(email=email).exists():
            raise forms.ValidationError("This email is already in use.")
        return email

    def clean_reg_number(self):
        reg_number = self.cleaned_data.get('reg_number')
        if StudentProfile.objects.filter(reg_number=reg_number).exists():
            raise forms.ValidationError("This registration number is already in use.")
        return reg_number

    def save(self, commit=True):
        user = super().save(commit=False)
        names = self.cleaned_data['full_name'].strip().split(' ', 1)
        user.first_name = names[0]
        user.last_name = names[1] if len(names) > 1 else ''
        user.set_password(self.cleaned_data['password'])
        user.role = 'Student'
        if commit:
            user.save()
            StudentProfile.objects.create(
                user=user,
                reg_number=self.cleaned_data['reg_number'],
                program=self.cleaned_data['program']
            )
        return user

class StaffSignUpForm(forms.ModelForm):
    full_name = forms.CharField(max_length=200, required=True, widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Jane Doe'}))
    email = forms.EmailField(required=True, widget=forms.EmailInput(attrs={'class': 'form-control'}))
    password = forms.CharField(widget=forms.PasswordInput(attrs={'class': 'form-control'}))
    employee_id = forms.CharField(max_length=20, required=True, widget=forms.TextInput(attrs={'class': 'form-control'}))
    department = forms.ModelChoiceField(queryset=Department.objects.all(), required=True, widget=forms.Select(attrs={'class': 'form-control'}))

    class Meta:
        model = User
        fields = ['full_name', 'email', 'password']

    def clean_email(self):
        email = self.cleaned_data.get('email')
        if User.objects.filter(email=email).exists():
            raise forms.ValidationError("This email is already in use.")
        return email

    def clean_employee_id(self):
        employee_id = self.cleaned_data.get('employee_id')
        if StaffProfile.objects.filter(employee_id=employee_id).exists():
            raise forms.ValidationError("This employee ID is already in use.")
        return employee_id

    def save(self, commit=True):
        user = super().save(commit=False)
        names = self.cleaned_data['full_name'].strip().split(' ', 1)
        user.first_name = names[0]
        user.last_name = names[1] if len(names) > 1 else ''
        user.set_password(self.cleaned_data['password'])
        user.role = 'Staff'
        if commit:
            user.save()
            StaffProfile.objects.create(
                user=user,
                employee_id=self.cleaned_data['employee_id'],
                department=self.cleaned_data['department']
            )
        return user
