# Publicar o SAGD no Hostinger VPS

O Django requer um **VPS Hostinger**. O alojamento Web/Cloud partilhado não disponibiliza o acesso root necessário para executar Django.

## 1. Preparar o VPS Ubuntu

No hPanel, crie um VPS Ubuntu 24.04 e aponte os registos DNS `A` do domínio para o IP do VPS. Ligue-se por SSH e execute:

```bash
apt update && apt upgrade -y
apt install -y git nginx python3-venv python3-dev build-essential pkg-config default-libmysqlclient-dev mysql-server certbot python3-certbot-nginx
```

## 2. Criar a base MySQL

```bash
mysql -u root -p
```

```sql
CREATE DATABASE sagd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'sagd_user'@'localhost' IDENTIFIED BY 'UMA_PALAVRA_PASSE_FORTE';
GRANT ALL PRIVILEGES ON sagd.* TO 'sagd_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 3. Descarregar e configurar o repositório

```bash
mkdir -p /var/www
git clone URL_DO_SEU_REPOSITORIO /var/www/sagd
cd /var/www/sagd
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
cp .env.example .env
nano .env
```

No `.env`, substitua o domínio, IP, chave secreta e a palavra-passe MySQL. Gere uma chave segura com:

```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

Carregue as variáveis e execute:

```bash
set -a
source .env
set +a
python manage.py migrate --noinput
python manage.py collectstatic --noinput
python manage.py createsuperuser
chown -R www-data:www-data /var/www/sagd
```

## 3.1 Transferir os dados atuais para o VPS

Se pretende publicar os dados que já existem no MySQL local, execute no seu computador (não adicione este ficheiro ao Git):

```bash
mysqldump --single-transaction --routines --triggers -u root -p sagd > sagd.sql
scp sagd.sql root@IP_DO_SEU_VPS:/tmp/sagd.sql
```

No VPS, depois de criar a base e o utilizador, importe o ficheiro:

```bash
mysql -u sagd_user -p sagd < /tmp/sagd.sql
rm /tmp/sagd.sql
cd /var/www/sagd
set -a
source .env
set +a
python manage.py migrate --noinput
```

Se importar os dados existentes, execute este passo antes de criar manualmente um novo superutilizador.

## 4. Ativar Gunicorn e Nginx

Copie os ficheiros de configuração incluídos no repositório e substitua `example.com` pelo seu domínio:

```bash
cp deploy/hostinger/sagd.service /etc/systemd/system/sagd.service
cp deploy/hostinger/nginx-sagd.conf /etc/nginx/sites-available/sagd
nano /etc/nginx/sites-available/sagd
ln -s /etc/nginx/sites-available/sagd /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl daemon-reload
systemctl enable --now sagd
nginx -t
systemctl reload nginx
```

## 5. Ativar HTTPS

Quando o DNS já estiver propagado:

```bash
certbot --nginx -d example.com -d www.example.com
```

## Atualizações futuras

No VPS, use:

```bash
cd /var/www/sagd
bash deploy/hostinger/deploy.sh
```

Antes de executar, confirme que o repositório não contém `.env`, `db.sqlite3`, `.venv` ou `staticfiles`.
