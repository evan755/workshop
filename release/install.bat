@echo off

echo 1.Create WorkShop Config
set aplite=%cd%
:xml
(
echo Define workshop "%aplite%"
echo Include conf^/workshop.conf
)>conf/httpd.conf
echo.

echo 2.Create System Service
bin\httpd.exe -k install -n workshop
bin\httpd.exe -k start -n workshop

echo.