# == Class: screen
#
# This class installs and configures Screen.
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
define screen(
  $username = $title,
  $options = 'UNSET',
  $additions = 'UNSET',
  $version = present
) {
  package { 'screen':
    ensure => $version,
  }

  file { "/home/${username}/.screenrc":
    content => template('screen/screenrc.erb'),
    owner => $username,
    group => $username,
  }
}
