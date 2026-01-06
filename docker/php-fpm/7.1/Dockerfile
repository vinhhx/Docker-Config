FROM php:7.1-fpm-alpine

# Cài đặt các dependencies hệ thống
# Lưu ý: PHP 7.1 vẫn dùng mcrypt (đã bị loại bỏ từ PHP 7.2)
RUN apk add --no-cache \
    bash \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libmcrypt-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    oniguruma-dev

# Cấu hình và cài đặt extensions
# Cú pháp configure GD của PHP 7.1 khác với PHP 7.4/8.x
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    mcrypt \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

# Cài đặt Composer (Nên dùng bản 2.2 cho các dự án cũ để tránh lỗi tương thích)
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# (Tùy chọn) Sao chép mã nguồn ứng dụng Laravel vào thư mục làm việc. 
# Trong môi trường phát triển, thường dùng volume mount.
# COPY . /var/www/html

# Gán quyền sở hữu thư mục cho user www-data (user mặc định của php-fpm)
RUN chown -R www-data:www-data /var/www/html

# Expose port mặc định của PHP-FPM
EXPOSE 9000

# Lệnh mặc định để khởi động PHP-FPM
CMD ["php-fpm"]