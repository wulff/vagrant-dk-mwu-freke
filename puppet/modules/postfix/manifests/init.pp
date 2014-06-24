# == Class: postfix
#
# This class installs the Irssi package and a basic configuration file.
#
# === Parameters
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'postfix':
#     hostname => 'foo.example.com',
#   }
#
class postfix(
  $hostname = 'UNSET',
  $version = present
) {
  package { 'postfix':
    ensure => $version,
  }

  service { 'postfix':
    ensure => running,
  }

  file { '/etc/postfix/main.cf':
    content => template('postfix/main.erb'),
    require => Package['postfix'],
    notify => Service['postfix'],
  }
}
