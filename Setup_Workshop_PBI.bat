@echo off
setlocal enabledelayedexpansion
title Workshop Power BI Setup - By Ronny Sadam Husen

:: ==========================================
:: LOGGING SETUP
:: ==========================================
set "LOG_FILE=%~dp0setup_debug.log"
if exist "%LOG_FILE%" del "%LOG_FILE%"

call :Log "=== SETUP DIMULAI ==="
call :Log "Waktu: %DATE% %TIME%"

:: =======================================================
::                 INFORMASI PENGEMBANG
:: =======================================================
echo.
echo  ===================================================
echo   WORKSHOP FIRST STEP INTO POWER BI DASHBOARD
echo  ===================================================
echo   Created by : Ronny Sadam Husen
echo   LinkedIn   : linkedin.com/in/ronnysadamhusen
echo   GitHub     : github.com/ronnysadamhusen
echo   Version    : 3.0 (Auto-Import Database)
echo  ===================================================
echo.
echo  Skrip ini akan mempersiapkan laptop Anda:
echo  1. Menginstal Power BI Desktop
echo  2. Menginstal Docker Desktop + SQL Edge
echo  3. Menyiapkan User Database
echo  4. Mengimpor Database Dummy (fms)
echo.
echo  [DEBUG INFO]
echo  Jika skrip macet atau berjalan lama, cek file log di:
echo  "%LOG_FILE%"
echo.
echo  [PENTING] Pastikan koneksi internet stabil.
echo.
pause

:: ==========================================
:: KONFIGURASI
:: ==========================================
set "DOCKER_EXE=C:\Program Files\Docker\Docker\resources\bin\docker.exe"
set "DOCKER_APP=C:\Program Files\Docker\Docker\Docker Desktop.exe"
set "TARGET_DIR=C:\dec\wspbi"
set "SQL_FILE=%~dp0setup_database_fms.sql"

:: 1. SIAPKAN FOLDER KERJA
echo.
call :Log "[1/11] Menyiapkan folder kerja di C:\dec\wspbi..."
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"
cd /d "%TARGET_DIR%"
call :Log "Current Directory: %CD%"

:: 2. DETEKSI & INSTALASI POWER BI
call :Log "[2/11] Mengecek instalasi Power BI Desktop via Winget..."
echo [WINGET OUTPUT START] >> "%LOG_FILE%"
winget list --id Microsoft.PowerBI >> "%LOG_FILE%" 2>&1
echo [WINGET OUTPUT END] >> "%LOG_FILE%"

if %errorlevel% equ 0 (
    call :Log "[INFO] Power BI Desktop sudah terinstal."
) else (
    call :Log "[INFO] Power BI belum ditemukan. Mengunduh dan Menginstal..."
    winget install --id Microsoft.PowerBI --accept-package-agreements --accept-source-agreements >> "%LOG_FILE%" 2>&1
    timeout /t 10 >nul
)

:: 3. STOP DOCKER LAMA
if exist "%DOCKER_EXE%" (
    call :Log "[3/11] Mematikan container yang mungkin sedang berjalan..."
    "%DOCKER_EXE%" compose down >> "%LOG_FILE%" 2>&1
)

:: 4. CEK DOCKER DESKTOP
call :Log "[4/11] Mengecek Docker Desktop..."
if not exist "%DOCKER_EXE%" (
    call :Log "Docker belum ada. Menginstal via Winget..."
    winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements >> "%LOG_FILE%" 2>&1
    call :Log "[PENTING] Instalasi Docker selesai. SILAKAN RESTART LAPTOP dan jalankan skrip ini lagi."
    pause
    exit
)

:: 5. MEMASTIKAN ENGINE AKTIF
call :Log "[5/11] Memastikan Docker Engine aktif..."
"%DOCKER_EXE%" info >> "%LOG_FILE%" 2>&1
if !errorlevel! equ 0 goto :docker_ready

call :Log "Membuka aplikasi Docker Desktop..."
if exist "%DOCKER_APP%" start "" "%DOCKER_APP%"

:wait_engine
timeout /t 5 >nul
"%DOCKER_EXE%" info >nul 2>&1
if !errorlevel! neq 0 (
    echo      ... masih menunggu Docker ...
    goto :wait_engine
)

:docker_ready
call :Log "Docker Engine SIAP!"

:: 6. MEMBUAT CONFIG YAML
call :Log "[6/11] Membuat konfigurasi Database..."
(
echo services:
echo   sql-edge:
echo     image: mcr.microsoft.com/azure-sql-edge:latest
echo     container_name: sql-express-workshop
echo     restart: always
echo     environment:
echo       - ACCEPT_EULA=Y
echo       - MSSQL_SA_PASSWORD=Workshop_Password_2026!
echo       - MSSQL_PID=Developer
echo       - MSSQL_USER=root
echo     ports:
echo       - "1433:1433"
echo     volumes:
echo       - sql_volume_wspbi:/var/opt/mssql
echo     user: "root"
echo volumes:
echo   sql_volume_wspbi:
) > docker-compose.yml

:: 7. JALANKAN CONTAINER
call :Log "[7/11] Menjalankan Database Container..."
"%DOCKER_EXE%" compose up -d >> "%LOG_FILE%" 2>&1

:: 8. HEALTH CHECK
call :Log "[8/11] Menunggu Database siap menerima koneksi..."
:wait_sql_ready
timeout /t 5 >nul
"%DOCKER_EXE%" exec -i sql-express-workshop /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Workshop_Password_2026! -Q "SELECT 1" >nul 2>&1
if !errorlevel! neq 0 goto :wait_sql_ready
call :Log "Database Engine SIAP!"

:: 9. BUAT USER 'dec'
call :Log "[9/11] Menyiapkan user akses 'dec'..."
"%DOCKER_EXE%" exec -i sql-express-workshop /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Workshop_Password_2026! -Q "IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'dec') BEGIN CREATE LOGIN dec WITH PASSWORD = 'Siapbisa@2026', CHECK_POLICY = OFF; ALTER SERVER ROLE sysadmin ADD MEMBER dec; END" >> "%LOG_FILE%" 2>&1

:: 10. IMPORT DATABASE DUMMY
call :Log "[10/11] Mengecek file database dummy (setup_database_fms.sql)..."
if exist "%SQL_FILE%" (
    call :Log "File ditemukan. Mengimpor data ke Azure SQL Edge..."
    type "%SQL_FILE%" | "%DOCKER_EXE%" exec -i sql-express-workshop /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Workshop_Password_2026! >> "%LOG_FILE%" 2>&1
    if !errorlevel! equ 0 (
        call :Log "IMPORT BERHASIL: Database 'fms' siap digunakan."
    ) else (
        call :Log "[PERINGATAN] Import selesai dengan beberapa peringatan/error. Cek log."
    )
) else (
    call :Log "[INFO] File 'setup_database_fms.sql' tidak ditemukan. Peserta harus import manual atau pastikan file ada di folder skrip."
)

:: 11. SELESAI
echo.
echo  ===================================================
echo              SETUP BERHASIL (100%%)
echo  ===================================================
echo.
call :Log "Setup Selesai dengan Sukses."
echo  [DATABASE CREDENTIALS]
echo  Server   : localhost
