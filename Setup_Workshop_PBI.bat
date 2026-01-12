@echo off
setlocal enabledelayedexpansion
title Workshop Power BI Setup - By Ronny Sadam Husen

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
echo   Version    : 2.0 (Data Persistent / Aman)
echo  ===================================================
echo.
echo  Skrip ini akan mempersiapkan laptop Anda:
echo  1. Menginstal Power BI Desktop
echo  2. Menginstal Docker Desktop + SQL Edge
echo  3. Menyiapkan Database (Data TIDAK akan dihapus jika sudah ada)
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
echo [1/10] Menyiapkan folder kerja di C:\dec\wspbi...
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"
cd /d "%TARGET_DIR%"

:: 2. DETEKSI & INSTALASI POWER BI
echo [2/10] Mengecek instalasi Power BI Desktop...

winget list --id Microsoft.PowerBI >nul 2>&1
if %errorlevel% equ 0 (
    echo     [INFO] Power BI Desktop sudah terinstal.
) else (
    echo     [INFO] Power BI belum ditemukan.
    echo     Mengunduh dan Menginstal...
    echo     (Jendela download akan muncul, mohon tunggu sampai 100%%)
    echo.
    winget install --id Microsoft.PowerBI --accept-package-agreements --accept-source-agreements
    
    echo.
    echo     [INFO] Menunggu proses registrasi aplikasi (10 detik)...
    timeout /t 10 >nul
)

:: 3. STOP DOCKER LAMA (TANPA MENGHAPUS DATA)
if exist "%DOCKER_EXE%" (
    echo [3/10] Mematikan container yang sedang berjalan...
    :: Menghapus flag -v agar Volume Data tetap AMAN
    "%DOCKER_EXE%" compose down >nul 2>&1
)

:: 4. CEK DOCKER DESKTOP
echo [4/10] Mengecek Docker Desktop...
if not exist "%DOCKER_EXE%" (
    echo     Docker belum ada. Menginstal via Winget...
    winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
    echo.
    echo     [PENTING] Instalasi Docker selesai. 
    echo     SILAKAN RESTART KOMPUTER ANDA SEKARANG.
    echo     Setelah restart, jalankan skrip ini kembali.
    pause
    exit
)

:: 5. MEMASTIKAN ENGINE AKTIF
echo [5/10] Memastikan Docker Engine aktif...

:: Cek status awal
"%DOCKER_EXE%" info >nul 2>&1
if !errorlevel! equ 0 goto :docker_ready

:: Jika belum aktif, buka aplikasinya
echo     Membuka aplikasi Docker Desktop...
if exist "%DOCKER_APP%" (
    start "" "%DOCKER_APP%"
)

echo     Menunggu Docker Engine booting (bisa 1-2 menit)...

:wait_engine
timeout /t 5 >nul
"%DOCKER_EXE%" info >nul 2>&1
if !errorlevel! neq 0 (
    echo     ... masih menunggu Docker ...
    goto :wait_engine
)

:docker_ready
echo     Docker Engine SIAP!

:: 6. MEMBUAT CONFIG YAML (AZURE SQL EDGE)
echo [6/10] Membuat konfigurasi Database...
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

:: 7. JALANKAN CONTAINER (DATA LAMA AKAN DIMUAT ULANG)
echo [7/10] Menjalankan Database...
"%DOCKER_EXE%" compose up -d

:: 8. HEALTH CHECK
echo [8/10] Menunggu Database siap menerima koneksi...
:wait_sql_ready
timeout /t 5 >nul
"%DOCKER_EXE%" exec -i sql-express-workshop /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Workshop_Password_2026! -Q "SELECT 1" >nul 2>&1
if !errorlevel! neq 0 goto :wait_sql_ready
echo     Database SIAP!

:: 9. BUAT USER 'dec' (HANYA JIKA BELUM ADA)
echo [9/10] Mengecek user akses 'dec'...
"%DOCKER_EXE%" exec -i sql-express-workshop /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Workshop_Password_2026! -Q "IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'dec') BEGIN CREATE LOGIN dec WITH PASSWORD = 'Siapbisa@2026', CHECK_POLICY = OFF; ALTER SERVER ROLE sysadmin ADD MEMBER dec; END"

:: 10. SELESAI
echo.
echo  ===================================================
echo              SETUP BERHASIL (100%%)
echo  ===================================================
echo.
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
