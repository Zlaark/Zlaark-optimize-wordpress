FROM php:8.2-fpm-alpine

RUN apk update && apk add --no-cache \
    nginx \
    supervisor \
    curl \
    unzip \
    bash

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN curl -o /tmp/latest.zip https://wordpress.org/latest.zip \
    && unzip /tmp/latest.zip -d /var/www \
    && mv /var/www/wordpress/* /var/www/html/ \
    && rm -rf /var/www/wordpress /tmp/latest.zip

# Nginx main config + site config
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/http.d/default.conf

# Correct PHP-FPM config copy
COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

# Supervisor
COPY ./supervisord.conf /etc/supervisord.conf

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
