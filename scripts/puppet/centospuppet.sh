#!/bin/bash

sudo sh -c \
'sudo cat > /etc/yum.repos.d/puppet.repo << EOF
[puppetlabs]
name=Puppet Labs Packages
baseurl=http://yum.puppetlabs.com/el/\$releasever/products/\$basearch/
enabled=1
gpgcheck=1
gpgkey=http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
EOF'

sudo sh -c \
'sudo cat > /etc/yum.repos.d/ruby.repo << EOF
[ruby]
name=ruby
baseurl=http://repo.premiumhelp.eu/ruby/
gpgcheck=0
enabled=0
EOF'

sudo sh -c \
'sudo cat > /etc/yum.repos.d/epel.repo << EOF
[epel]
name=Extra Packages for Enterprise Linux 5 - \$basearch
#baseurl=http://download.fedoraproject.org/pub/epel/5/\$basearch
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=\$basearch
failovermethod=priority
enabled=0
gpgcheck=0

[epel-puppet]
name=epel puppet
baseurl=http://tmz.fedorapeople.org/repo/puppet/epel/5/\$basearch/
enabled=0
gpgcheck=0
EOF'

sudo yum install -y ruby
sudo yum --enablerepo="ruby" update ruby

sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-5.noarch.rpm
#sudo yum update

sudo yum --enablerepo=epel,epel-puppet install -y puppet

#yum --enablerepo=epel,epel-puppet install -y puppet-server
#sudo yum install -y puppet-server

sudo sh -c 'echo "    server = master.local" >> /etc/puppet/puppet.conf'
sudo service puppet restart
sudo chkconfig puppet on

