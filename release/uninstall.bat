@echo off

echo 1. Stopping and removing service...
bin\httpd.exe -k stop -n workshop 2>nul
bin\httpd.exe -k uninstall -n workshop 2>nul
echo.

echo 2. Removing configuration files...
del /f conf\httpd.conf 2>nul
del /f logs\*.log 2>nul
echo.

echo 3. Removing environment variables...
wmic ENVIRONMENT where "name='WorkShop'" delete
echo.