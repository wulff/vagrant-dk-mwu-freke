# == Class: nginx
#
# This class installs and configures the NGinx web server.
#
# === Parameters
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'nginx':
#     version => latest,
#   }
#
class nginx(
  $htpasswd = UNSET,
  $version = present
) {

  package { 'nginx':
    ensure => $version,
  }

  service { 'nginx':
    enable => true,
    ensure => running,
    require => Package['nginx'],
  }

  file { '/var/www':
    ensure => directory,
  }

  file { '/var/www/htpasswd':
    content => "$htpasswd",
    mode => 0440,
    group => 'www-data',
    require => File['/var/www'],
  }

}
