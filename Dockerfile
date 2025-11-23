FROM php:8.2-fpm-alpine

# Install system deps
RUN apk add --no-cache nginx supervisor bash curl git libzip-dev \
    oniguruma-dev icu-dev zlib-dev mariadb-client build-base

# PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring intl exif pcntl zip opcache

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Nginx config
RUN mkdir -p /run/nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Supervisor to run both Nginx + PHP-FPM
COPY supervisord.conf /etc/supervisord.conf

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
