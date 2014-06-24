# == Class: cpanm::install
#
# Install a Perl module using cpanm.
#
# === Parameters
#
# [*module*]
#   The name of the module to install.
#
# === Examples
#
#   class { 'cpanm':
#     module => 'Date::Time',
#   }
#
define cpanm::install(
  $module = $title
) {
  exec { "$module":
    command => "/usr/bin/cpanm $module",
    require => Package['cpanminus'],
    timeout => 1800,
  }
}
