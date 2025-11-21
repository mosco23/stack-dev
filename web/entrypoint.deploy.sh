python3 manage.py collectstatic --noinput
python3 manage.py migrate --noinput
exec gunicorn --bind 0.0.0.0:80 project_name.wsgi:application