@echo off
SET ROOTDIR=C:\gajahweb\postgres\bin

del /f /q %ROOTDIR%\data\postgresql.auto.conf
echo PORT=%1 >> %ROOTDIR%\data\postgresql.auto.conf