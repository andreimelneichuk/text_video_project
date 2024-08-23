import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from django.http import HttpResponse
from django.shortcuts import render
import os
from .models import VideoRecord

def create_video_with_text(text="Привет, как дела?", font_path="video_generator/PionerSans8-VF.ttf"):
    width, height = 100, 100
    duration = 3
    fps = 24
    video_filename = "video_text.mp4"
    out = cv2.VideoWriter(video_filename, cv2.VideoWriter_fourcc(*'mp4v'), fps, (width, height))

    font_size = 20
    font = ImageFont.truetype(font_path, font_size)

    text_width = ImageDraw.Draw(Image.new("RGB", (1, 1))).textbbox((0, 0), text, font=font)[2]
    total_frames = duration * fps
    speed = (text_width + width) / total_frames

    for i in range(total_frames):
        frame = np.full((height, width, 3), (0, 0, 255), dtype=np.uint8)  # Красный фон
        x = int(width - i * speed)
        y = height // 2 - font_size // 2

        img_pil = Image.fromarray(frame)
        draw = ImageDraw.Draw(img_pil)
        draw.text((x, y), text, font=font, fill=(255, 255, 255))  # Белый текст
        frame = np.array(img_pil)
        out.write(frame)

    out.release()
    return video_filename



def generate_video_view(request):
    if request.method == 'POST':
        text = request.POST.get('text', 'Привет, как дела?')
        video_file = create_video_with_text(text)
        
        VideoRecord.objects.create(text=text, video_path=video_file)
        
        with open(video_file, 'rb') as f:
            response = HttpResponse(f.read(), content_type="video/mp4")
            response['Content-Disposition'] = f'attachment; filename={os.path.basename(video_file)}'
            return response

    return render(request, 'video_generator/index.html')