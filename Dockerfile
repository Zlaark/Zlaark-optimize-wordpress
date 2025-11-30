FROM php:8.2-fpm-alpine

# Install system packages
RUN apk update && apk add --no-cache \
    nginx \
    supervisor \
    curl \
    unzip \
    bash \
    $PHPIZE_DEPS

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Install Redis (phpredis)
RUN pecl install redis \
    && docker-php-ext-enable redis

# Download WordPress
RUN curl -o /tmp/latest.zip https://wordpress.org/latest.zip \
    && unzip /tmp/latest.zip -d /var/www \
    && mv /var/www/wordpress/* /var/www/html/ \
    && rm -rf /var/www/wordpress /tmp/latest.zip

# Copy configs
COPY ./default.conf /etc/nginx/http.d/default.conf
COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./php.ini /usr/local/etc/php/php.ini
COPY ./supervisord.conf /etc/supervisord.conf

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
