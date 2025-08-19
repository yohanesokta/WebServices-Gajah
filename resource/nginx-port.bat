@echo off
setlocal enabledelayedexpansion

set PORT=%~1
set ROOTDIR=C:\gajahweb
set TEMPLATE=%ROOTDIR%\config\nginx.conf.template
set OUTPUT=%ROOTDIR%\nginx\conf\nginx.conf

powershell -command "Expand-Archive -Force 'config.zip' '%ROOTDIR%\config\'"
echo Membuat config dengan port %PORT% ...

(
for /f "usebackq delims=" %%A in ("%TEMPLATE%") do (
    set "line=%%A"
    set "line=!line:__PORT__=%PORT%!"
    echo !line!
)
) > "%OUTPUT%"

echo Selesai! nginx.conf digenerate pakai port %PORT%.
endlocal
