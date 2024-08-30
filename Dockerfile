# Используем официальный образ Python
FROM python:3.12-slim

# Устанавливаем зависимости для работы с медиа и видео
RUN apt-get update && apt-get install -y \
    libsm6 libxext6 libxrender-dev libfontconfig1 libgl1-mesa-glx

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . .

# Устанавливаем зависимости проекта
RUN pip install --no-cache-dir -r requirements.txt

# Применяем миграции
RUN python manage.py migrate

# Собираем статические файлы (если используются)
RUN python manage.py collectstatic --noinput

# Открываем порт 8000 для доступа к приложению
EXPOSE 8000

# Команда для запуска сервера
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]