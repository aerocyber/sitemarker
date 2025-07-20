gunicorn wsgi:app \
  --workers=4 \
  --bind=0.0.0.0:8000 \
  --log-level=info \
  --access-logfile=/var/log/sitemarker/logs.log \
  --error-logfile=/var/log/sitemarker/errors.log