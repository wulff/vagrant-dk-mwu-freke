# == Class: timezone
#
# This class configures the system timezone.
#
# === Parameters
#
# [*timezone*]
#   The name of the timezone, e.g. 'Europe/Copenhagen'. Required.
#
# === Examples
#
#   class { 'timezone':
#     name => 'Europe/Copenhagen',
#   }
#
class timezone(
  $name = 'UNSET'
) {
  file { '/etc/timezone':
    content => "${name}\n",
  }

  exec { 'timezone-reconfigure':
    command => 'dpkg-reconfigure --frontend noninteractive tzdata',
    unless => "grep ${name} /etc/timezone 2>/dev/null",
    require => File['/etc/timezone'],
  }
}
