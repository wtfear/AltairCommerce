FROM php:8.4-cli-alpine

WORKDIR /var/www/html

RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    icu-dev \
    libzip-dev \
    oniguruma-dev \
    nodejs \
    npm \
    bash \
    mysql-client \
    && docker-php-ext-install pdo pdo_mysql mbstring zip gd intl bcmath opcache

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . .

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PORT=8000

RUN composer install --no-dev --optimize-autoloader --no-interaction --ignore-platform-reqs

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
