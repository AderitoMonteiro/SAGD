#!/usr/bin/env bash
set -euo pipefail

APP_DIR=/var/www/sagd
VENV_DIR="$APP_DIR/.venv"

cd "$APP_DIR"
source "$VENV_DIR/bin/activate"
set -a
source "$APP_DIR/.env"
set +a

git pull --ff-only
pip install --upgrade pip
pip install -r requirements.txt
python manage.py migrate --noinput
python manage.py collectstatic --noinput
sudo systemctl restart sagd
