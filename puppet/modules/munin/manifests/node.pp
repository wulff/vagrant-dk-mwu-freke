# == Class: munin::node
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
class munin::node(
  $allow = '^127\.0\.0\.1$',
  $host = '127.0.0.1',
  $port = '4949',
  $version = present
) {
  package { 'munin-node':
    ensure => $version,
  }

  file { '/etc/munin/munin-node.conf':
    content => template('munin/munin-node.conf.erb'),
    require => Package['munin-node'],
  }
}
