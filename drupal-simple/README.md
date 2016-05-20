# Simple Drupal setup

An example how to run a simple Drupal site with `dork-compose`. *Should be used for quick tests and demonstration purposes only.*

Clone the examples repository.

```
git clone https://github.com/iamdork/examples.git ~/dork-examples
```

Create a `sources` directory to store your project source code.

```
mkdir ~/sources
cd sources
```

Add an .env file to tell `dork-compose` where to find the docker setup.

```
echo "DORK_LIBRARY_PATH=~/dork-examples" > .env
```

Download and extract the latest Drupal sources.

```
curl -fSL "http://ftp.drupal.org/files/projects/drupal-8.1.1.tar.gz" -o drupal.tar.gz
tar -xzf -f drupal.tar.gz && rm drupal.tar.gz
mv drupal-8.1.1 drupal
cd drupal
```

Add an .env file to tell Drupal to use the `drupal-simple` setup.

```
echo "DORK_LIBRARY=drupal-simple" > .env
```

Run `dork-compose info`, the output should look like this.

```
DORK_LIBRARY_PATH:  ~/dork-examples
DORK_LIBRARY:       drupal-simple
Library:            /root/dork-examples/drupal-simple
Project:            drupal
```

Now you are ready to fire up your Drupal site with `dork-compose up`.






