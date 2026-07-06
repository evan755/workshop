@echo off

set apache=https://www.apachelounge.com/download/VS18/binaries/httpd-2.4.68-260617-Win64-VS18.zip
set php=https://downloads.php.net/~windows/releases/php-8.4.23-Win32-vs17-x64.zip
set composer=https://getcomposer.org/download/2.10.2/composer.phar
set nodejs=https://nodejs.org/dist/v24.18.0/node-v24.18.0-win-x64.zip
set vc_redist=https://aka.ms/vc14/vc_redist.x64.exe

mkdir origin
curl -o origin/apache.zip %apache%
curl -o origin/php.zip  %php%
curl -o origin/composer.phar %composer%
curl -o origin/nodejs.zip %nodejs%
curl -L -o origin/vc_redist.x64.exe %vc_redist%

7z x origin/apache.zip -o./origin/apache -y
7z x origin/php.zip -o./origin/php -y
7z x origin/nodejs.zip -o./origin/nodejs -y

mkdir release\bin
mkdir release\conf
mkdir release\logs
mkdir release\modules
mkdir release\php_ext

copy origin\apache\Apache24\bin\* release\bin\
copy origin\apache\Apache24\modules\* release\modules\
copy origin\apache\Apache24\conf\mime.types release\conf\

copy origin\php\ext\* release\php_ext\
copy origin\php\php.exe release\bin
copy origin\php\php8apache2_4.dll release\bin
copy origin\php\php8ts.dll release\bin
copy origin\php\libsqlite3.dll release\bin
copy origin\php\libssh2.dll release\bin
copy origin\php\icu*.dll release\bin
copy origin\composer.phar release\bin
copy origin\vc_redist.x64.exe release

tree /f release