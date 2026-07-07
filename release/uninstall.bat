@echo off

bin\httpd.exe -k stop -n workshop
bin\httpd.exe -k uninstall -n workshop

del /f conf\httpd.conf
del /f logs\*.log

echo.