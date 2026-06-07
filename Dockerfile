FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libzip-dev \
    sqlite3 \
    libsqlite3-dev \
    && docker-php-ext-install zip pdo pdo_sqlite

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock ./

RUN composer install --no-dev --optimize-autoloader --no-scripts

COPY . .

RUN php artisan config:clear
RUN php artisan route:clear
RUN php artisan view:clear

CMD unset PHP_CLI_SERVER_WORKERS && php artisan serve --host=0.0.0.0 --port=${PORT}