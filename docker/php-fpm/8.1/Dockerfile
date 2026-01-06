FROM php:8.1-fpm-alpine

# Cài đặt các thư viện hệ thống cần thiết
# Lưu ý: 'oniguruma-dev' là bắt buộc để cài đặt extension 'mbstring'
RUN apk add --no-cache \
    oniguruma-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl

# Cài đặt các extension PHP cho Laravel
RUN docker-php-ext-install \
    pdo_mysql \
    mbstring \
    zip \
    exif \
    pcntl \
    bcmath \
    gd

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Phân quyền cho Laravel
RUN chown -R www-data:www-data /var/www

EXPOSE 9000
CMD ["php-fpm"]