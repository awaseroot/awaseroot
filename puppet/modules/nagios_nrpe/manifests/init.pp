class nagios_nrpe {

  package { 'nagios-nrpe-server':
    ensure => latest,
  }

  service { 'nagios-nrpe-server':
    ensure  => running,
    enable  => true,
    require => Package['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.cfg':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    source  => 'puppet:///modules/nagios_nrpe/nrpe.cfg',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }
}
