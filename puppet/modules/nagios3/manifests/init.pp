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
# myhost (name,group,address,contactgr)
# myservice (host,cmd,desc,contactgr)
# mygroup (group)
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
# myhost { 'host1':
#   name    => 'host1',
#   group   => 'group1',
#   address => 'host1.local',
# }
# myservice { 'checkcpu':
#   host => 'win1',
#   cmd  => 'check_nrpe!CheckCPU!MaxWarn=80 MaxCrit=90 time=20m time=10s time=4',
#   desc => 'CPU load',
# }
# mygroup { 'group1': }
# 
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
    File { owner => 'root', group => 'root', mode => '0644', require => Package['nagios3'], notify => Service['nagios3'], }

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
      ensure  => 'running',
      enable  => true,
      require => Package['nagios3'],
    }

    file { '/etc/nagios3/nagios.cfg':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/nagios.cfg',
    }

    file { '/etc/nagios3/commands.cfg':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/commands.cfg',
    }

    file { '/etc/nagios3/objects':
      ensure  => directory,
      mode    => 0755,
    }

    file { '/etc/nagios3/htpasswd.users': 
      ensure  => present,
      source  => 'puppet:///modules/nagios3/htpasswd.users',
    }
    
    file { '/etc/nagios3/objects/templates.cfg':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/objects/templates.cfg',
    }

    file { '/etc/nagios-plugins/config/nt.cfg':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/nagios-plugins/nt.cfg',
    }

    file { '/etc/init.d/nagios3':
      ensure  => present,
      source  => 'puppet:///modules/nagios3/init.d/nagios3',
      mode    => '0755',
    }

    Nagios_hostgroup { require => Package['nagios3'], notify  => Service['nagios3'], }

    Nagios_service { 
      require => Package['nagios3'], 
      notify  => Service['nagios3'],
      target  => '/etc/nagios3/objects/nagios_services.cfg',
      use     => 'generic-service'
    }

    file { '/etc/nagios3/conf.d/contacts_nagios2.cfg':
      ensure => 'present',
      source  => 'puppet:///modules/nagios3/conf.d/contacts_nagios2.cfg',
    }

    file { '/etc/nagios3/objects/nagios_hostgroup.cfg': ensure => 'file', }
    file { '/etc/nagios3/objects/nagios_services.cfg': ensure => 'file', }
    file { '/etc/nagios3/objects/linux_hosts.cfg': ensure => 'file', }
    file { '/etc/nagios3/objects/windows_hosts.cfg': ensure => 'file', }

  }
} 

define linuxhost ($name,$address) {

  nagios_host { $title:
    target  => '/etc/nagios3/objects/linux_hosts.cfg',
    use     => 'linux-box',
    alias   => $name,
    address => $address,
    require => Package['nagios3'],
    notify  => Service['nagios3'],
  }
}

define winhost ($name,$address) {

  nagios_host { $title:
    target  => '/etc/nagios3/objects/windows_hosts.cfg',
    use     => 'windows-server',
    alias   => $name,
    address => $address,
    require => Package['nagios3'],
    notify  => Service['nagios3'],
  }
}

define myhost ($name,$group,$address,$contactgr='admins') {

  nagios_host { $title:
    target         => '/etc/nagios3/objects/windows_hosts.cfg',
    use            => 'windows-server',
    hostgroups     => $group,
    alias          => $name,
    address        => $address,
    contact_groups => $contactgr,
    require        => Package['nagios3'],
    notify         => Service['nagios3'],
  }
}

define myservice ($host='',$group='',$contactgr='admins',$cmd,$desc) {

  nagios_service { $title:
    target              => '/etc/nagios3/objects/nagios_services.cfg',
    use                 => 'generic-service',
    host_name           => $host,
    hostgroup_name      => $group,
    check_command       => $cmd,
    service_description => $desc,
    contact_groups      => $contactgr,
    require             => Package['nagios3'],
    notify              => Service['nagios3'],
  }
}

define mygroup {

  nagios_hostgroup { $title:
    target  => '/etc/nagios3/objects/nagios_hostgroup.cfg',
    require => Package['nagios3'],
    notify  => Service['nagios3'],
  }
}

