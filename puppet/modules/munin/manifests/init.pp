# == Class: munin
#
# This class installs and configures Munin.
#
# === Parameters:
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'munin':
#     version => latest,
#   }
#
class munin(
  $user = 'UNSET',
  $mail = 'UNSET',
  $hosts = 'UNSET',
  $version = present
) {
  package { 'munin':
    ensure => $version,
  }

  file { '/etc/munin/munin.conf':
    content => template('munin/munin.conf.erb'),
    require => Package['munin'],
  }
}
