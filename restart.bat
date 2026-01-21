@echo off
REM Restart script cho project docker base service

cd /d %~dp0

REM --- Dừng docker-compose ---
docker-compose -p docker --env-file .env -f docker-compose.yml down


REM --- Khởi động lại docker-compose ---
docker-compose -p docker --env-file .env -f docker-compose.yml up -d --build

echo.
echo Project docker base đã được restart thành công!
pause