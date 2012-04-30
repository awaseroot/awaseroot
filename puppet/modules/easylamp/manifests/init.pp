class easylamp {

	package { "tasksel":
		ensure => "installed",	
	}

	exec { "lamp":
		command => "/usr/bin/tasksel install lamp-server",
		require => Package["tasksel"],
	}

	file { "/var/www/phpinfo.php":
		ensure => "present",
		content => "<?php phpinfo();?><br/>installed with tasksel",
		require => Exec["lamp"],
	}

	 file { "/etc/apache2/mods-available/php5.conf":
                notify => Service["apache2"],
                ensure => "present",
                source => "puppet:///modules/lamp/php5.conf",
                require => Exec["lamp"],
        }

	service { "apache2":
		ensure => "running",
                enable => "true",
                require => Exec["lamp"],
        }


}
