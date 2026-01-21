@echo off
REM Start script cho project docker services

cd /d %~dp0


REM --- Chạy docker-compose ---
docker-compose -p docker --env-file .env -f docker-compose.yml up -d --build


echo.
echo Project docker đã được khởi động và Nginx đã reload config!
pause