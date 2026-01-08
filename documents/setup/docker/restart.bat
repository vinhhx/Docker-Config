@echo off
REM Restart script cho project karofi base laravel framwork apiato artichitecture

cd /d %~dp0

REM --- Dừng docker-compose ---
docker-compose -p karofi --env-file .env.docker -f docker-compose.project.yml down


REM --- Khởi động lại docker-compose ---
docker-compose -p karofi --env-file .env.docker -f docker-compose.project.yml up -d --build
REM --- Fix quyền cho Laravel ---
echo Set quyền cho storage bootstrap/cache ...
docker exec karofi_php bash -c "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"

echo.
echo Project karofi project đã được restart thành công!
pause