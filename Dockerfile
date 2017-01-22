FROM php:fpm

# Install library dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    unixodbc-dev \
    libxml2-dev \
    libaio-dev \
    libmemcached-dev \
    freetds-dev

# Install PHP extensions
RUN pecl install redis \
    && git clone https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
    && cd /usr/src/php/ext/memcached && git checkout -b php7 origin/php7 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu \
    && docker-php-ext-install \
        iconv \
        mbstring \
        intl \
        mcrypt \
        pdo_mysql \
        pdo_dblib \
        soap \
        sockets \
        zip \
        memcached \
        pcntl \
        ftp \
        imagick \
    && docker-php-ext-enable \
        redis \
        opcache \
        imagick

# Install APCu and APC backward compatibility
RUN pecl install apcu \
    && pecl install apcu_bc-1.0.3 \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

# Clean repository
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*
