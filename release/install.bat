@echo off
setlocal enabledelayedexpansion

echo 1.Create WorkShop Config
set workshop_dir=%cd%
:xml
(
echo Define workshop "%workshop_dir%"
echo Include conf^/workshop.conf
)>conf/httpd.conf
echo.

echo 2.Create System Service
bin\httpd.exe -k install -n workshop
bin\httpd.exe -k start -n workshop
echo.

echo 3.Set System Environment Variables
setx WorkShop %workshop_dir% /M
setx PATH %%WorkShop%%\bin;%PATH% /M
echo.