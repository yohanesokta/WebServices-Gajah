@echo off
setlocal enabledelayedexpansion

set PORT=%~1
set ROOTNGINX=%~2
set ROOTDIR=C:\gajahweb
set TEMPLATE=%ROOTDIR%\config\nginx.conf.template
set OUTPUT=%ROOTDIR%\nginx\conf\nginx.conf

unzip.exe -o config.zip -d %ROOTDIR%\config\
echo Membuat config dengan port %PORT% ...

(
for /f "usebackq delims=" %%A in ("%TEMPLATE%") do (
    set "line=%%A"
    set "line=!line:__PORT__=%PORT%!"
	set "line=!line:__ROOT__=%ROOTNGINX%!"
    echo !line!
)
) > "%OUTPUT%"

rmdir /s /q %ROOTDIR%\config
echo Selesai! nginx.conf digenerate pakai port %PORT%.
echo Selesai! nginx.conf digenerate pakai ROOT %ROOTNGINX%.
endlocal
