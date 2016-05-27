#!/usr/bin/env sh
if [ "$DEVELOPMENT" = "yes" ]; then
  ln -s /xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
  rm /usr/local/etc/php/conf.d/xdebug-remote.ini
  if [ -z "$XDEBUG_REMOTE_HOST" ]; then
    echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug-remote.ini
  else
    echo "xdebug.remote_host=$XDEBUG_REMOTE_HOST" >> /usr/local/etc/php/conf.d/xdebug-remote.ini
  fi
fi
php-fpm
