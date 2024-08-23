from django.urls import path
from .views import generate_video_view

urlpatterns = [
    path('', generate_video_view, name='generate_video'),
]