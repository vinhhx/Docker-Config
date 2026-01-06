FROM php:7.4-fpm-alpine

# Cài đặt các thư viện hệ thống cần thiết cho PHP 7.4
# Lưu ý: oniguruma-dev là bắt buộc cho mbstring trên PHP 7.4+
RUN apk add --no-cache \
    bash \
    curl \
    libpng-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    oniguruma-dev \
    $PHPIZE_DEPS

# Cấu hình và cài đặt các PHP extensions
# Riêng gd cần configure để hỗ trợ jpeg/freetype
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    xml

# Cài đặt Composer (phiên bản 2.x vẫn hỗ trợ PHP 7.4)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# (Tùy chọn) Sao chép mã nguồn ứng dụng Laravel vào thư mục làm việc. 
# Trong môi trường phát triển, thường dùng volume mount.
# COPY . /var/www/html

# Gán quyền sở hữu thư mục cho user www-data (user mặc định của php-fpm)
RUN chown -R www-data:www-data /var/www/html

# Expose port mặc định của PHP-FPM
EXPOSE 9000

# Lệnh mặc định để khởi động PHP-FPM
CMD ["php-fpm"]