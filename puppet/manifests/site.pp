# basic site manifest

# define global paths and file ownership
Exec { path => '/usr/sbin/:/sbin:/usr/bin:/bin' }
File { owner => 'root', group => 'root' }

# create a stage to make sure apt-get update is run before all other tasks
stage { 'requirements': before => Stage['main'] }
stage { 'bootstrap': before => Stage['requirements'] }

import 'settings'

class freke::bootstrap {
  # we need an updated list of sources before we can apply the configuration
  exec { 'freke_apt_update':
    command => '/usr/bin/apt-get update',
  }
}

class freke::requirements {
  # install git-core and add some useful aliases
  class { 'git': }

  class { 'cpanm': }

  user { $user_name:
    ensure => present,
    managehome => true,
    comment => $user_comment,
    shell => '/bin/bash',
    groups => ['sudo'],
    password => $user_password,
  }

  ssh_authorized_key { $user_name:
    user => $user_name,
    ensure => present,
    type => 'ssh-rsa',
    key => $user_authorized_key,
    require => User[$user_name],
  }

  # mojo user

  user { $mojo_user_name:
    ensure => present,
    managehome => true,
    shell => '/bin/false',
    password => $mojo_user_password,
  }

  class { 'ssh':
    allowusers => $ssh_allowusers,
  }

  package { 'build-essential':
    ensure => present,
  }
}

class freke::install {

  # configure the firewall

  class { 'iptables': }

  # configure postfix as a null client
  # http://www.postfix.org/STANDARD_CONFIGURATION_README.html#null_client

  class { 'postfix':
    hostname => 'freke.mwu.dk',
  }

  # install database server

  class { 'mysql::server':
    package_name => 'mariadb-server',
    root_password => $mysql_root_password,
    restart => true,
    remove_default_accounts => true,
    users => {
      'muskox@localhost' => {
        ensure                   => 'present',
        max_connections_per_hour => '0',
        max_queries_per_hour     => '0',
        max_updates_per_hour     => '0',
        max_user_connections     => '0',
        password_hash            => $mysql_muskox_password_hash,
      },
    },
    databases => {
      'mojo_muskox' => {
        ensure  => 'present',
        charset => 'utf8',
        collate => 'utf8_general_ci',
      },
    },
    grants => {
      'muskox@localhost/mojo_muskox.*' => {
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['CREATE', 'SELECT', 'INSERT', 'UPDATE'],
        table      => 'mojo_muskox.*',
        user       => 'muskox@localhost',
      },
    },
  }
  class { 'mysql::server::backup':
    backupuser => 'backup',
    backuppassword => $mysql_backup_password,
    backupdir => '/var/backups/mysql',
    backupdirowner => 'backup',
    backupdirgroup => 'backup',
    backupcompress => true,
    backuprotate => 14,
    backupdatabases => ['mojo_muskox'],
    file_per_database => true,
    time => ['4', '20'],
    # postscript => 'rsync /var/backups/mysql backup@gere.mwu.dk',
  }
  class { 'mysql::server::mysqltuner': }
  class { 'mysql::client':
    package_name => 'mariadb-client',
  }

  # install web server

  class { 'nginx':
    htpasswd => $htpasswd,
  }

  nginx::mojo { 'ox.mwu.dk':
    port => 3000,
    upstream => 'moskux',
  }
  nginx::mojo { 'cpr.mwu.dk':
    port => 3001,
    upstream => 'cpr',
  }

  # install required perl modules

  cpanm::install { 'Mojolicious': }
  cpanm::install { 'Date::Time': }
  cpanm::install { 'DateTime::Format::MySQL': }
  cpanm::install { 'DBIx::Class': }
  cpanm::install { 'DBIx::Class::Schema::Loader': }
  cpanm::install { 'Geo::Coordinates::UTM': }
  cpanm::install { 'SQL::Translator': }

  # monitoring and notification tools

  class { 'munin::node':
    host => 'TODO',
    allow => '^192\.168\.157\.235$',
  }

  class { 'apticron':
    recipients => $apticron_recipients,
  }

  # install various system tools

  package { 'htop':
    ensure => present,
  }

  package { 'ncdu':
    ensure => present,
  }

  package { 'ntp':
    ensure => latest,
  }

  screen { $user_name:
    options => {
      'vbell' => 'on',
      'autodetach' => 'on',
      'startup_message' => 'off',
    },
    additions => [
      'screen -t local 0',
    ],
  }

  # update various system settings

  class { 'timezone':
    name => 'Europe/Copenhagen',
  }

  # various dot-files

  file { '/etc/profile.d/aliases.sh':
    content => 'alias update="sudo apt-get update"
alias upgrade="sudo apt-get upgrade"
alias puppet-apply="sudo puppet apply --modulepath=/home/wulff/vagrant/puppet/modules/ /home/wulff/vagrant/puppet/manifests/site.pp"',
    mode => 0644,
  }

  file { '/etc/hostname':
    content => 'freke.mwu.dk',
    mode => 0644,
  }
  exec { 'update-hostname':
    command => '/bin/hostname -F /etc/hostname',
    require => File['/etc/hostname'],
  }
}

class freke::go {
  class { 'freke::bootstrap':
    stage => 'bootstrap',
  }
  class { 'apt':
    stage => 'requirements',
  }
  class { 'freke::requirements':
    stage => 'requirements',
  }
  class { 'freke::install': }
}

include freke::go
