from django.urls import path
from .views import UserRegistrationView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('register/', UserRegistrationView.as_view(),name='register'),
    #user sends email and password and gets access and refresh tokens 
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    #allows a user to send refresh token and get a new access token 
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]