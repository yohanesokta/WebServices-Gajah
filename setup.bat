@REM SETUP INI DI BUAT UNTUK CONFIGURASI AWAL APLIKASI
@REM BERTERIMAKASIH DULU DUNG KE [YOHANES OKTANIO]
@REM BTW CUMAN BISA DI WINDOWS AJA, KARENA BUTUH POWERSHELL

cd data\flutter_assets
cd resource
@echo off
setlocal
set "OUTDIR=C:\gajahweb"

mkdir %OUTDIR%
mkdir %OUTDIR%\htdocs
mkdir %OUTDIR%\var
powershell -command "Expand-Archive -Force 'config.zip' '%OUTDIR%\config\'"

@REM @REM echo "Download Nginx 1.28.0 [1 of 5]"
@REM @REM wget.exe https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/nginx-1.28.0.zip -O %OUTDIR%\nginx-1.28.zip
@REM @REM powershell -command "Expand-Archive -Force '%OUTDIR%\nginx-1.28.zip' '%OUTDIR%\tmp\'"
@REM @REM move "%OUTDIR%\tmp\nginx-1.28.0" "%OUTDIR%\nginx"
@REM @REM del "%OUTDIR%\nginx\conf\nginx.conf"
@REM @REM copy "%OUTDIR%\config\nginx.conf" "%OUTDIR%\nginx\conf\nginx.conf"

echo "Download PHP 8.4.11 [2 of 5]"
wget.exe https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/php-8.4.11-Win32-vs17-x64.zip -O %OUTDIR%\var\php-8.4.11.zip
powershell -command "Expand-Archive -Force '%OUTDIR%\var\php-8.4.11.zip' '%OUTDIR%\php\'"
copy "%OUTDIR%\config\php.ini" "%OUTDIR%\php\php.ini"

@REM echo "Download MariaDB (MYSQL Server) [3 of 5]"
@REM wget.exe https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/mariadb-12.0.2-winx64.zip -O %OUTDIR%\mariadb-12.zip
@REM powershell -command "Expand-Archive -Force '%OUTDIR%\mariadb-12.zip' '%OUTDIR%\tmp\'"
@REM move "%OUTDIR%\tmp\mariadb-12.0.2-winx64" "%OUTDIR%\mariadb"
@REM %OUTDIR%\mariadb\bin\mariadb-install-db.exe  --datadir=%OUTDIR%\mariadb\data

@REM echo "Download phpMyAdmin [4 of 5]"
@REM wget.exe https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/phpMyAdmin-5.2.2-all-languages.zip -O %OUTDIR%\phpMyAdmin.zip
@REM powershell -command "Expand-Archive -Force '%OUTDIR%\phpMyAdmin.zip' '%OUTDIR%\tmp\'"
@REM move "%OUTDIR%\tmp\phpMyAdmin-5.2.2-all-languages" "%OUTDIR%\htdocs\phpmyadmin"
@REM copy "%OUTDIR%\config\config.inc.php" "%OUTDIR%\htdocs\phpmyadmin\config.inc.php"
@REM copy "%OUTDIR%\config\index.php" "%OUTDIR%\htdocs\index.php"

@REM echo "Download Redis [5 of 5]"
@REM wget.exe https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/Redis-x64-5.0.14.1.zip -O %OUTDIR%\redis.zip
@REM powershell -command "Expand-Archive -Force '%OUTDIR%\redis.zip' '%OUTDIR%\redis\'"


echo "Clearing Download Files"
del /f /q %OUTDIR%\mariadb-12.zip
del /f /q %OUTDIR%\nginx-1.28.zip
del /f /q %OUTDIR%\php-8.4.11.zip
del /f /q %OUTDIR%\phpMyAdmin.zip
del /f /q %OUTDIR%\redis.zip
rmdir /s /q %OUTDIR%\tmp
rmdir /s /q %OUTDIR%\config

echo "mariadb-12" >> %OUTDIR%\install.log
echo "nginx-1.28" >> %OUTDIR%\install.log
echo "php-8.4.11" >> %OUTDIR%\install.log
echo "tporadowski/redis" >> %OUTDIR%\install.log

cls

@REM echo SETUP TELAH BERHASIL DI LAKUKAN!