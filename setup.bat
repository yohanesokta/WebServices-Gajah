@REM SETUP INI DI BUAT UNTUK CONFIGURASI AWAL APLIKASI
@REM BERTERIMAKASIH DULU DUNG KE AKU [YOHANES OKTANIO]

cd resource
@echo off
setlocal
set "OUTDIR=C:\gajahweb"

mkdir %OUTDIR%

echo "Download Nginx 1.28.0"
@REM wget.exe https://nginx.org/download/nginx-1.28.0.zip -O %OUTDIR%\nginx-1.28.zip
@REM powershell -command "Expand-Archive -Force '%OUTDIR%\nginx-1.28.zip' '%OUTDIR%\tmp\'"
@REM move "%OUTDIR%\tmp\nginx-1.28.0" "%OUTDIR%\nginx"
@REM del "%OUTDIR%\nginx\conf\nginx.conf"
@REM copy "nginx.conf" "%OUTDIR%\nginx\conf\nginx.conf"

echo "Download PHP 8.4.11"
@REM wget.exe https://windows.php.net/downloads/releases/php-8.4.11-Win32-vs17-x64.zip -O %OUTDIR%\php-8.4.11.zip
powershell -command "Expand-Archive -Force '%OUTDIR%\php-8.4.11.zip' '%OUTDIR%\php-8.4\'"
copy "php.ini" "%OUTDIR%\php-8.4\php.ini"

