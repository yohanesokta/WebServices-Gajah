@echo off
setlocal enabledelayedexpansion

set PORT=%~1
set ROOTDIR=C:\gajahweb
set TEMPLATE=%ROOTDIR%\config\mariadb.conf.template
set OUTPUT=%ROOTDIR%\mariadb\data\my.ini

unzip.exe -o config.zip -d %ROOTDIR%\config\
echo Membuat config dengan port %PORT% ...

(
for /f "usebackq delims=" %%A in ("%TEMPLATE%") do (
    set "line=%%A"
    set "line=!line:__PORT__=%PORT%!"
    echo !line!
)
) > "%OUTPUT%"

rmdir /s /q %ROOTDIR%\config

echo Selesai! nginx.conf digenerate pakai port %PORT%.
endlocal
