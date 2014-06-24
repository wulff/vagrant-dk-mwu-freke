# == Class: nginx::mojo
#
# TBD
#
# === Parameters
#
# [*port number*]
#   TBD
#
# === Examples
#
#   nginx::mojo { '3000': }
#
define nginx::mojo (
  $hostname = $title,
  $upstream = UNSET,
  $port = UNSET
) {

  file { "/etc/nginx/sites-available/$hostname":
    content => template('nginx/mojo.conf.erb'),
    require => Package['nginx'],
  }

  file { "/etc/nginx/sites-enabled/$hostname":
    ensure => link,
    target => "/etc/nginx/sites-available/$hostname",
    require => File["/etc/nginx/sites-available/$hostname"],
    notify => Service['nginx'],
  }
  
}
