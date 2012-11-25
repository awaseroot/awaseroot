# == Class: nagios3
#
# This module manages Nagios.
# Work in progress...
#
# Tested platforms:
#  - Ubuntu 12.10
#
# === Parameters
#
# $version = [ 'installed', 'latest' ]
# linuxhost (name,address)
# winhost (name,address)
# 
# === Examples
#
# class { 'nagios3':
#   version => 'latest',
# }
# linuxhost { 'linux1':
#   name    => 'Ubuntu Linux',
#   address => '192.168.100.111',
# }
# winhost { 'win1':
#   name    => 'windows',
#   address => '192.168.100.25',
# }
#
# === Authors
#
# Henri Siponen <siponenhenri@gmail.com>
#
class nagios3($version='latest') {

  case $::operatingsystem {
    debian, ubuntu: {
      $ok = true
    }
    centos, redhat, oel, linux: {
      fail("This module is not yet tested or supported on ${operatingsystem}")      
    }
    default: {
      fail("This module is not supported on ${operatingsystem}")
    }
  }

  if ($ok) {

    Package { ensure => $version, }
    File { owner => 'root', group => 'root', mode => '0644', }

    package { 'libapache2-mod-php5': }
    package { 'libgd2-xpm-dev': }
    package { 'apache2': }

    service { 'apache2':
      ensure  => 'running',
      enable  => true,
      require => Package['apache2'],
    }

    package { 'nagios3': require => Package['apache2'] }
    package { 'nagios-nrpe-plugin': require => Package['nagios3'] }

    service { 'nagios3':
      ensure     => 'running',
      enable     => true,
      require    => Package['nagios3'],
    }

    file { '/etc/nagios3/nagios.cfg':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/nagios.cfg',
      require => Package['nagios3'],
      notify  => Service['nagios3'],
    }

    file { '/etc/nagios3/commands.cfg':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/commands.cfg',
      require => Package['nagios3'],
      notify  => Service['nagios3'],
    }

    file { '/etc/nagios3/objects':
      ensure  => directory,
      mode   => 0755,
      require => Package['nagios3'],
    }

    file { '/etc/nagios3/htpasswd.users': 
      ensure  => present,
      source  => 'puppet:///modules/nagios3/htpasswd.users',
      require => Package['nagios3'],
      notify  => Service['nagios3'],
    }
    
    file { '/etc/nagios3/objects/templates.cfg':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/objects/templates.cfg',
      require => Package['nagios3'],
      notify  => Service['nagios3'],
    }

    file { '/etc/nagios-plugins/config/nt.cfg':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/nagios-plugins/nt.cfg',
      require => Package['nagios3'],
      notify  => Service['nagios3'],
    }

    file { '/etc/init.d/nagios3':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/init.d/nagios3',
      mode    => '0755',
      require => Package['nagios3'],
      notify  => Service['nagios3'],
    }

    Nagios_hostgroup { require => Package['nagios3'], notify  => Service['nagios3'], }

    nagios_hostgroup { 'linuxhosts':
      target  => '/etc/nagios3/objects/nagios_hostgroup.cfg',
    }

    nagios_hostgroup { 'winhosts':
      target => '/etc/nagios3/objects/nagios_hostgroup.cfg',
    }

    Nagios_service { 
      require => Package['nagios3'], 
      notify  => Service['nagios3'],
      target  => '/etc/nagios3/objects/nagios_services.cfg',
      use     => 'generic-service'
    }

    nagios_service { 'check_load':
      hostgroup_name => 'linuxhosts',
      check_command  => 'check_nrpe_1arg!check_load',
      service_description => 'CPU Load',
    }

    nagios_service { 'check_users':
      hostgroup_name => 'linuxhosts',
      check_command  => 'check_nrpe_1arg!check_users',
      service_description => 'Current Users',
    }

    nagios_service { 'check_total_procs':
      hostgroup_name => 'linuxhosts',
      check_command  => "check_nrpe_1arg!check_total_procs",
      service_description => 'Total Processes',
    }

    nagios_service { 'check_hda1':
      hostgroup_name => 'linuxhosts',
      check_command  => "check_nrpe_1arg!check_hda1",
      service_description => '/dev/hda1 Free Space',
    }

    nagios_service { 'check_zombie_procs':
      hostgroup_name => 'linuxhosts',
      check_command  => "check_nrpe_1arg!check_zombie_procs",
      service_description => 'Zombie Processes',
    }
  }

  file { '/etc/nagios3/objects/nagios_hostgroup.cfg': ensure => 'file', }
  file { '/etc/nagios3/objects/nagios_services.cfg': ensure => 'file', }
  file { '/etc/nagios3/objects/linux_hosts.cfg': ensure => 'file', }
  file { '/etc/nagios3/objects/windows_hosts.cfg': ensure => 'file', }
} 

define linuxhost ($name,$address) {

  nagios_host { $title:
    target     => '/etc/nagios3/objects/linux_hosts.cfg',
    use        => 'linux-box',
    alias      => $name,
    address    => $address,
    require => Package['nagios3'],
    notify  => Service['nagios3'],
  }
}

define winhost ($name,$address) {

  nagios_host { $title:
    target     => '/etc/nagios3/objects/windows_hosts.cfg',
    use        => 'windows-server',
    alias      => $name,
    address    => $address,
    require => Package['nagios3'],
    notify  => Service['nagios3'],
  }
}
