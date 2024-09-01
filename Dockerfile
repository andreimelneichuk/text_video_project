# Используем официальный образ Python
FROM python:3.12-slim

# Устанавливаем зависимости для работы с медиа и видео, и netcat-openbsd для скрипта wait-for-it.sh
RUN apt-get update && apt-get install -y \
    libsm6 libxext6 libxrender-dev libfontconfig1 libgl1-mesa-glx \
    netcat-openbsd

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . .

# Устанавливаем зависимости проекта
RUN pip install --no-cache-dir -r requirements.txt

# Копируем скрипт ожидания
COPY wait-for-it.sh /wait-for-it.sh

# Устанавливаем правильные права доступа на выполнение скрипта
RUN chmod +x /wait-for-it.sh

# Собираем статические файлы
RUN python manage.py collectstatic --noinput

# Устанавливаем точку входа и команду запуска
ENTRYPOINT ["/wait-for-it.sh", "db", "5432", "--"]

#CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]

# Копируем скрипт старта
COPY start.sh /start.sh
RUN chmod +x /start.sh