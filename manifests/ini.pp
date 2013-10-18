# Defines where we can expect PHP ini files and paths to be located.
#
# Different OS, OS version, webserver and PHP versions all contributes
# to making a mess of where we can expect INI files to be found.
#
# I have listed a bunch of places:
#
# 5.3
#     DEBIAN 6 - squeeze
#         APACHE
#             FOLDERS: apache2/  cli/  conf.d/  php.ini
#             /etc/php5/apache2/conf.d    -> /etc/php5/conf.d
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d
#         NGINX
#             FOLDERS: cli/  conf.d/  fpm/
#             /etc/php5/fpm/conf.d        -> /etc/php5/conf.d
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d
#     DEBIAN 7 - wheezy
#         APACHE
#             NOT CORRECT; PHP 5.4 INSTALLED
#         NGINX
#             NOT CORRECT; PHP 5.4 INSTALLED
#     UBUNTU 10.04 - lucid
#         APACHE
#             FOLDERS: apache2/  cli/  conf.d/  php.ini
#             /etc/php5/apache2/conf.d    -> /etc/php5/conf.d
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d
#         NGINX
#             FOLDERS: cli/  conf.d/  fpm/
#             /etc/php5/fpm/conf.d        -> /etc/php5/conf.d
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d
#     UBUNTU 12.04 - precise
#         APACHE
#             FOLDERS: apache2/  cli/  conf.d/  php.ini
#             /etc/php5/apache2/conf.d    -> /etc/php5/conf.d
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d
#         NGINX
#             FOLDERS: cli/  conf.d/  fpm/
#             /etc/php5/fpm/conf.d        -> /etc/php5/conf.d
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d
# 5.4
#     DEBIAN 6 - squeeze
#         APACHE
#             FOLDERS: apache2/  cli/  conf.d/  mods-available/  php.ini
#             /etc/php5/apache2/conf.d    -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#         NGINX
#             FOLDERS: cli/  conf.d/  fpm/  mods-available/
#             /etc/php5/fpm/conf.d/*      -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d/*      -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#     DEBIAN 7 - wheezy
#         APACHE
#             FOLDERS: apache2/  cli/  conf.d/  mods-available/  php.ini
#             /etc/php5/apache2/conf.d    -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#         NGINX
#             FOLDERS: cli/  conf.d/  fpm/  mods-available/
#             /etc/php5/fpm/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#     UBUNTU 10.04 - lucid
#         APACHE
#             FOLDERS: apache2/  cli/  conf.d/  mods-available/  php.ini
#             /etc/php5/apache2/conf.d    -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#         NGINX
#             FOLDERS: cli/  conf.d/  fpm/  mods-available/
#             /etc/php5/fpm/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#     UBUNTU 12.04 - precise
#         APACHE
#             FOLDERS: apache2/  cli/  conf.d/  mods-available/  php.ini
#             /etc/php5/apache2/conf.d    -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#         NGINX
#             FOLDERS: cli/  conf.d/  fpm/  mods-available/
#             /etc/php5/fpm/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d        -> /etc/php5/conf.d/*   -> /etc/php5/mods-available/*
# 5.5
#     DEBIAN 6 - squeeze
#         APACHE
#             NOT A VALID OPTION
#         NGINX
#             NOT A VALID OPTION
#     DEBIAN 7 - wheezy
#         APACHE
#             FOLDERS: apache2/  cli/  mods-available/  php.ini
#             /etc/php5/apache2/conf.d/*  -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d/*      -> /etc/php5/mods-available/*
#         NGINX
#             FOLDERS: cli/  fpm/  mods-available/
#             /etc/php5/fpm/conf.d/*      -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d/*      -> /etc/php5/mods-available/*
#     UBUNTU 10.04 - lucid
#         APACHE
#             NOT A VALID OPTION
#         NGINX
#             NOT A VALID OPTION
#     UBUNTU 12.04 - precise
#         APACHE
#             NOT A VALID OPTION
#         NGINX
#             FOLDERS: cli/  fpm/  mods-available/
#             /etc/php5/fpm/conf.d/*      -> /etc/php5/mods-available/*
#             /etc/php5/cli/conf.d/*      -> /etc/php5/mods-available/*
#
# This depends on example42/puppet-php: https://github.com/example42/puppet-php
#
define puphpet::ini (
  $php_version,
  $webserver,
  $ini_filename = 'custom.ini',
  $entry,
  $value  = '',
  $ensure = present
  ) {

  $real_webserver = $webserver ? {
      'apache'  => 'apache2',
      'httpd'   => 'apache2',
      'apache2' => 'apache2',
      'nginx'   => 'fpm',
      'fpm'     => 'fpm',
  }

  case $php_version {
    '5.3', '53': {
      case $::osfamily {
        'debian': {
          $target_dir  = '/etc/php5/conf.d'
          $target_file = "${target_dir}/${ini_filename}"

          if ! defined(File[$target_file]) {
            file { $target_file:
              replace => no,
              ensure  => present,
              require => Package['php']
            }
          }

          php::augeas{ "${entry}-${value}" :
            target  => $target_file,
            entry   => $entry,
            value   => $value,
            ensure  => $ensure,
            require => File[$target_file]
          }
        }
        default: { fail('This OS has not yet been defined!') }
      }
    }
    '5.4', '54': {
      case $::osfamily {
        'debian': {
          #
        }
        default: { fail('This OS has not yet been defined!') }
      }
    }
    '5.5', '55': {
      case $::osfamily {
        'debian': {
          #
        }
        default: { fail('This OS has not yet been defined!') }
      }
    }
    default: { fail('Unrecognized PHP version') }
  }

}
