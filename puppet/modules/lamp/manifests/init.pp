class lamp {
	
	Package { ensure => "installed" }
	
	package { "apache2": }
	package { "apache2.2-common": }
	package { "php5": }
	package { "libapache2-mod-auth-mysql": }
	package { "php5-mysql": }
	package { "mysql-server": }
	package { "phpmyadmin":}

	exec { "mysqlpasswd":
		command => "/usr/bin/mysqladmin -u root password ChangeThis1",
		notify => [Service["mysql"], Service["apache2"]],
		require => [Package["mysql-server"], Package["apache2"]],
	}

	service { "apache2":
		ensure => "running",
		enable => "true",
		require => Package["apache2"],
	}

	service { "mysql":
                ensure => "running",
                enable => "true",
                require => Package["mysql-server"],
        }

	exec { "userdir":
		notify => Service["apache2"],
		command => "/usr/sbin/a2enmod userdir",
		require => Package["apache2"],
	}

	file { "/etc/apache2/mods-available/php5.conf":
		notify => Service["apache2"],
		ensure => "present",
		source => "puppet:///modules/lamp/php5.conf",
		require => [Package["apache2"], Package["php5"]],
	}
	
	file { "/var/www/index.php":
		notify => Service["apache2"],
                ensure => "present",
                source => "puppet:///modules/lamp/index.php",
                require => [Package["apache2"], Package["php5"]],	
	}

	file { "/etc/apache2/apache2.conf":
                notify => Service["apache2"],
                ensure => "present",
                source => "puppet:///modules/lamp/apache2.conf",
                require => [Package["apache2"], Package["phpmyadmin"]],
        }

}
