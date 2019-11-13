#!/bin/bash -x
# This script will create the configuration necessary for the database
clear

echo "****************************************************"
echo "**           Docker Deploy Livro-Aberto           **"
echo "****************************************************"
echo ""
echo ""
echo "****************************************************"
echo "**               Setting up Docker                **"
echo "****************************************************"

# Getting docker images version 

read -p "Enter the Postgres Version TAG (Default: 10-alpine):" POSTGRES_TAG
POSTGRES_TAG=${POSTGRES_TAG:-'10-alpine'}

read -p "Enter the Postgres Port (Default: 5432):" POSTGRES_PORT
POSTGRES_PORT=${POSTGRES_PORT:-'5432'}

read -p "Enter the NGINX Version TAG (Default: 1-alpine):" NGINX_TAG
NGINX_TAG=${NGINX_TAG:-'1-alpine'}

read -p "Enter the Host Web Port (Default: 8000):" HOST_PORT
HOST_PORT=${HOST_PORT:-'8000'}

echo "Generating environment file..."
cat << EOF > .env
POSTGRES_TAG=${POSTGRES_TAG}
POSTGRES_PORT=${POSTGRES_PORT}
NGINX_TAG=${NGINX_TAG}
HOST_WEB_PORT=${HOST_PORT}
EOF
echo ""
echo ""
echo "****************************************************"
echo "**              Configuring Database              **"
echo "****************************************************"

# Getting the data to configure the database

read -p "Enter postgres user to be created (Default: livro_aberto)" POSTGRES_USER
POSTGRES_USER=${POSTGRES_USER:-'livro_aberto'}

read -p "Enter postgres password to be created (Default: l1vR0-ab3RtO)" POSTGRES_PASSWORD
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-'l1vR0-ab3RtO'}

read -p "Enter postgres db to be created (Default: livroaberto)" POSTGRES_DB
POSTGRES_DB=${POSTGRES_DB:-'livroaberto'}

echo "Generating postgres conf file..."
cat << EOF > config/db/postgres_env
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_DB=${POSTGRES_DB}
EOF
echo ""
echo ""
echo "****************************************************"
echo "**             Configuring Django APP             **"
echo "****************************************************"

# Generating the django env file with the database url
read -p "Provide the key to the API SOF: " PRODAM_KEY
PRODAM_KEY=${PRODAM_KEY}

read -p "We use Sentry to get errors reported. Provide your Sentry key: " SENTRY_URL
SENTRY_URL=${SENTRY_URL}

echo "Generating django env file..."
cat << EOF > config/django/.env
SECRET_KEY='$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 48; echo)'
DEBUG=False
ALLOWED_HOSTS='*'
DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@livro-aberto-db:5432/${POSTGRES_DB}
PRODAM_KEY=${PRODAM_KEY}
SENTRY_URL=${SENTRY_URL}
EOF

echo ""
echo ""
echo "****************************************************"
echo "**            Starting Docker Compose             **"
echo "****************************************************"
