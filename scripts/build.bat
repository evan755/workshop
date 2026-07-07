@echo off

set apache=https://www.apachelounge.com/download/VS18/binaries/httpd-2.4.68-260617-Win64-VS18.zip
set php=https://downloads.php.net/~windows/releases/php-8.4.23-Win32-vs17-x64.zip
set composer=https://getcomposer.org/download/2.10.2/composer.phar
set vc_redist=https://aka.ms/vc14/vc_redist.x64.exe
set php_mongodb=https://downloads.php.net/~windows/pecl/releases/mongodb/2.3.3/php_mongodb-2.3.3-8.4-ts-vs17-x64.zip

mkdir origin
curl -L -o origin/vc_redist.x64.exe %vc_redist%
curl -o origin/apache.zip %apache%
curl -o origin/php.zip  %php%
curl -o origin/composer.phar %composer%
curl -o origin/php_mongodb.zip %php_mongodb%

7z x origin/apache.zip -o./origin/apache -y
7z x origin/php.zip -o./origin/php -y
7z x origin/php_mongodb.zip -o./origin/php_mongodb -y

mkdir release\bin
mkdir release\conf
mkdir release\logs
mkdir release\modules
mkdir release\php_ext

copy origin\apache\Apache24\bin\* release\bin\
copy origin\apache\Apache24\modules\* release\modules\
copy origin\apache\Apache24\conf\mime.types release\conf\

copy origin\php\ext\* release\php_ext\
copy origin\php_mongodb\php_mongodb.dll release\php_ext\
copy origin\php\php.exe release\bin
copy origin\php\php8apache2_4.dll release\bin
copy origin\php\php8ts.dll release\bin
copy origin\php\libsqlite3.dll release\bin
copy origin\php\libssh2.dll release\bin
copy origin\php\pharcommand.phar release\bin
copy origin\php\phar.phar.bat release\bin
copy origin\php\icu*.dll release\bin
copy origin\composer.phar release\bin
copy origin\vc_redist.x64.exe release


:xml
(
echo "%%~dp0php.exe" "%%~dp0composer.phar" %%*
) > release\bin\composer.bat

:xml
(
echo ServerRoot "${workshop}"
echo.
echo LoadModule authz_core_module modules/mod_authz_core.so
echo LoadModule log_config_module modules/mod_log_config.so
echo LoadModule rewrite_module modules/mod_rewrite.so
echo LoadModule autoindex_module modules/mod_autoindex.so
echo LoadModule dir_module modules/mod_dir.so
echo LoadModule mime_module modules/mod_mime.so
echo LoadModule php_module bin/php8apache2_4.dll
echo.
echo AddHandler application/x-httpd-php .php
echo PHPIniDir "${workshop}/conf"
echo.
echo Listen 80
echo ServerName localhost
echo ServerAdmin workshop@localhost
echo.
echo ServerTokens Prod
echo ServerSignature Off
echo.
echo ErrorLog "${workshop}/logs/error.log"
echo LogLevel emerg
echo.
echo ^<IfModule log_config_module^>
echo     LogFormat "%%h %%l %%u %%t \"%%r\" %%>s %%b \"%%{Referer}i\" \"%%{User-Agent}i\"" combined
echo     LogFormat "%%h %%l %%u %%t \"%%r\" %%>s %%b" common
echo     ^<IfModule logio_module^>
echo       LogFormat "%%h %%l %%u %%t \"%%r\" %%>s %%b \"%%{Referer}i\" \"%%{User-Agent}i\" %%I %%O" combinedio
echo     ^</IfModule^>
echo     CustomLog "logs/access.log" common
echo ^</IfModule^>
echo.
echo ^<VirtualHost 0.0.0.0:80^>
echo     DocumentRoot "${workshop}/htdocs"
echo     DirectoryIndex index.html index.php
echo     ^<Directory "${workshop}/htdocs"^>
echo         Options Indexes FollowSymLinks MultiViews
echo         AllowOverride All
echo     ^</Directory^>
echo     ErrorLog "${workshop}/logs/workshop-error.log"
echo     CustomLog "${workshop}/logs/workshop-access.log" common
echo ^</VirtualHost^>
) > release\conf\workshop.conf

:xml
(
echo [php]
echo expose_php = Off
echo.
echo extension_dir="..\\php_ext"
echo.
echo extension=bz2
echo extension=com_dotnet
echo extension=curl
echo extension=fileinfo
echo extension=gd
echo extension=openssl
echo extension=intl
echo extension=zip
echo extension=mbstring
echo extension=mysqli
echo extension=pdo_mysql
echo extension=sqlite3
echo extension=pdo_sqlite
echo extension=mongodb
echo.
echo zend_extension=opcache
echo.
echo [opcache]
echo ;opcache.enable=1
echo ;opcache.enable_cli=0
echo ;opcache.memory_consumption=128
echo ;opcache.interned_strings_buffer=8
echo ;opcache.max_accelerated_files=10000
echo ;opcache.max_wasted_percentage=5
echo ;opcache.use_cwd=1
echo ;opcache.validate_timestamps=1
echo ;opcache.revalidate_freq=2
echo ;opcache.revalidate_path=0
echo ;opcache.save_comments=1
echo ;opcache.record_warnings=0
echo ;opcache.enable_file_override=0
echo ;opcache.optimization_level=0x7FFFBFFF
echo ;opcache.dups_fix=0
echo ;opcache.blacklist_filename=
echo ;opcache.max_file_size=0
echo ;opcache.force_restart_timeout=180
echo ;opcache.error_log=
echo ;opcache.log_verbosity_level=1
echo ;opcache.preferred_memory_model=
echo ;opcache.protect_memory=0
echo ;opcache.restrict_api=
echo ;opcache.mmap_base=
echo ;opcache.cache_id=
echo ;opcache.file_cache=
echo ;opcache.file_cache_only=0
echo ;opcache.file_cache_consistency_checks=1
echo ;opcache.file_cache_fallback=1
echo ;opcache.huge_code_pages=0
echo ;opcache.validate_permission=0
echo ;opcache.validate_root=0
echo ;opcache.opt_debug_level=0
echo ;opcache.preload=
echo ;opcache.preload_user=
echo ;opcache.file_update_protection=2
echo ;opcache.lockfile_path=/tmp
echo.
echo [openssl]
echo ;openssl.cafile=
echo ;openssl.capath=
echo.
echo [curl]
echo ;curl.cainfo=
echo.
) > release\conf\php-apache2handler.ini
