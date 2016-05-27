FROM drupal:8-fpm

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*
RUN pecl install xdebug
COPY xdebug.ini /xdebug.ini

COPY source /var/www
RUN rm -rf /var/www/html && ln -s /var/www/web /var/www/html
ADD settings.php /var/www/web/sites/default/settings.php
ADD init.sh /init.sh
RUN chmod +x /init.sh
CMD /init.sh

