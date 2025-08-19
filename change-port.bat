@echo off
REM === Input Port dari argumen ===
if "%~1"=="" (
    echo Usage: set-port.bat [port]
    exit /b
)

set PORT=%~1

REM === Generate nginx.conf dari template ===
set TEMPLATE=nginx.conf.template
set OUTPUT=nginx.conf

echo Membuat config dengan port %PORT% ...

(for /f "usebackq delims=" %%A in ("%TEMPLATE%") do (
    set "line=%%A"
    call set "line=%%line:__PORT__=%PORT%%%"
    echo %line%
)) > %OUTPUT%

echo Selesai! nginx.conf digenerate pakai port %PORT%.

REM === Reload nginx (jika sudah jalan) ===
nginx -s reload
