#!/usr/bin/env bash
set -e

# Remove any previously installed files.
if [ -f /var/www$DRUPAL_DOCROOT/sites/default/settings.local.php ]; then
  rm /var/www$DRUPAL_DOCROOT/sites/default/settings.local.php
fi

if [ -f /usr/local/etc/php/conf.d/development.ini ]; then
  rm /usr/local/etc/php/conf.d/development.ini
fi

if [ -f /usr/local/etc/php/conf.d/xdebug-remote.ini ]; then
  rm /usr/local/etc/php/conf.d/xdebug-remote.ini
fi

# Wait until the database is available, or abort after 30 seconds.
tries=0
while ! mysql -u $MYSQL_USER -h database -p$MYSQL_PASSWORD  -e ";" ; do
  echo "Could not connect to database using $MYSQL_USER $MYSQL_PASSWORD. Retrying."
  if [ "$tries" == "30" ]; then
    echo "Tried 30 times, aborting."
    exit 1
  fi
  sleep 3
  tries=$[$tries + 1]
done

# Check if the database is empty.
tables=$(mysql -N -B -u $MYSQL_USER -h database -p$MYSQL_PASSWORD  -D drupal -e "SHOW TABLES;")
if [[ $tables ]]; then
  echo "Drupal is already installed."
  cp /settings.php /var/www$DRUPAL_DOCROOT/sites/default/settings.php
else
  if [ -f /import/drupal.sql ]; then
    echo "Database dump available. Running import."
    # If there is a drupal.sql import it, instead of running a full install.
    cp /settings.php /var/www$DRUPAL_DOCROOT/sites/default/settings.php
    mysql -u $MYSQL_USER -h database -p$MYSQL_PASSWORD drupal < /import/drupal.sql
    echo "Database import complete."

    # Import public files directory.
    if [ -d /import/public ]; then
      echo "Importing public files directory."
      cp -af /import/public/* /var/www$DRUPAL_DOCROOT/sites/default/files
    fi

    # Import private files directory.
    if [ -d /import/private ]; then
      echo "Importing private files directory."
      cp -af /import/private/* /private
    fi
  else
    # No database dump available, install everything from scratch.
    if [[ $DRUPAL_USE_CONFIG_INSTALLER == 'yes' ]]; then
      # config_installer profile is in use. Override install parameters to
      # sync with the current config directory.
      echo "Installing from existing configuration. This could take a while."
      DRUPAL_INSTALL_PARAMS="config_installer_sync_configure_form.sync_directory=$DRUPAL_CONFIG_DIR"
      DRUPAL_INSTALL_PROFILE="config_installer"
    fi

    # Run installation with provided environment variables.
    drush si -y --account-name=$DRUPAL_ADMIN_USER --account-pass=$DRUPAL_ADMIN_PASS --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@database/drupal $DRUPAL_INSTALL_PROFILE $DRUPAL_INSTALL_PARAMS

    # Remove the generated settings PHP to replace it with our own one.
    cp /settings.php /var/www$DRUPAL_DOCROOT/sites/default/settings.php
  fi
fi

# Refresh contrib dependencies exposed to the IDE.
for path in drush/contrib docroot/modules/contrib docroot/profiles/contrib docroot/themes/contrib docroot/libraries/contrib; do
  if [ -d /var/www/$path ]; then
    rsync -qrtvu --delete /var/www/$path /dependencies/$path
  fi
done

# If development mode is on, install the corresponding configuration files.
if [ $DEVELOPMENT = "yes" ]; then
  cp /development.ini /usr/local/etc/php/conf.d/development.ini
  cp /settings.development.php /var/www$DRUPAL_DOCROOT/sites/default/settings.local.php
  cp /services.development.yml /var/www$DRUPAL_DOCROOT/sites/default/services.yml

  if [ -z "$XDEBUG_REMOTE_HOST" ]; then
    echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug-remote.ini
  else
    echo "xdebug.remote_host=$XDEBUG_REMOTE_HOST" >> /usr/local/etc/php/conf.d/xdebug-remote.ini
  fi
else
  cp /services.yml /var/www$DRUPAL_DOCROOT/sites/default/services.yml
fi

apache2-foreground
