#!/usr/bin/env bash
# Remove any previously installed files.
if [ -f /var/www/web/sites/default/setttings.local.php ]; then
  rm /var/www/web/sites/default/setttings.local.php
fi

if [ -f /usr/local/etc/php/conf.d/development.ini ]; then
  rm /usr/local/etc/php/conf.d/development.ini
fi

if [ -f /usr/local/etc/php/conf.d/xdebug-remote.ini ]; then
  rm /usr/local/etc/php/conf.d/xdebug-remote.ini
fi

# If development mode is on, install the corresponding configuration files.
if [ "$DEVELOPMENT" = "yes" ]; then
  cp /development.ini /usr/local/etc/php/conf.d/development.ini
  cp /settings.development.php /var/www/web/sites/default/settings.local.php

  if [ -z "$XDEBUG_REMOTE_HOST" ]; then
    echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug-remote.ini
  else
    echo "xdebug.remote_host=$XDEBUG_REMOTE_HOST" >> /usr/local/etc/php/conf.d/xdebug-remote.ini
  fi
fi

# Wait until the database is available, or abort after 30 seconds.
tries=0
while ! mysql -u $MYSQL_USER -h database -p$MYSQL_PASSWORD  -e ";" ; do
  echo "Could not connect to database using $MYSQL_USER $MYSQL_PASSWORD. Retrying."
  if [ "$tries" == "10" ]; then
    echo "Tried 10 times, aborting."
    exit 1
  fi
  sleep 3
  tries=$[$tries + 1]
done

# Check if the database is empty.
tables=$(mysql -N -B -u $MYSQL_USER -h database -p$MYSQL_PASSWORD  -D drupal -e "SHOW TABLES;")
if [[ $tables ]]; then
  echo "Drupal is already installed."

  if [ ! -f /var/www/web/sites/default/settings.php ]; then
    cp /settings.php /var/www/web/sites/default/settings.php
  fi

else
  if [ -f /import/drupal.sql ]; then
    # If there is a drupal.sql import it, instead of running a full install.
    if [ ! -f /var/www/web/sites/default/settings.php ]; then
      cp /settings.php /var/www/web/sites/default/settings.php
    fi

    drush sqlc < /import/drupal.sql

    # Import public files directory.
    if [ -d /import/public ]; then
      cp -af /import/public/* /var/www/web/sites/default/files
    fi

    # Import private files directory.
    if [ -d /import/private ]; then
      cp -af /import/private/* /private
    fi
  else
    # No database dump available, install everything from scratch.
    drush si --account-name=$DRUPAL_ADMIN_USER --account-pass=$DRUPAL_ADMIN_PASS --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@database/drupal $DRUPAL_INSTALL_PROFILE -y $DRUPAL_INSTALL_PARAMS

    # Remove the generated settings PHP to replace it with our own one.
    if [ -f /var/www/web/sites/default/settings.php ]; then
      rm /var/www/web/sites/default/settings.php
    fi
    cp /settings.php /var/www/web/sites/default/settings.php
  fi
fi


apache2-foreground
