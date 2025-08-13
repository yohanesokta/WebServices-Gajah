@REM SETUP INI DI BUAT UNTUK CONFIGURASI AWAL APLIKASI
@REM BERTERIMAKASIH DULU DUNG KE [YOHANES OKTANIO]
@REM BTW CUMAN BISA DI WINDOWS AJA, KARENA BUTUH POWERSHELL

cd resource
@echo off
setlocal
set "OUTDIR=C:\gajahweb"

mkdir %OUTDIR%
mkdir %OUTDIR%\htdocs

powershell -command "Expand-Archive -Force 'config.zip' '%OUTDIR%\config\'"

echo "Download Nginx 1.28.0 [1 of 4]"
wget.exe https://nginx.org/download/nginx-1.28.0.zip -O %OUTDIR%\nginx-1.28.zip
powershell -command "Expand-Archive -Force '%OUTDIR%\nginx-1.28.zip' '%OUTDIR%\tmp\'"
move "%OUTDIR%\tmp\nginx-1.28.0" "%OUTDIR%\nginx"
del "%OUTDIR%\nginx\conf\nginx.conf"
copy "%OUTDIR%\config\nginx.conf" "%OUTDIR%\nginx\conf\nginx.conf"

echo "Download PHP 8.4.11 [2 of 4]"
wget.exe https://windows.php.net/downloads/releases/php-8.4.11-Win32-vs17-x64.zip -O %OUTDIR%\php-8.4.11.zip
powershell -command "Expand-Archive -Force '%OUTDIR%\php-8.4.11.zip' '%OUTDIR%\php-8.4\'"
copy "%OUTDIR%\config\php.ini" "%OUTDIR%\php-8.4\php.ini"

echo "Download MariaDB (MYSQL Server) [3 of 4]"
wget.exe https://mr.heru.id/mariadb///mariadb-12.0.2/winx64-packages/mariadb-12.0.2-winx64.zip -O %OUTDIR%\mariadb-12.zip
powershell -command "Expand-Archive -Force '%OUTDIR%\mariadb-12.zip' '%OUTDIR%\tmp\'"
move "%OUTDIR%\tmp\mariadb-12.0.2-winx64" "%OUTDIR%\mariadb"
%OUTDIR%\mariadb\bin\mariadb-install-db.exe  --datadir=%OUTDIR%\mariadb\data

echo "Download phpMyAdmin [4 of 4]"
wget.exe https://files.phpmyadmin.net/phpMyAdmin/5.2.2/phpMyAdmin-5.2.2-all-languages.zip -O %OUTDIR%\phpMyAdmin.zip
powershell -command "Expand-Archive -Force '%OUTDIR%\phpMyAdmin.zip' '%OUTDIR%\tmp\'"
move "%OUTDIR%\tmp\phpMyAdmin-5.2.2-all-languages" "%OUTDIR%\htdocs\phpmyadmin"
copy "%OUTDIR%\config\config.inc.php" "%OUTDIR%\htdocs\phpmyadmin\config.inc.php"
copy "%OUTDIR%\config\index.php" "%OUTDIR%\htdocs\index.php"

echo "Clearing Download Files"
del /f /q %OUTDIR%\mariadb-12.zip
del /f /q %OUTDIR%\nginx-1.28.zip
del /f /q %OUTDIR%\php-8.4.11.zip
del /f /q %OUTDIR%\phpMyAdmin.zip
rmdir /s /q %OUTDIR%\tmp
rmdir /s /q %OUTDIR%\config
cls
echo SETUP TELAH BERHASIL DI LAKUKAN!
