# == Class: postfix
#
# This module manages postfix.
#
# Tested platforms:
#  - Ubuntu 12.10
#
# === Parameters
#
# $version = [ 'installed', 'latest' ]
# $myorigin = your domain address
# $relayhost = you can use this to specify a different email server for email relays (e.g. your ISP's email server)
# 
# === Examples
#
# class { 'postfix':
#   version   => 'latest',
#   myorigin  => 'domain.com',
#   relayhost => 'mail.isp.com',
# }
#
# === Authors
#
# Henri Siponen <siponenhenri@gmail.com>
#
class postfix($version='installed',$myorigin='/etc/mailname',$relayhost='') {

  case $::operatingsystem {
    debian, ubuntu: {
      $ok = true
      
    }
    centos, redhat, oel, linux: {
      $ok = true
      
    }
    default: {
      fail("This module is not supported on ${operatingsystem}")
    }
  }

  if ($ok) {

    package { 'postfix':
      ensure => $version,
    }

    service { 'postfix':
      ensure => 'running',
      enable => true,
    }

    file { '/etc/postfix/main.cf':
      ensure  => present,
      content => template('postfix/main.cf.erb'),
      require => Package['postfix'],
      notify  => Service['postfix'],
    }
  }
}

