# v2board-docker

🐳 Fast deployment of V2Board using Docker

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Development Mode](#development-mode)
- [Configuration](#configuration)
- [Installation](#installation)
- [Usage](#usage)
- [Updating](#updating)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have the following installed:

- **Docker** (20.10+)
- **Docker Compose** (2.0+)
- **Git**
- A domain name pointed to your server (for HTTPS)

### Install Docker and Docker Compose

```bash
# Quick install script for Docker
curl -sSL https://get.docker.com/ | sh
systemctl start docker
systemctl enable docker

# Docker Compose is now included with Docker
# Verify installation
docker compose version
```

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/hashcott/v2board-docker.git
cd v2board-docker/
```

### 2. Initialize Submodules

```bash
git submodule update --init
echo '  branch = master' >> .gitmodules
git submodule update --remote
```

### 3. Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your settings
nano .env
```

**Important settings to configure in `.env`:**
- `DOMAIN` - Your domain name
- `EMAIL` - Your email for SSL certificates
- `MYSQL_ROOT_PASSWORD` - MySQL root password
- `MYSQL_DATABASE` - Database name (default: v2board)

### 4. Configure Caddy

Edit `caddy.conf` and replace placeholders:
- Replace `domain` with your actual domain name (e.g., `example.com`)
- Replace `email_address` with your email address

```bash
nano caddy.conf
```

### 5. Start Services

```bash
# Using docker compose
docker compose up -d

# Or using make
make start
```

## Development Mode

For local development without configuring a domain, use the development setup:

### Quick Start (Development)

```bash
# Start in development mode (accepts localhost)
./dev.sh up -d

# View logs
./dev.sh logs -f

# Stop services
./dev.sh down

# Restart
./dev.sh restart
```

Access the application at `http://localhost`

### Development Files

| File | Description |
|------|-------------|
| `dev.sh` | Script to run docker compose with dev config |
| `caddy.dev.conf` | Caddy config that accepts any hostname |
| `docker-compose.dev.yaml` | Override for development environment |

### 6. Install V2Board

Run the automated installation:

```bash
make install
```

Then open a shell and complete the installation:

```bash
make shell
php artisan v2board:install
```

**Database Configuration (during installation):**
- Database Address: `mysql`
- Database Name: `v2board` (or your custom name from `.env`)
- Database Username: `root`
- Database Password: Check your `.env` file (default: `v2boardisbest`)

After installation completes:

```bash
chmod -R 755 ${PWD}
exit
```

Restart services:

```bash
make restart
# or
docker compose restart
```

## Configuration

### Environment Variables

All environment variables are defined in `.env`. Key variables:

| Variable | Description | Default |
|----------|-------------|----------|
| `DOMAIN` | Your domain name | example.com |
| `EMAIL` | Email for SSL certificates | your-email@example.com |
| `MYSQL_ROOT_PASSWORD` | MySQL root password | v2boardisbest |
| `MYSQL_DATABASE` | Database name | v2board |
| `MYSQL_USER` | MySQL user | v2board |
| `MYSQL_PASSWORD` | MySQL user password | v2boardpassword |
| `HTTP_PORT` | HTTP port | 80 |
| `HTTPS_PORT` | HTTPS port | 443 |

### Database Configuration

MySQL 8.0 is used by default. The database uses native password authentication for compatibility.

## Usage

### Makefile Commands

The project includes a Makefile for common operations:

```bash
make help          # Show all available commands
make start         # Start all containers
make stop          # Stop all containers
make restart       # Restart all containers
make status        # Show container status
make logs          # Show logs from all containers
make logs-www      # Show logs from www container
make logs-mysql    # Show logs from mysql container
make shell         # Open bash shell in www container
make shell-mysql   # Open mysql shell
make update        # Update www submodule
make install       # Run initial V2Board installation
make clean         # Stop and remove all containers
```

### Manual Docker Compose Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs -f

# Access www container shell
docker compose exec www bash

# Access MySQL shell
docker compose exec mysql mysql -uroot -p
```

## Updating

### Update V2Board Application

```bash
# Update the www submodule
make update

# Enter the www container
make shell

# Update Composer dependencies
rm -rf composer.lock composer.phar composer-setup.php
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php composer.phar update

# Run V2Board update
php artisan v2board:update
php artisan config:cache

exit

# Restart services
make restart
```

### Update Docker Images

```bash
docker compose pull
docker compose up -d
```

## Troubleshooting

### Container won't start

```bash
# Check container logs
make logs

# Check specific service
make logs-www
make logs-mysql

# Check container status
make status
```

### Database connection errors

1. Verify MySQL is healthy:
   ```bash
   docker compose ps
   ```

2. Check database credentials in `.env` match those used during installation

3. Verify the database host is set to `mysql` (not `localhost`)

### Permission issues

```bash
# Fix permissions
make shell
chmod -R 755 /www
chown -R www-data:www-data /www/storage /www/bootstrap/cache
exit
```

### SSL/HTTPS issues

1. Ensure your domain points to your server
2. Check that ports 80 and 443 are open
3. Verify email and domain are correctly set in `caddy.conf`
4. Check Caddy logs: `make logs-www`

### MySQL 8.0 compatibility

If you encounter authentication issues with older clients:

```bash
make shell-mysql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'your_password';
FLUSH PRIVILEGES;
exit
```

### Reset everything

```bash
# Warning: This will delete all data!
make clean
rm -rf mysql/ .caddy/ wwwlogs/
make start
# Then reinstall
```

## Project Structure

```
v2board-docker/
├── .env.example                          # Environment variables template
├── .gitignore                            # Git ignore rules
├── docker-compose.yaml                   # Docker Compose configuration (production)
├── docker-compose.dev.yaml               # Docker Compose override (development)
├── docker-compose.override.yaml.example  # Override template for custom config
├── Makefile                              # Common commands
├── dev.sh                                # Development startup script
├── caddy.conf                            # Caddy config (production - requires domain)
├── caddy.dev.conf                        # Caddy config (development - accepts any host)
├── supervisord.conf                      # Supervisor configuration
├── crontabs.conf                         # Cron jobs configuration
├── readme.md                             # This file
├── www/                                  # V2Board application (submodule)
├── mysql/                                # MySQL data (created on first run)
├── wwwlogs/                              # Web server logs
└── .caddy/                               # Caddy certificates and data
```

## Links

- **Project Repository**: https://github.com/hashcott/v2board-docker.git
- **V2Board**: https://github.com/v2board/v2board

## License

This project follows the same license as V2Board.
