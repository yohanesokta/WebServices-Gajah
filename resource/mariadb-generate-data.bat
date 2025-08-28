@ECHO OFF
setlocal

set "OUTDIR=C:\gajahweb"
%OUTDIR%\mariadb\bin\mariadb-install-db.exe  --datadir=%OUTDIR%\mariadb\data
cls