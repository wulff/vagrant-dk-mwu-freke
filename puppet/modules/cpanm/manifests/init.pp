# == Class: cpanm
#
# This class installs cpanminus.
#
# === Parameters
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'cpanm':
#     version => latest,
#   }
#
class cpanm(
  $version = present
) {
  package { 'cpanminus':
    ensure => $version,
  }
}
