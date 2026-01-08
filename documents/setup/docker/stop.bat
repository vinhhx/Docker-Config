@echo off
REM Stop script cho project karofi 

cd /d %~dp0

REM --- Dừng docker-compose ---
docker-compose -p karofi --env-file .env.docker -f docker-compose.project.yml down

echo.
echo Project karofi đã được dừng và config Nginx đã được gỡ bỏ!
pause