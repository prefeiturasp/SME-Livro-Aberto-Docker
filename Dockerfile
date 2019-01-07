FROM python:3.7

ENV PYTHONUNBUFFERED 1

# Creating dir and copying content
RUN mkdir -p /opt/services/livro-aberto/src
COPY ./app/SME-Livro-Aberto /opt/services/livro-aberto/src
COPY ./config/django/.env /opt/services/livro-aberto/src/.env
COPY ./config/gunicorn/conf.py /opt/services/livro-aberto/src/gunicorn_conf.py

# Configuring .env file
WORKDIR /opt/services/livro-aberto/src

RUN pip install pipenv && pipenv install

EXPOSE 8000

CMD ["pipenv", "run", "gunicorn", "-c", "/opt/services/livro-aberto/src/gunicorn_conf.py", "--bind", ":8000", "--chdir", "/opt/services/livro-aberto/src", "core.wsgi:application"]