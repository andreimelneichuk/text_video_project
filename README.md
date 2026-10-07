# Генератор видео с бегущей строкой

Веб-приложение на Django: пользователь вводит текст в форму, сервер генерирует MP4-ролик с бегущей строкой и сразу отдаёт его на скачивание. Каждая генерация записывается в БД (модель `VideoRecord`: текст, путь к файлу, дата).

Параметры ролика заданы в коде: 100x100 пикселей, 3 секунды, 24 кадра/с, белый текст на красном фоне. Текст движется справа налево. Кириллица поддерживается за счёт шрифта `PionerSans8-VF.ttf`, текст рисуется через Pillow.

## Стек

- Python, Django 5
- OpenCV (`opencv-python-headless`) для записи видео, Pillow для отрисовки текста, NumPy
- SQLite (настроен в `settings.py`)
- Docker / docker-compose (опционально)

## Структура

```text
text_video_project/          # настройки Django-проекта
video_generator/
├── models.py                # модель VideoRecord
├── views.py                 # генерация видео и обработка формы
├── urls.py
├── templates/video_generator/index.html
└── PionerSans8-VF.ttf       # шрифт с кириллицей
Dockerfile, docker-compose.yml, start.sh, wait-for-it.sh
```

## Запуск локально

```bash
git clone https://github.com/andreimelneichuk/text_video_project.git
cd text_video_project
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

Откройте http://127.0.0.1:8000/, введите текст и нажмите кнопку: браузер скачает `video_text.mp4`.

## Запуск в Docker

```bash
docker-compose up --build
```

Приложение будет доступно на http://localhost:8000/. В `docker-compose.yml` описан и контейнер PostgreSQL, но в `settings.py` сейчас используется SQLite.
