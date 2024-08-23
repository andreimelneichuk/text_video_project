from django.db import models

class VideoRecord(models.Model):
    text = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    video_path = models.CharField(max_length=255)

    def __str__(self):
        return f"VideoRecord(id={self.id}, text={self.text}, created_at={self.created_at})"