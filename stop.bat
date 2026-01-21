@echo off
REM Stop script cho project docker base service

cd /d %~dp0

REM --- Dừng docker-compose ---
docker-compose -p docker --env-file .env -f docker-compose.yml down

echo.
echo Project docker đã được dừng và config Nginx đã được gỡ bỏ!
pause