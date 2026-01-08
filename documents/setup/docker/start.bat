@echo off
REM Start script cho project karofi project

cd /d %~dp0


REM --- Chạy docker-compose ---
docker-compose -p karofi --env-file .env.docker -f docker-compose.project.yml up -d --build


REM --- Fix quyền cho Laravel ---
echo Set quyền cho runtime và web ...
docker exec karofi_php bash -c "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"



echo.
echo Project karofi đã được khởi động và Nginx đã reload config!
pause