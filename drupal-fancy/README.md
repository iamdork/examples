# Fancy Drupal setup

A more sophisticated example of how to run Drupal with `dork-compose`. It assumes that projects are based on the [drupal composer template](https://github.com/drupal-composer/drupal-project) and will do a full setup during `dork-compose up`. Various settings are handled with [environment variables](.env), which can be overridden per project or instance.

This setup also provides some additional development features:

1. **DBGp Proxy:** A *dbgp* module is included that ensures a [dbgp proxy](https://www.jetbrains.com/help/idea/2016.1/dbgp-proxy.html) is running and connected to each instance. This also serves as an example of a plugin launching an auxiliary service. To active the plugin, add it to your `DORK_PLUGINS` list:
    ```
    lib:multi:git:filesystem:proxy:dbgp=/path/to/dork-examples/drupal-fancy/plugins/dbgp/plugin.py
    ```

2. **phpMyAdmin:** The database browser everybody loves to hate.
3. **maildev:** A [maildev](https://github.com/djfarrelly/MailDev) container will catch all emails sent out by PHP. For easier mail debugging and avoiding accidents with real customer data.

## How to start

Take one of your countless projects based on [drupal composer template](https://github.com/drupal-composer/drupal-project) (or start a new one), and place a .env file with the following contents in the root directory:

```
DORK_LIBRARY_PATH=/path/to/iamdork/examples
DORK_LIBRARY=drupal-fancy
```

`dork-compose up -d` should do the rest. Modules and themes in the respective `custom` directories are automatically hotlinked.