@echo off
REM Stop script cho project lpbank

cd /d %~dp0

REM --- Dừng docker-compose ---
docker-compose -p lpbank --env-file .env.docker -f docker-compose.project.yml down

echo.
echo Project lpbank đã được dừng và config Nginx đã được gỡ bỏ!
pause