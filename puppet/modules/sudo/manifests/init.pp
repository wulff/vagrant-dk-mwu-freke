# == Class: sudo
#
# This class installs the sudo package and configures sudoers.
#
# === Parameters
#
# [*username*]
#   The username to grant sudo rights. Required.
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'sudo':
#     username => 'johndoe',
#   }
#
class sudo(
  $username = 'UNSET',
  $version  = present
) {
  package { 'sudo':
    ensure => $version,
  }

  file { "/etc/sudoers.d/${username}":
    content => template('sudo/sudoers.erb'),
    mode => 440,
    require => User[$username],
  }
}
