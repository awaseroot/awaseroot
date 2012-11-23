class nscp {

  if ($operatingsystem == 'windows') {

    package { 'nscp':
      ensure => installed,
      source => 'D:\share\NSCP-0.4.1.62-x64.msi',
    }

    service { 'nscp':
      ensure  => running,
      enable  => true,
      require => Package['nscp'],
    }

    file { 'C:/Program Files/NSClient++/nsclient.ini':
      ensure  => file,
      owner   => 'SYSTEM',
      mode    => '0644',
      source  => 'puppet:///modules/nscp/nsclient.ini',
      require => Package['nscp'],
      notify  => Service['nscp'],
    }
  }
  else {
    fail('This module is only supported on Windows')
  }
}
