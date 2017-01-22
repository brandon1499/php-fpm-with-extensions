FROM php:fpm-alpine

# PHP extensions

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql
