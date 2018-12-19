# VVV WordPress Tela Botanica

Tela Botanica WordPress development environment based on [VVV](https://github.com/Varying-Vagrant-Vagrants/VVV).

## Objectives

* Approachable development environment with a modern server configuration.
* Stable state of software and configuration in default provisioning.

## How to Use VVV WordPress Tela Botanica

Requires recent versions of both Vagrant and VirtualBox.

[Vagrant](https://www.vagrantup.com) is a "tool for building and distributing development environments". It works with [virtualization](https://en.wikipedia.org/wiki/X86_virtualization) software such as [VirtualBox](https://www.virtualbox.org/) to provide a virtual machine sandboxed from your local environment.

### Install dev env
1. Clone a fresh [VVV](https://github.com/Varying-Vagrant-Vagrants/VVV) in a SOME-DEV-FOLDER folder
1. Create a `vvv-custom.yml` (see example below)
1. Install required plugins `vagrant plugin install vagrant-hostsupdater vagrant-vbguest`
1. Run `vagrant up` and go get a hot drink

### Loads some data
1. Get in `vagrant ssh`
1. Go to Wordpress dir `cd /srv/www/tela-botanica/public_html`
1. Create a `movefile.yml` (see example below)
1. Run `wordmove pull -e preprod --all [--no-uploads] [--simulate]` (`--no-uploads` saves some time and disk, and `--simulate` do dry-run to check config)
1. Done! Browse [local.tela-botanica.test](https://local.tela-botanica.test)

### One more thing/fix
1. Fix wrong services url and cookie name in [wp-admin](http://local.tela-botanica.test/wp-admin). (SSO, Tela Botanica, Applis externes)

### Break some code
1. `subl ~/SOME-DEV-FOLDER/www/tela-botanica/public_html/wp-content/plugins/tela-botanica`
1. `subl ~/SOME-DEV-FOLDER/www/tela-botanica/public_html/wp-content/themes/tela-botanica`
1. And so on

### Upgrade VVV
1. Something like `git pull; vagrant reload --provision` should suffice
1. If not, gently perform `vagrant reload --provision` for each missed release tag
1. Just in case, keep an eye on [the upgrade doc](https://varyingvagrantvagrants.org/docs/en-US/installation/keeping-up-to-date/)

## Examples
You can use these examples as is. Just replace `PASSWORD-PLACEHOLDER` by proper passwords.

### vvv-custom.yml
```yml
sites:
  tela-botanica:
    repo: https://github.com/telabotanica/vvv-wordpress-tela-botanica.git
    hosts:
      - local.tela-botanica.test
      - api.tela-botanica.test

utilities:
  core:
    - memcached-admin
    - opcache-status
    - phpmyadmin
    - webgrind
    - trusted-hosts
    - tls-ca
  tb:
    - tb-framework
    - tb-framework-0.2
    - annuaire
    - cumulus
    - cumulus-front
    - bower
    - ezmlm-php
    - ezmlm-forum
    - chorologie
    - eflore-consultation
    - sshpass
    - wordmove
    - trusted-hosts
    - php-extensions

utility-sources:
  tb: https://github.com/telabotanica/vvv-utilities-tela-botanica

vm_config:
  memory: 2048
  cores: 2

```

### movefile.yml
```yml
global:
  sql_adapter: "wpcli"

local:
  vhost: "https://local.tela-botanica.test"
  wordpress_path: "/srv/www/tela-botanica/public_html" # use an absolute path here

  database:
    name: "wordpress_tb"
    user: "wp"
    password: "wp"
    host: "localhost"

default: &default
  vhost: "https://beta.tela-botanica.org"
  wordpress_path: "/home/beta/www"

  database: &db
    name: "wordpress"
    user: "wordpress"
    password: "PASSWORD-PLACEHOLDER"
    host: "localhost"

  ssh: &ssh
    host: "prive.aphyllanthe.tela-botanica.net"
    user: "beta"
    password: "PASSWORD-PLACEHOLDER"
    port: 22
    rsync_options: "--verbose" # Additional rsync options, optional

  exclude: &exclude
    - ".git/"
    - ".htaccess"
    #- ".gitignore"
    - ".sass-cache/"
    - "node_modules/"
    - "bin/"
    - "tmp/*"
    - "Gemfile*"
    - "movefile.yml"
    - "wp-config.php"
    - "wp-content/*.sql.gz"
    - ".ruby-version"
    - "IMG/"

  forbid: &forbid
    push:
      uploads: true
      themes: true
      plugins: true
      mu-plugins: true
      languages: true
      db: true

preprod:
  <<: *default
  vhost: "https://beta.tela-botanica.org/preprod"
  wordpress_path: "/home/beta/www/preprod"

  database:
    *db

  ssh:
    *ssh

  exclude:
    *exclude

  hooks:
    pull:
      after:
        local:
          - 'echo "START: Replace imported tools symlink with proper local target"'
          - 'unlink /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/forum'
          - 'unlink /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/porte-documents'
          - 'ln -s /srv/www/cumulus-front/app/ /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/porte-documents'
          - 'ln -s /srv/www/ezmlm-forum/ /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/forum'
          - 'echo "START: Replace some config in Wordpress database"'
          - 'wp search-replace "vpopmail.tela-botanica.org\/ezmlm-php-ng" "api.tela-botanica.test\/ezmlm-php" table "options" --no-report'
          - 'wp search-replace "beta.tela-botanica.org\/service:" "api.tela-botanica.test\/service:" table "options" --no-report'
          - 'wp search-replace "beta.tela-botanica.org" "local.tela-botanica.test" table "options" --no-report'
          - 'wp search-replace "api.tela-botanica.org" "api.tela-botanica.test" table "options" --no-report'
          - 'wp search-replace "tb_auth_beta_preprod" "tb_auth_local_dev" table "options" --no-report'

  forbid:
    *forbid

test:
  <<: *default
  vhost: "https://beta.tela-botanica.org/test"
  wordpress_path: "/home/beta/www/test"

  database:
    <<: *db
    name: "wordpress_test"

  ssh:
    *ssh

  exclude:
    *exclude

  hooks:
    pull:
      after:
        local:
          - 'echo "START: Replace imported tools symlink with proper local target"'
          - 'unlink /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/forum'
          - 'unlink /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/porte-documents'
          - 'ln -s /srv/www/cumulus-front/app/ /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/porte-documents'
          - 'ln -s /srv/www/ezmlm-forum/ /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/forum'
          - 'echo "START: Replace some config in Wordpress database"'
          - 'wp search-replace "vpopmail.tela-botanica.org\/ezmlm-php-ng" "api.tela-botanica.test\/ezmlm-php" table "options" --no-report'
          - 'wp search-replace "beta.tela-botanica.org\/service:annuaire" "api.tela-botanica.test\/service:annuaire" table "options" --no-report'
          - 'wp search-replace "beta.tela-botanica.org\/service:" "api.tela-botanica.test\/service:" table "options" --no-report'
          - 'wp search-replace "beta.tela-botanica.org" "local.tela-botanica.test" table "options" --no-report'
          - 'wp search-replace "api.tela-botanica.org" "api.tela-botanica.test" table "options" --no-report'
          - 'wp search-replace "tb_auth_beta_preprod" "tb_auth_local_dev" table "options" --no-report'

  forbid:
    *forbid
```

## Known issues
### Mailcatcher
#### CRLF thing

Error: `SMTP To address may not contain CR or LF line breaks`

Workaround:
```
/usr/bin/env rvm default@mailcatcher --create do gem uninstall mail
/usr/bin/env rvm default@mailcatcher --create do gem install mail --version 2.6.6
```

#### EOF thing

Error: `/usr/local/rvm/gems/ruby-2.4.1@mailcatcher/bin/ruby_executable_hooks: end of file reached (EOFError)`

Workaround:

Add `/usr/bin/env` to sendmail path
```
#/etc/php/7.0/mods-available/mailcatcher.ini
sendmail_path = "/usr/bin/env /usr/local/rvm/bin/catchmail -f admin@local.dev"
```

Don't forget to `service php7.0-fpm reload`
