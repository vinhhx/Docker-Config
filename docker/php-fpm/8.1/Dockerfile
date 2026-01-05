FROM php:8.1-fpm-alpine


# -------------------------------------------------------------------
# BƯỚC 1: CÀI ĐẶT CÁC GÓI HỆ THỐNG VÀ CÔNG CỤ BUILD
# -------------------------------------------------------------------

# 1. Cập nhật cache và cài đặt công cụ build cần thiết
RUN apk update && apk upgrade && apk add --no-cache \
    autoconf \
    build-base \
    bison \
    git \
    curl \
    unzip \
    libpng-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    libxml2-dev \
    icu-dev \
    gmp-dev \
    openssl-dev \
    # THÊM GÓI NÀY VÀO
    oniguruma-dev 

# -------------------------------------------------------------------
# BƯỚC 2: CẤU HÌNH VÀ CÀI ĐẶT PHP EXTENSIONS
# -------------------------------------------------------------------

# Cấu hình các extension
RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-configure zip

# Cài đặt Extensions (Bao gồm cả mbstring)
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

# Opcache: Cần được bật thủ công, thường được cài sẵn nhưng nên xác nhận
# RUN docker-php-ext-install opcache # Có thể đã được cài sẵn trong 7.x FPM image

# -------------------------------------------------------------------
# 3. CÀI ĐẶT COMPOSER
# -------------------------------------------------------------------

# Tải và cài đặt Composer vào /usr/local/bin
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# ... (Các lệnh WORKDIR và ENTRYPOINT khác)
