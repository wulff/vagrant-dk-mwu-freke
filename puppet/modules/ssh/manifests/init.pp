# == Class: ssh
#
# This class installs the OpenSSH client and server packages.
#
# === Parameters
#
# [*username*]
#   The name of a user who should be allowed to login via SSH. Required.
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'latest'.
#
# === Examples
#
#   class { 'ssh':
#     username => 'johndoe',
#   }
#
class ssh (
  $allowusers = 'UNSET',
  $version = latest
) {
  package { ['openssh-server', 'openssh-client']:
    ensure => $version,
  }

  service { 'ssh':
    ensure => running,
    require => Package['openssh-server'],
  }

  file { '/etc/ssh/sshd_config':
    content => template('ssh/sshd_config.erb'),
    require => Package['openssh-server'],
    notify => Service['ssh'],
  }
}
