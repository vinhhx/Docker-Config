FROM php:8.3-fpm-alpine

# Cài đặt các Dependencies hệ thống cần thiết (Alpine)
RUN apk add --no-cache \
    git \
    curl \
    unzip \
    bison \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    icu-dev \
    gmp-dev \
    # THÊM GÓI NÀY VÀO
    oniguruma-dev 
    
# -------------------------------------------------------------------
# 1. CÀI ĐẶT PHP EXTENSIONS
# -------------------------------------------------------------------

# Các gói Bắt buộc & Phổ biến cho Laravel
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
    intl

# Opcache: Cần được bật thủ công, thường được cài sẵn nhưng nên xác nhận
# RUN docker-php-ext-install opcache # Có thể đã được cài sẵn trong 7.x FPM image

# -------------------------------------------------------------------
# 2. CÀI ĐẶT COMPOSER
# -------------------------------------------------------------------

# Tải và cài đặt Composer vào /usr/local/bin
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# ... (Các lệnh WORKDIR và ENTRYPOINT khác)