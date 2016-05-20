# We start from the official Drupal 8 image.
FROM drupal:8

# But we intend to hack core, so we use our own sourcecode.
# 
# The "source" directory will injected automatically.
# If you want something else than 'source', override the
# DORK_LIBRARY_SOURCE environment variable.
ADD source /var/www/html
