node default { include nagios_nrpe }

node 'thor.elisa' { include lamp }

node 'win7box.local' { include nscp }

node 'hngu.elisa' { 
  class { 'postfix':
    version   => 'latest',
    myorigin  => 'elisa.fi',
    relayhost => 'smtp.kolumbus.fi',
  }
  class { 'nagios3':
    version => 'latest',
  }
  linuxhost { 'linux1':
    name    => 'Ubuntu Linux',
    address => '192.168.100.111',
  }
  linuxhost { 'linux2':
    name    => 'Xubuntu Linux',
    address => 'thor.local'
  }
  winhost { 'win1':
    name    => 'windows',
    address => '192.168.100.25',
  }
  myhost { 'host1':
    name    => 'host1',
    group   => 'group1',
    address => 'host1.local',
  }

  mygroup { 'group1': }

  myservice { 'checkfile':
    host => 'win1',
    cmd  => 'check_nrpe!check_files!/path:"c:\\temp" /namefilter:"test\.txt" /expectmatch:1 /age:30n /selage:newer /warning:1: /critical:1:',
    desc => 'File backup test',
  }
  myservice { 'memorycheck':
    group => 'group1',
    cmd   => 'check_nrpe!CheckMEM!MaxWarn=95% MaxCrit=98% ShowAll=long type=physical',
    desc  => 'Memory usage',
  }
  myservice { 'drivecheck_c':
    group => 'group1',
    cmd   => 'check_nt!USEDDISKSPACE!-l c -w 90 -c 95',
    desc  => 'C:\ Drive Space',
  }
  myservice { 'cpucheck':
    group => 'group1',
    cmd   => 'check_nrpe!CheckCPU!MaxWarn=80 MaxCrit=90 time=20m time=10s time=4',
    desc  => 'CPU load',
  }
  myservice { 'cpucheck_linux':
    host => 'linux1',
    cmd  => 'check_nrpe_1arg!check_load',
    desc => 'CPU load',
  }
}
