# Executar o SAGD noutra máquina

## Requisitos

- Python 3.11 (64 bits) ou superior compatível com Django 5.2
- MySQL 8 ou MariaDB 10.5+
- Git (opcional, para clonar o projeto)

## 1. Copiar o projeto

Clone o repositório ou copie a pasta do projeto para a nova máquina:

```bash
git clone URL_DO_REPOSITORIO SAGD
cd SAGD
```

Não copie a pasta `.venv` de outra máquina. Cada máquina deve criar o seu próprio ambiente virtual.

## 2. Criar e ativar o ambiente virtual

### Windows (PowerShell)

```powershell
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
```

Se o PowerShell bloquear a ativação, execute apenas para a sessão atual:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\.venv\Scripts\Activate.ps1
```

### Linux/macOS

No Ubuntu/Debian, instale primeiro os componentes necessários ao `mysqlclient`:

```bash
sudo apt update
sudo apt install -y python3-venv python3-dev build-essential pkg-config default-libmysqlclient-dev
```

Depois crie o ambiente:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
```

## 3. Criar a base de dados

Entre no MySQL:

```bash
mysql -u root -p
```

Crie a base e o utilizador:

```sql
CREATE DATABASE sagd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'sagd_user'@'localhost' IDENTIFIED BY 'PALAVRA_PASSE_FORTE';
GRANT ALL PRIVILEGES ON sagd.* TO 'sagd_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 4. Configurar as variáveis de ambiente

O projeto lê as configurações diretamente das variáveis do sistema. O ficheiro `.env.example` serve como referência.

### Windows (PowerShell)

Para desenvolvimento local:

```powershell
$env:DJANGO_DEBUG='True'
$env:DJANGO_ALLOWED_HOSTS='localhost,127.0.0.1'
$env:MYSQL_ENGINE='django.db.backends.mysql'
$env:MYSQL_DATABASE='sagd'
$env:MYSQL_USER='sagd_user'
$env:MYSQL_PASSWORD='PALAVRA_PASSE_FORTE'
$env:MYSQL_HOST='127.0.0.1'
$env:MYSQL_PORT='3306'
```

Essas variáveis duram apenas durante a sessão atual do PowerShell.

### Linux/macOS

```bash
export DJANGO_DEBUG=True
export DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
export MYSQL_ENGINE=django.db.backends.mysql
export MYSQL_DATABASE=sagd
export MYSQL_USER=sagd_user
export MYSQL_PASSWORD='PALAVRA_PASSE_FORTE'
export MYSQL_HOST=127.0.0.1
export MYSQL_PORT=3306
```

## 5. Preparar o Django

Com o ambiente virtual ativo e as variáveis configuradas:

```bash
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser
python manage.py check
```

Se importou uma base de dados existente, execute `migrate` mas não precisa criar outro superutilizador.

## 6. Iniciar em desenvolvimento

```bash
python manage.py runserver 127.0.0.1:8000
```

Abra no navegador:

```text
http://127.0.0.1:8000/
```

O servidor de desenvolvimento recarrega automaticamente quando o código é alterado.

## 7. Iniciar em produção Linux

Configure `DJANGO_DEBUG=False`, uma chave secreta forte, o domínio e HTTPS. Depois execute:

```bash
python manage.py collectstatic --noinput
python manage.py migrate --noinput
gunicorn config.wsgi:application --bind 127.0.0.1:8000 --workers 3
```

Em produção, coloque Nginx ou outro proxy HTTPS à frente do Gunicorn. O procedimento completo para Hostinger está em `DEPLOY_HOSTINGER.md`.

## 8. Transferir os dados existentes (opcional)

Na máquina atual:

```bash
mysqldump --single-transaction --routines --triggers -u root -p sagd > sagd.sql
```

Na nova máquina:

```bash
mysql -u sagd_user -p sagd < sagd.sql
python manage.py migrate
```

Não publique `.env`, palavras-passe, `.venv`, `sagd.sql` ou outros ficheiros com dados reais no repositório.
