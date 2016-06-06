FROM drupal:8

RUN apt-get update && apt-get install -y git curl mysql-client && rm -rf /var/lib/apt/lists/*
RUN pecl install xdebug


# Install composer and drush
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer global require drush/drush && ln -s /root/.composer/vendor/bin/drush /usr/bin/drush \
    && mkdir /root/.drush

# Install the init shellscript.
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Copy configuration files.
COPY drushrc.php /root/.drush/drushrc.php
COPY development.ini /development.ini
COPY settings.php /settings.php
COPY settings.development.php /settings.development.php

# Copy the available sources. /source directory is prepared by dork-compose.
COPY source /var/www

# Drupal composer template stores accessible files in /web. Link it to
# avoid changing the apache configuration.
RUN rm -rf /var/www/html && ln -s /var/www/web /var/www/html

# Install composer dependencies.
WORKDIR /var/www
RUN composer install

# Install drupal if necessary, start apache process.
CMD /init.sh

