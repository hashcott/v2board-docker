.PHONY: help start stop restart status logs shell shell-mysql update install clean

# Default target
help:
	@echo "V2Board Docker Management"
	@echo ""
	@echo "Available commands:"
	@echo "  make start        - Start all containers"
	@echo "  make stop         - Stop all containers"
	@echo "  make restart      - Restart all containers"
	@echo "  make status       - Show container status"
	@echo "  make logs         - Show logs from all containers"
	@echo "  make logs-www     - Show logs from www container"
	@echo "  make logs-mysql   - Show logs from mysql container"
	@echo "  make shell        - Open bash shell in www container"
	@echo "  make shell-mysql  - Open mysql shell"
	@echo "  make update       - Update www submodule"
	@echo "  make install      - Run initial V2Board installation"
	@echo "  make clean        - Stop and remove all containers, networks"

# Start containers
start:
	docker compose up -d

# Stop containers
stop:
	docker compose down

# Restart containers
restart:
	docker compose restart

# Show container status
status:
	docker compose ps

# Show logs
logs:
	docker compose logs -f

# Show www logs only
logs-www:
	docker compose logs -f www

# Show mysql logs only
logs-mysql:
	docker compose logs -f mysql

# Open shell in www container
shell:
	docker compose exec www bash

# Open mysql shell
shell-mysql:
	docker compose exec mysql mysql -uroot -p$${MYSQL_ROOT_PASSWORD:-v2boardisbest}

# Update www submodule
update:
	git submodule update --remote www
	@echo "Submodule updated. Run 'make restart' to apply changes."

# Initial V2Board installation
install:
	@echo "Starting V2Board installation..."
	@echo "Make sure containers are running first (make start)"
	docker compose exec www bash -c "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\" && php composer-setup.php && php composer.phar install"
	@echo ""
	@echo "Now run: make shell"
	@echo "Then run: php artisan v2board:install"
	@echo ""
	@echo "Database configuration:"
	@echo "  Address: mysql"
	@echo "  Database: v2board (or check your .env file)"
	@echo "  Username: root"
	@echo "  Password: check your .env file (default: v2boardisbest)"

# Clean up everything
clean:
	docker compose down -v
	@echo "All containers and volumes removed."
