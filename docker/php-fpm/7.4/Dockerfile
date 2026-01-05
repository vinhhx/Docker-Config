FROM php:7.4-fpm-alpine

# BƯỚC 1: CÀI ĐẶT GÓI HỆ THỐNG
RUN apk update && apk upgrade && apk add --no-cache \
    autoconf \
    build-base \
    bison \
    # THÊM CÔNG CỤ NÀY VÀO
    pkgconf \
    # Dependency cho mbstring
    oniguruma-dev \
    # Các dependencies khác
    git \
    curl \
    unzip \
    libpng-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    libxml2-dev \
    icu-dev \
    gmp-dev \
    openssl-dev

# -------------------------------------------------------------------
# BƯỚC 2: CẤU HÌNH VÀ CÀI ĐẶT PHP EXTENSIONS
# -------------------------------------------------------------------

# Thay thế lệnh configure cũ
# TỪ: docker-php-ext-configure gd --with-jpeg-dir=/usr/include/
# SANG:
RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-configure zip

# BƯỚC 3: CÀI ĐẶT EXTENSIONS
RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mbstring \
    tokenizer \
    xml \
    json \
    bcmath \
    zip \
    gd \
    exif \
    intl \
    opcache

# -------------------------------------------------------------------
# BƯỚC 4: CÀI ĐẶT COMPOSER
# -------------------------------------------------------------------

# Tải và cài đặt Composer (sử dụng RUN mới)
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# -------------------------------------------------------------------
# CẤU HÌNH CUỐI CÙNG
# -------------------------------------------------------------------
WORKDIR /var/www/html