FROM php:8.1-fpm-alpine

# Cài đặt các thư viện hệ thống cần thiết
# Lưu ý: 'oniguruma-dev' là bắt buộc để cài đặt extension 'mbstring'
RUN apk add --no-cache \
    git \
    curl \
    bash \
    libzip-dev \
    pngquant optipng \
    autoconf \
    g++ \
    gcc \
    libc-dev \
    icu-dev \
    make \
    libpng-dev \
    libjpeg-turbo-dev \
    oniguruma-dev \
    zip unzip \
	freetype-dev

# Cài đặt các phần mở rộng PHP yêu cầu bởi Laravel (ví dụ: pdo_mysql, zip, bcmath, gd, opcache)
# Sử dụng docker-php-ext-install để cài đặt chúng
RUN docker-php-ext-install pdo_mysql zip bcmath gd opcache exif \
    && docker-php-ext-enable pdo_mysql zip bcmath gd opcache exif \
    && docker-php-ext-install intl
	
# Biên dịch extension gd với jpeg, png
RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install gd

RUN rm -rf /var/cache/apk/*

# Cài đặt Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# (Tùy chọn) Sao chép mã nguồn ứng dụng Laravel vào thư mục làm việc. 
# Trong môi trường phát triển, thường dùng volume mount.
# COPY . /var/www/html

WORKDIR /var/www
# Gán quyền sở hữu thư mục cho user www-data (user mặc định của php-fpm)
# Set quyền cho storage và bootstrap/cache
RUN chown -R www-data:www-data /var/www