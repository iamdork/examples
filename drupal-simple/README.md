# Simple Drupal setup

An example how to run a simple Drupal site with `dork-compose`. *Should be used for quick tests and demonstration purposes only.*

Clone the examples repository.

```
$ git clone https://github.com/iamdork/examples.git ~/dork-recipes
```

Create a `sources` directory to store your project source code.

```
$ mkdir ~/sources
$ cd sources
```

Add an .env file to tell `dork-compose` where to find the docker setup.

```
$ echo "DORK_LIBRARY_PATH=~/dork-recipes" > .env
```

Download and extract the latest Drupal sources.

```
$ curl -fSL "http://ftp.drupal.org/files/projects/drupal-8.1.1.tar.gz" -o drupal.tar.gz
$ tar -xzf -f drupal.tar.gz && rm drupal.tar.gz
$ mv drupal-8.1.1 drupal
$ cd drupal
```

Add an .env file to tell Drupal to use the `drupal-simple` setup.

```
$ echo "DORK_LIBRARY=drupal-simple" > .env
```

Run `dork-compose info`, the output should look like this.

```
DORK_LIBRARY_PATH:  ~/dork-examples
DORK_LIBRARY:       drupal-simple
Library:            /root/dork-examples/drupal-simple
Project:            drupal
```

Now you are ready to fire up your Drupal site with `dork-compose up -d`. Your website should be available at http://drupal.127.0.0.1.xip.io. Create the `settings.php` by running these commands.

```
$ dork-compose exec web cp sites/default/default.settings.php sites/default/settings.php
$ dork-compose exec web chown www-data sites/default/settings.php
```

Run through the installation process by using the database settings from [docker-compose.yml](docker-compose.yml).

After completing the installation create a snapshot and verify its there.

```
$ dork-compose snapshot save installed
$ dork-compose snapshot ls
installed
```

Add some content to your site and make another snapshot.

```
$ dork-compose snapshot save content
$ dork-compose snapshot ls
installed
content
```

Now you are able to switch back to the fresh install by loading the `installed` snapshot.

```
$ dork-compose snapshot load installed
```

Or bring back your content by loading the `content` snapshot.

```
$ dork-compose snapshot load content
```

Congratulations, you just finished the basic example of `dork-compose`.
