# == Class: apticron
#
# This class installs and configures the apticron package.
#
# === Parameters
#
# [*recipients*]
#   A space separated list of e-mail addresses. Required.
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'apticron':
#     recipients => 'johndoe@example.com',
#   }
#
class apticron(
  $recipients = 'UNSET',
  $version    = present
) {
  package { 'apticron':
    ensure => $version,
    require => Package['postfix'],
  }

  file { "/etc/apticron/apticron.conf":
    content => template('apticron/apticron.erb'),
    require => Package['apticron'],
  }
}
