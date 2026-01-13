@echo off
setlocal enabledelayedexpansion
title Workshop Power BI Setup - By Ronny Sadam Husen

:: ==========================================
:: LOGGING SETUP
:: ==========================================
:: Log disimpan di folder yang sama dengan skrip ini
set "LOG_FILE=%~dp0setup_debug.log"
:: Reset log file setiap kali dijalankan baru
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
echo   Version    : 2.3 (With Debug Logging)
echo  ===================================================
echo.
echo  Skrip ini akan mempersiapkan laptop Anda:
echo  1. Menginstal Power BI Desktop
echo  2. Menginstal Docker Desktop + SQL Edge
echo  3. Menyiapkan Database (Data TIDAK akan dihapus jika sudah ada)
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

:: 1. SIAPKAN FOLDER KERJA
echo.
call :Log "[1/10] Menyiapkan folder kerja di C:\dec\wspbi..."
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"
cd /d "%TARGET_DIR%"
call :Log "Current Directory: %CD%"

:: 2. DETEKSI & INSTALASI POWER BI
call :Log "[2/10] Mengecek instalasi Power BI Desktop via Winget..."
call :Log "NOTE: Proses ini mungkin butuh waktu tergantung koneksi ke Winget Source..."
call :Log "      (Cek log file untuk detail output Winget)"

:: Capture output winget ke log untuk diagnosa
echo [WINGET OUTPUT START] >> "%LOG_FILE%"
winget list --id Microsoft.PowerBI >> "%LOG_FILE%" 2>&1
echo [WINGET OUTPUT END] >> "%LOG_FILE%"

if %errorlevel% equ 0 (
    call :Log "[INFO] Power BI Desktop sudah terinstal."
) else (
    call :Log "[INFO] Power BI belum ditemukan di Winget List."
    call :Log "Mengunduh dan Menginstal Power BI..."
    echo     (Jendela download akan muncul, mohon tunggu sampai 100%%)
    echo.
    
    :: Install dan catat output ke log
    winget install --id Microsoft.PowerBI --accept-package-agreements --accept-source-agreements >> "%LOG_FILE%" 2>&1
    
    echo.
    call :Log "[INFO] Menunggu proses registrasi aplikasi (10 detik)..."
    timeout /t 10 >nul
)

:: 3. STOP DOCKER LAMA (TANPA MENGHAPUS DATA)
if exist "%DOCKER_EXE%" (
    call :Log "[3/10] Mematikan container yang sedang berjalan..."
    "%DOCKER_EXE%" compose down >> "%LOG_FILE%" 2>&1
)

:: 4. CEK DOCKER DESKTOP
call :Log "[4/10] Mengecek Docker Desktop..."
if not exist "%DOCKER_EXE%" (
    call :Log "Docker belum ada. Menginstal via Winget..."
    winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements >> "%LOG_FILE%" 2>&1
    echo.
    call :Log "[PENTING] Instalasi Docker selesai."
    echo     SILAKAN RESTART KOMPUTER ANDA SEKARANG.
    echo     Setelah restart, jalankan skrip ini kembali.
    pause
    exit
)

:: 5. MEMASTIKAN ENGINE AKTIF
call :Log "[5/10] Memastikan Docker Engine aktif..."

:: Cek status awal
"%DOCKER_EXE%" info >> "%LOG_FILE%" 2>&1
if !errorlevel! equ 0 goto :docker_ready

:: Jika belum aktif, buka aplikasinya
call :Log "Membuka aplikasi Docker Desktop..."
if exist "%DOCKER_APP%" (
    start "" "%DOCKER_APP%"
)

call :Log "Menunggu Docker Engine booting (bisa 1-2 menit)..."

:wait_engine
timeout /t 5 >nul
"%DOCKER_EXE%" info >nul 2>&1
if !errorlevel! neq 0 (
    echo     ... masih menunggu Docker ...
    goto :wait_engine
)

:docker_ready
call :Log "Docker Engine SIAP!"

:: 6. MEMBUAT CONFIG YAML (AZURE SQL EDGE)
call :Log "[6/10] Membuat konfigurasi Database..."
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
call :Log "File docker-compose.yml berhasil dibuat."

:: 7. JALANKAN CONTAINER (DATA LAMA AKAN DIMUAT ULANG)
call :Log "[7/10] Menjalankan Database..."
"%DOCKER_EXE%" compose up -d >> "%LOG_FILE%" 2>&1

:: 8. HEALTH CHECK
call :Log "[8/10] Menunggu Database siap menerima koneksi..."
:wait_sql_ready
timeout /t 5 >nul
"%DOCKER_EXE%" exec -i sql-express-workshop /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Workshop_Password_2026! -Q "SELECT 1" >nul 2>&1
if !errorlevel! neq 0 goto :wait_sql_ready
call :Log "Database SIAP!"

:: 9. BUAT USER 'dec' (HANYA JIKA BELUM ADA)
call :Log "[9/10] Mengecek user akses 'dec'..."
"%DOCKER_EXE%" exec -i sql-express-workshop /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Workshop_Password_2026! -Q "IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'dec') BEGIN CREATE LOGIN dec WITH PASSWORD = 'Siapbisa@2026', CHECK_POLICY = OFF; ALTER SERVER ROLE sysadmin ADD MEMBER dec; END" >> "%LOG_FILE%" 2>&1

:: 10. SELESAI
echo.
echo  ===================================================
echo              SETUP BERHASIL (100%%)
echo  ===================================================
echo.
call :Log "Setup Selesai dengan Sukses."
echo  [DATABASE CREDENTIALS]
echo  Server   : localhost
echo  User     : dec
echo  Password : Siapbisa@2026
echo.
echo  [STATUS DATA]
echo  Database Anda disimpan di Volume Docker "sql_volume_wspbi".
echo  Data tidak akan hilang meski laptop dimatikan/restart.
echo.
echo  Terima kasih telah menggunakan skrip ini.
echo  ~ Ronny Sadam Husen
echo  ===================================================
pause
exit /b

:: ==========================================
:: FUNGSI LOGGING
:: ==========================================
:Log
set "MSG=%~1"
echo %MSG%
echo [%DATE% %TIME%] %MSG% >> "%LOG_FILE%"
exit /b
