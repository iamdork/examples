# Fancy Drupal setup

A more sophisticated example of how to run Drupal with `dork-compose`. It assumes that projects are based on the [drupal composer template](https://github.com/drupal-composer/drupal-project) and will do a full setup during `dork-compose up`. Various settings are handled with [environment variables](.env), which can be overridden per project or instance.

This setup also provides some additional development features:

1. **phpMyAdmin:** The database browser everybody loves to hate.
2. **maildev:** A [maildev](https://github.com/djfarrelly/MailDev) container will catch all emails sent out by PHP. For easier mail debugging and avoiding accidents with real customer data.
3. **auto-install:**  The main container will automatically import a database dump located in the `import` directory or run a fresh site install.
3. **drush:** Drush is pre-installed and always executs within the 

## How to start

Take one of your countless projects based on [drupal composer template](https://github.com/drupal-composer/drupal-project) (or start a new one), and place a .env file with the following contents in the root directory:

```
DORK_LIBRARY_PATH=/path/to/iamdork/examples
DORK_LIBRARY=drupal-fancy
```

`dork-compose up -d` should do the rest. Modules and themes in the respective `custom` directories are automatically hotlinked.
