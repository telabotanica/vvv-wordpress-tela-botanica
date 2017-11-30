# VVV WordPress Tela Botanica

Tela Botanica WordPress development environment based on [VVV](https://github.com/Varying-Vagrant-Vagrants/VVV).

## Objectives

* Approachable development environment with a modern server configuration.
* Stable state of software and configuration in default provisioning.

## How to Use VVV WordPress Tela Botanica

Requires recent versions of both Vagrant and VirtualBox.

[Vagrant](https://www.vagrantup.com) is a "tool for building and distributing development environments". It works with [virtualization](https://en.wikipedia.org/wiki/X86_virtualization) software such as [VirtualBox](https://www.virtualbox.org/) to provide a virtual machine sandboxed from your local environment.

1. Clone a fresh [VVV](https://github.com/Varying-Vagrant-Vagrants/VVV)
1. Create a `vvv-custom.yml` as:

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

utility-sources:
  tb: https://github.com/telabotanica/vvv-utilities-tela-botanica

vm_config:
  memory: 2048
  cores: 2

```
