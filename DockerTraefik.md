Hướng dẫn cấu hình Docker Traefik trên Windows với WSL2

1. Vấn đề thường gặp

Khi chạy Traefik trên Docker Desktop (Windows + WSL2 backend), container Traefik thường không thể kết nối với Docker API qua socket /var/run/docker.sock. Điều này dẫn đến lỗi:

Provider connection error Error response from daemon

Router không xuất hiện trong dashboard.

2. Nguyên nhân

Docker Desktop trên Windows không expose socket /var/run/docker.sock cho WSL2.

Traefik mặc định dùng socket này để đọc labels từ Docker.

3. Giải pháp: Bật Docker API qua TCP

Bước 1: Sửa cấu hình Docker Desktop

Mở Docker Desktop → Settings → Docker Engine và chỉnh file JSON:

{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "hosts": ["tcp://0.0.0.0:2375", "npipe://"]
}

Save & Restart Docker Desktop.

Bước 2: Sửa service Traefik trong docker-compose.yml

Thay vì mount socket, dùng TCP endpoint:

traefik:
  image: traefik:v2.10
  container_name: traefik_proxy
  command:
    - --api.insecure=true
    - --providers.docker=true
    - --providers.docker.endpoint=tcp://host.docker.internal:2375
    - --entrypoints.web.address=:80
  ports:
    - "80:80"
    - "8080:8080"
  networks:
    - dev_network

👉 Lưu ý: bỏ hẳn phần volumes: - /var/run/docker.sock:/var/run/docker.sock:ro.

Bước 3: Restart stack

docker compose down && docker compose up -d
docker logs traefik_proxy

Nếu log báo:

Provider connection established with docker

thì Traefik đã kết nối thành công.

4. Kết quả

Traefik đọc được labels từ Docker.

Router (ví dụ flexfit) xuất hiện trong dashboard.

Truy cập http://flexfit.local sẽ route đúng vào container Nginx của dự án.