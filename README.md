## Hướng dẫn Setup Project với Docker Container

Hướng dẫn này sẽ giúp bạn thiết lập một dự án sử dụng Docker containers cho Nginx, PHP-FPM, MySQL và PostgreSQL dựa trên cấu hình Docker hiện có.

### 1. Cấu trúc thư mục

Đảm bảo cấu trúc thư mục dự án của bạn tương tự như sau:

```javascript
.env
docker-compose.yml
...
docker/
├── nginx/
│   ├── Dockerfile
│   └── conf.d/
│       └── default.conf
└── php-fpm/
    ├── 7.1/
    │   └── Dockerfile
    ├── 7.4/
    │   └── Dockerfile
    ├── 8.1/
    │   └── Dockerfile
    └── 8.3/
        └── Dockerfile
mysql/
├── data/ (Sẽ được tạo tự động bởi Docker)
└── .gitignore
nginx/
├── certs/ (Để chứa các chứng chỉ SSL nếu có)
├── conf.d/ (Chứa default.conf, hoặc các cấu hình Nginx khác)
└── logs/ (Logs của Nginx)
php-fpm/
└── .gitignore
postgres/
└── data/ (Sẽ được tạo tự động bởi Docker)
```

### 2. Cấu hình file `.env`

Tạo một file `.env` trong thư mục gốc của dự án của bạn (nếu chưa có) và điền các biến môi trường cần thiết cho MySQL và PostgreSQL. Dưới đây là ví dụ:

```dotenv
# MySQL Configuration
MYSQL_ROOT_PASSWORD=your_mysql_root_password
MYSQ_ALLOW_EMPTY_PASSWORD=yes
MYSQL_DATABASE=your_database_name
MYSQL_USER=your_username
MYSQL_PASSWORD=your_password

# PostgreSQL Configuration
POSTGRES_DB=your_postgres_database
POSTGRES_USER=your_postgres_user
POSTGRES_PASSWORD=your_postgres_password
```

Thay đổi `your_mysql_root_password`, `your_database_name`, `your_username`, `your_password`, `your_postgres_database`, `your_postgres_user`, `your_postgres_password` thành các giá trị mong muốn của bạn.

### 3. Cấu hình `docker-compose.yml`

File `docker-compose.yml` đã được cấu hình sẵn để định nghĩa các dịch vụ `nginx`, `mysql` và `postgres`. Đảm bảo rằng file này nằm ở thư mục gốc của dự án.

```yaml
version: "3.9"

services:
  nginx:
    image: nginx:latest
    container_name: nginx_proxy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./nginx/certs:/etc/nginx/certs:ro
      - ./nginx/logs:/var/log/nginx
    networks:
      - dev_network

  mysql:
    image: mysql:8.0
    container_name: mysql_server
    restart: always
    env_file:
      - .env
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_ALLOW_EMPTY_PASSWORD: ${MYSQL_ALLOW_EMPTY_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - ./mysql/data:/var/lib/mysql
    networks:
      - dev_network

  postgres:
    image: postgres:15
    container_name: postgres_server
    restart: always
    env_file:
      - .env
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - ./postgres/data:/var/lib/postgresql/data
    networks:
      - dev_network

networks:
  dev_network:
    external: true
```

### 4. Cấu hình Nginx

File `docker/nginx/Dockerfile` và `docker/nginx/conf.d/default.conf` được sử dụng để xây dựng image Nginx và cấu hình server block. `default.conf` hiện tại được cấu hình để phục vụ các ứng dụng PHP và chuyển tiếp các yêu cầu `.php` đến `php-fpm-8.3:9000`.

__`docker/nginx/Dockerfile`__

```dockerfile
FROM nginx:alpine

WORKDIR /etc/nginx/conf.d
```

__`docker/nginx/conf.d/default.conf`__

```nginx
server {
    listen 80;
    server_name localhost;
    root /var/www/html;

    index index.php index.html;

    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ .php$ {
        fastcgi_pass php-fpm-8.3:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
```

### 5. Cấu hình PHP-FPM

Các Dockerfile cho PHP-FPM (ví dụ: `docker/php-fpm/8.3/Dockerfile`) được sử dụng để xây dựng các image PHP với các extension cần thiết cho Laravel và Composer.

__`docker/php-fpm/8.3/Dockerfile`__

```dockerfile
FROM php:8.3-fpm-alpine

# Cài đặt các thư viện hệ thống và phần mở rộng PHP cần thiết cho Laravel
RUN apk update && apk add --no-cache \
    git \
    curl \
    bash \
    libzip-dev \
    pngquant optipng \
    autoconf \
    g++ \
    gcc \
    libc-dev \
    make \
    # Các thư viện cho tiện ích mở rộng
    libpng-dev \
    libjpeg-turbo-dev \
    oniguruma-dev \
    # Xóa cache apk để giảm kích thước image
    && rm -rf /var/cache/apk/*

# Cài đặt các phần mở rộng PHP yêu cầu bởi Laravel (ví dụ: pdo_mysql, zip, bcmath, gd, opcache)
# Sử dụng docker-php-ext-install để cài đặt chúng
RUN docker-php-ext-install pdo_mysql zip bcmath gd opcache exif \
    && docker-php-ext-enable pdo_mysql zip bcmath gd opcache exif

# Cài đặt Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html
# Gán quyền sở hữu thư mục cho user www-data (user mặc định của php-fpm)
# Set quyền cho storage và bootstrap/cache
RUN chown -R www-data:www-data /var/www/html

# Expose port mặc định của PHP-FPM
EXPOSE 9000

# Lệnh mặc định để khởi động PHP-FPM
CMD ["php-fpm"]
```

### 6. Khởi động Project

Để khởi động tất cả các dịch vụ Docker, bạn cần đảm bảo rằng `dev_network` đã được tạo. Nếu chưa, hãy tạo nó bằng lệnh:

```bash
docker network create dev_network
```

Sau đó, điều hướng đến thư mục gốc của dự án của bạn (nơi chứa `docker-compose.yml`) và chạy lệnh sau:

```bash
docker-compose up -d
```

Lệnh này sẽ xây dựng các image (nếu chưa có) và khởi động các container trong chế độ detached (chạy ngầm).

### 7. Truy cập ứng dụng

Sau khi các container đã chạy, bạn có thể truy cập ứng dụng của mình qua trình duyệt bằng cách truy cập `http://localhost`.

### 8. Dừng và xóa containers

Để dừng các container:

```bash
docker-compose stop
```

Để dừng và xóa các container, network (nếu không được sử dụng bởi các dịch vụ khác), và volumes (dữ liệu MySQL/PostgreSQL sẽ bị mất nếu không sao lưu):

```bash
docker-compose down -v
```

Hướng dẫn này cung cấp một cái nhìn tổng quan về cách thiết lập dự án của bạn với Docker containers dựa trên các file cấu hình hiện có. Bạn có thể điều chỉnh các file Dockerfile và cấu hình Nginx để phù hợp với yêu cầu cụ thể của dự án.
