@REM php-change-v.bat php-8.1.zip https://contoh.com/php-8.1.zip (legacy/universal/default)

echo off
cls

cd data\flutter_assets
cd resource

set "outdir=C:\gajahweb"
set "filePath=%outdir%\var"

if exist "%filePath%\%1.zip" (
    echo fileFound : %filePath%\%1.zip
    goto replace
) else (
    wget.exe %2 -O %filePath%\%1.source
    move %filePath%\%1.source %filePath%\%1.zip
)

:replace
rmdir /s /q %outdir%\php
taskkill /F /IM php-cgi.exe
powershell -command "Expand-Archive -Force '%filePath%\%1.zip' '%outdir%\php\'"
powershell -command "Expand-Archive -Force 'config.zip' '%outdir%\config\'"
goto %3


:legacy
echo Copy Legacy Config!
copy %outdir%\config\php.ini-legacy %outdir%\php\php.ini
goto nginxstop

:universal
echo Copy Universal Config!
copy %outdir%\config\php.ini-universal %outdir%\php\php.ini
mkdir %outdir%\php\sessions
goto nginxstop

:nginxstop
cd %outdir%\nginx\
nginx.exe -s stop
taskkill /F /IM httpd.exe
taskkill /F /IM nginx.exe
taskkill /F /IM php-cgi.exe

:caching
mkdir %outdir%\php\tmp
rmdir /s /q %outdir%\config
echo %1 >> %outdir%\install.log