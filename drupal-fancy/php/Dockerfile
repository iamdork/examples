FROM drupal:8

# Install basic cli tools and required packages.
RUN apt-get update \
  && apt-get install -y ssmtp git curl mysql-client rsync vim \
  && rm -rf /var/lib/apt/lists/* \
  && pecl install xdebug \
  && docker-php-ext-install bcmath \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
  && composer global require drush/drush && ln -s /root/.composer/vendor/bin/drush /usr/bin/drush

# Install the init shellscript.
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Ensure the drush directory exists.
RUN mkdir -p /root/.drush

# Copy configuration files.
COPY sendmail.ini /usr/local/etc/php/conf.d/sendmail.ini
COPY drushrc.php /root/.drush/drushrc.php

# Prepare configuration files that are linked on startup depnending on the
# DEVELOPMENT environment variable.
COPY development.ini /development.ini
COPY settings.php /settings.php
COPY settings.development.php /settings.development.php
COPY services.yml /services.yml
COPY services.development.yml /services.development.yml

# Copy composer.json and composer.lock
COPY source/scripts/composer /tmp/composer/scripts/composer
COPY source/web/sites/default /tmp/composer/web/sites/default
COPY source/composer.json /tmp/composer/composer.json
COPY source/composer.lock /tmp/composer/composer.lock

ARG SSH_PRIVATE_KEY=""
ARG ACCEPT_HOSTS="github.com bitbucket.org"
ARG GITHUB_PRIVATE_TOKEN=""

# Install composer dependencies.
COPY composer-install.sh /composer-install.sh
RUN bash /composer-install.sh

# Copy the available sources. /source directory is prepared by dork-compose.
COPY source /var/www

ARG DRUPAL_DOCROOT=/web
# Drupal composer template stores accessible files in /web. Link it to
# avoid changing the apache configuration.
RUN rm -rf /var/www/html && ln -s /var/www$DRUPAL_DOCROOT /var/www/html

# Set the workdir to the drupal docroot.
WORKDIR /var/www$DRUPAL_DOCROOT

# Install drupal if necessary, start apache process.
CMD ["/init.sh"]
