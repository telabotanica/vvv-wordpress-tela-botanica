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
1. Run `vagrant up` and go get a hot drink

### Loads some data
1. Install required plugins `vagrant plugin install vagrant-hostsupdater vagrant-triggers vagrant-vbguest`
1. Get in `vagrant ssh`
1. Go to Wordpress dir `cd /srv/www/tela-botanica/public_html`
1. Create a `movefile.yml` (see example below)
1. Run `wordmove pull -e preprod --all [--no-uploads] [--simulate]` (`--no-uploads` saves some time and disk, and `--simulate` do dry-run to check config)
1. Done! Browse [local.tela-botanica.test](http://local.tela-botanica.test)

### Break some code
1. `subl ~/SOME-DEV-FOLDER/www/tela-botanica/public_html/wp-content/plugins/tela-botanica`
1. `subl ~/SOME-DEV-FOLDER/www/tela-botanica/public_html/wp-content/themes/tela-botanica`
1. And so on

## Examples
You can use these examples as is. Just replace `password-placeholder` by proper passwords.

### vvv-custom.yml
```yml
sites:
  tela-botanica:
    repo: https://github.com/telabotanica/vvv-wordpress-tela-botanica.git
    hosts:
      - local.tela-botanica.test

utilities:
  core:
    - memcached-admin
    - opcache-status
    - phpmyadmin
    - webgrind
    - trusted-hosts
  tb:
    - tb-framework
    - tb-framework-0.2
    - annuaire
    - cumulus
    - cumulus-front
    - php-mailparse
    - bower
    - ezmlm-php
    - ezmlm-forum
    - chorologie
    - eflore-consultation
    - sshpass
    - wordmove

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
  vhost: "http://local.tela-botanica.test"
  wordpress_path: "/srv/www/tela-botanica/public_html" # use an absolute path here

  database:
    name: "wordpress_tb"
    user: "wp"
    password: "wp"
    host: "localhost"

preprod:
  vhost: "https://beta.tela-botanica.org/preprod"
  wordpress_path: "/home/beta/www/preprod" # use an absolute path here

  database:
    name: "wordpress"
    user: "wordpress"
    password: "password-placeholder"
    host: "localhost"

  ssh:
    host: "aphyllanthe"
    user: "beta"
    password: "password-placeholder" # password is optional, will use public keys if available.
    port: 22 # Port is optional
    rsync_options: "--verbose" # Additional rsync options, optional

  exclude:
    #- ".git/"
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

test:
  vhost: "https://beta.tela-botanica.org/test"
  wordpress_path: "/home/beta/www/test" # use an absolute path here

  database:
    name: "wordpress_test"
    user: "wordpress"
    password: "password-placeholder"
    host: "localhost"

  ssh:
    host: "aphyllanthe"
    user: "beta"
    password: "password-placeholder" # password is optional, will use public keys if available.
    port: 22 # Port is optional
    rsync_options: "--verbose" # Additional rsync options, optional

  exclude:
    #- ".git/"
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
```
