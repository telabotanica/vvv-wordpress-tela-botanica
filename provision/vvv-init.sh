#!/usr/bin/env bash
# Provision WordPress Stable

# Make a database, if we don't already have one
echo -e "\nCreating database 'wordpress_tb' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wordpress_tb"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wordpress_tb.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

# Install and configure the latest stable version of WordPress
if [[ ! -d "${VVV_PATH_TO_SITE}/public_html" ]]; then

  echo "Downloading WordPress Stable, see http://wordpress.org/"
  cd ${VVV_PATH_TO_SITE}
  curl -L -O "https://wordpress.org/latest.tar.gz"
  noroot tar -xvf latest.tar.gz
  mv wordpress public_html
  rm latest.tar.gz
  cd ${VVV_PATH_TO_SITE}/public_html

  echo "Configuring WordPress Stable..."
  noroot wp core config --dbname=wordpress_tb --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
/* Écrase la valeur précédente */
\$table_prefix = ''; // on utilise un préfixe vide pour l'instant, mais ça changera car c'est plutôt pas standard

/* Voir https://codex.wordpress.org/Debugging_in_WordPress */
define( 'WP_DEBUG', false );
define('SAVEQUERIES', false);

/* Algolia Plugin config */
define( 'ALGOLIA_APPLICATION_ID', 'YOTVBFEBJC' );
define( 'ALGOLIA_SEARCH_API_KEY', '0f5505db53e8068dcf35481db4d0fe8c' );
define( 'ALGOLIA_ADMIN_API_KEY', '' ); // secret
define( 'ALGOLIA_PREFIX', '' ); // secret

// Empêche une page /projets/toto de rediriger vers une page /toto lorsque cette dernière existe
// Voir https://wpml.org/forums/topic/buddypress-pages-redirected-to-other-pages/
define('BPML_USE_VERBOSE_PAGE_RULES', true);

// Si HTTPS activé sur le serveur, décommenter ici pour forcer le HTTPS
// Voir : https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Site-specific-self-signed-SSL-certificates
// define('FORCE_SSL_ADMIN', true);
// \$_SERVER['HTTPS'] = 'on';

PHP

  echo "Installing WordPress Stable..."
  noroot wp core install --url=local.tela-botanica.dev --quiet --title="Local WordPress Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password"

else

  echo "Updating WordPress Stable..."
  cd ${VVV_PATH_TO_SITE}/public_html
  noroot wp core update

fi
