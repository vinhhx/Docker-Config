FROM php:7.1-fpm-alpine

# -------------------------------------------------------------------
# BƯỚC 1: CÀI ĐẶT CÁC GÓI HỆ THỐNG (SYSTEM DEPENDENCIES)
# -------------------------------------------------------------------
# Cài đặt các thư viện hệ thống cần thiết cho PHP Extensions và Composer.
RUN apk add --no-cache \
    # Cần cho Composer
    git \
    curl \
    unzip \
    # Dependencies cho gd và exif
    libpng-dev \
    libjpeg-turbo-dev \
    # Dependency cho zip
    libzip-dev \
    # Dependency cho xml
    libxml2-dev \
    # Dependency cho intl
    icu-dev \
    # Dependency cho bcmath
    gmp-dev \
    # Gói hỗ trợ SSL (nếu cần)
    openssl-dev

# Cấu hình các extension cần thêm tham số (như gd)
# Cần thực hiện trước khi chạy docker-php-ext-install
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/

# -------------------------------------------------------------------
# BƯỚC 2: CÀI ĐẶT PHP EXTENSIONS
# -------------------------------------------------------------------
# Cài đặt các PHP Extensions bắt buộc và phổ biến cho Laravel.
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
# BƯỚC 3: CÀI ĐẶT COMPOSER
# -------------------------------------------------------------------

# Tải và cài đặt Composer vào /usr/local/bin/ để có thể gọi trực tiếp 'composer'
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# -------------------------------------------------------------------
# BƯỚC 4: CẤU HÌNH CUỐI CÙNG
# -------------------------------------------------------------------

# Đặt thư mục làm việc mặc định
WORKDIR /var/www/html

# (Tuỳ chọn) Nếu bạn muốn cấu hình PHP-FPM chi tiết hơn, bạn có thể thêm file .ini ở đây:
# COPY ./php.ini /usr/local/etc/php/conf.d/custom.ini