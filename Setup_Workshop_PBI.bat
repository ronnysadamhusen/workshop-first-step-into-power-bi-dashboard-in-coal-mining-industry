@echo off
setlocal
title Workshop First Step Into Power BI Dashboard (with WSL2 Support)

:: 1. Membuat direktori kerja
set "TARGET_DIR=C:\dec\wspbi"
echo =======================================================
echo   WORKSHOP FIRST STEP INTO POWER BI DASHBOARD
echo =======================================================
echo [1/7] Menyiapkan folder kerja...
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"
if not exist "%TARGET_DIR%\sql_data" mkdir "%TARGET_DIR%\sql_data"
cd /d "%TARGET_DIR%"

:: 2. Instalasi/Pengecekan WSL 2 (PENTING)
echo [2/7] Mengecek Windows Subsystem for Linux (WSL2)...
wsl --status >nul 2>&1
if %errorlevel% neq 0 (
    echo WSL tidak terdeteksi. Menginstal WSL dan komponen pendukung...
    :: Menginstal WSL tanpa mengunduh distro Linux (biar cepat)
    wsl --install --no-distribution
    echo.
    echo [PENTING] WSL 2 telah diaktifkan. 
    echo WINDOWS HARUS DI-RESTART agar fitur ini berfungsi.
    echo Silakan RESTART sekarang dan jalankan skrip ini lagi setelahnya.
    pause
    exit
) else (
    echo WSL sudah terdeteksi, melanjutkan...
)

:: 3. Cek apakah Docker sudah terinstal
echo [3/7] Mengecek status Docker Desktop...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker belum terdeteksi. Menginstal via Winget...
    winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
    echo.
    echo [PENTING] Docker telah terinstal.
    echo Silakan RESTART KOMPUTER Anda, lalu jalankan skrip ini lagi.
    pause
    exit
)

:: 4. Membuat file docker-compose.yml
echo [4/7] Membuat konfigurasi database...
(
echo version: '3.8'
echo services:
echo   sql-express:
echo     image: mcr.microsoft.com/mssql/server:2022-latest
echo     container_name: sql-express-workshop
echo     restart: always
echo     environment:
echo       - ACCEPT_EULA=Y
echo       - MSSQL_SA_PASSWORD=Workshop_Password_2026!
echo       - MSSQL_PID=Express
echo     ports:
echo       - "1433:1433"
echo     volumes:
echo       - ./sql_data:/var/opt/mssql
echo     user: "0:0"
) > docker-compose.yml

:: 5. Menjalankan Docker Engine
echo [5/7] Memastikan Docker Engine aktif...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo Menunggu Docker Engine aktif (bisa memakan waktu 1-2 menit)...
    :wait_docker
    docker info >nul 2>&1 || (timeout /t 5 >nul & goto wait_docker)
)
docker compose up -d

:: 6. Membuat User 'dec'
echo [6/7] Menyiapkan user akses 'dec'...
timeout /t 30 /nobreak >nul
docker exec -it sql-express-workshop /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P Workshop_Password_2026! -C -Q "IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'dec') BEGIN CREATE LOGIN dec WITH PASSWORD = 'Siapbisa@2026', CHECK_POLICY = OFF; ALTER SERVER ROLE sysadmin ADD MEMBER dec; END"

:: 7. Selesai
echo [7/7] Verifikasi Akhir...
echo.
echo =======================================================
echo              SETUP BERHASIL DISIAPKAN!
echo =======================================================
echo Silakan Login ke SQL Server dengan detail berikut:
echo Server   : localhost
echo Username : dec
echo Password : Siapbisa@2026
echo =======================================================
pause
