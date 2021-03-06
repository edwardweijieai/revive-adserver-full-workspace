#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ ! -d /var/www/html ] ; then
  mkdir -p /var/www/html
  chown :www-data /var/www/html
fi

# create all mysql neccessary database
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  mysql_install_db
fi

# start php-fpm
mkdir -p /data/logs/php-fpm
php-fpm7 &

# start mysql
mysqld --skip-grant-tables &

# start nginx
mkdir -p /data/logs/nginx
mkdir -p /data/logs/php-fpm
mkdir -p /tmp/nginx
chown nginx /tmp/nginx
nginx &
bash