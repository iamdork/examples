#!/usr/bin/env bash
set -e

# Add SSH key and github token to enable private dependencies.
mkdir -p /root/.ssh

# Keyscan hosts we plan to access.
if [ -n "$ACCEPT_HOSTS" ]; then
  ssh-keyscan $ACCEPT_HOSTS >> /root/.ssh/known_hosts
  cat /root/.ssh/known_hosts
fi

if [ -n "$GITHUB_PRIVATE_TOKEN" ]; then
  composer config -g github-oauth.github.com $GITHUB_PRIVATE_TOKEN;
fi

if [ -n "$SSH_PRIVATE_KEY" ]; then
  printenv SSH_PRIVATE_KEY >> /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
fi

# Run composer install in temp directory to enable caching with docker.
cd /tmp/composer || exit
composer install --dev

# Remove the private key and token to leave no traces in the image.
if [ -n "$GITHUB_PRIVATE_TOKEN" ]; then
  composer config -g github-oauth.github.com deleted
fi

if [ -n "$SSH_PRIVATE_KEY" ]; then
  rm /root/.ssh/id_rsa
fi

# Copy dependencies into place.
rsync -qrtvu --delete /tmp/composer/ /var/www/
