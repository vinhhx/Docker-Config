FROM php:8.3-fpm-alpine

# Cài đặt các thư viện hệ thống và phần mở rộng PHP cần thiết cho Laravel
RUN apk update && apk add --no-cache \
    git \
    curl \
    bash \
    libzip-dev \
    libpq-dev \
    pngquant optipng \
    autoconf \
    g++ \
    gcc \
    libc-dev \
    icu-dev \
    make \
    # Các thư viện cho tiện ích mở rộng
    libpng-dev \
    libjpeg-turbo-dev \
    oniguruma-dev \
    zip unzip \
    # Xóa cache apk để giảm kích thước image
    && rm -rf /var/cache/apk/*

# Cài đặt extension Redis qua PECL
RUN pecl install redis \
    && docker-php-ext-enable redis

# Cài đặt các phần mở rộng PHP yêu cầu bởi Laravel (ví dụ: pdo_mysql, zip, bcmath, gd, opcache)
# Sử dụng docker-php-ext-install để cài đặt chúng
RUN docker-php-ext-install pdo_mysql zip bcmath gd opcache exif \
    && docker-php-ext-enable pdo_mysql zip bcmath gd opcache exif \
    && docker-php-ext-install intl \
    && docker-php-ext-install pdo_pgsql

# Cài đặt Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# (Tùy chọn) Sao chép mã nguồn ứng dụng Laravel vào thư mục làm việc. 
# Trong môi trường phát triển, thường dùng volume mount.
# COPY . /var/www/html

WORKDIR /var/www
# Gán quyền sở hữu thư mục cho user www-data (user mặc định của php-fpm)
# Set quyền cho storage và bootstrap/cache
RUN chown -R www-data:www-data /var/www


# Expose port mặc định của PHP-FPM
EXPOSE 9000

# Lệnh mặc định để khởi động PHP-FPM
CMD ["php-fpm"]