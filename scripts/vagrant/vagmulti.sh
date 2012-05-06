#!/bin/bash

##
# You can create multiple Vagrant boxes with this scrpit.
# Do these first or run vaginit.sh script if you don't have any Vagrant boxes.
# If you have a Vagrant box already, just package it.
# $ sudo apt-get update
# $ sudo apt-get -y install vagrant
# $ vagrant box add base http://files.vagrantup.com/lucid32.box
# $ vagrant init
# $ vagrant up
# $ vagrant ssh
# vagrant@lucid32:~$ sudo apt-get -y install libnss-mdns
# vagrant@lucid32:~$ exit
# $ cat Vagrantfile | sed s/'# config.vm.network :hostonly, "192.168.33.10"'/'config.vm.network :hostonly, "10.10.10.10"'/ > tmpvag
# $ mv tmpvag Vagrantfile
# $ vagrant package
##

echo "Number of VMs to be created(1-99): "
read NUMBER
COUNT=1
echo "####################################"

until [ $COUNT -gt $NUMBER ]; do {
cp package.box vbox$COUNT.box	# Copies the packaged box
vagrant box add vbox$COUNT ./vbox$COUNT.box # Adds new box copies to Vagrant
rm vbox$COUNT.box
sed '$d' < Vagrantfile > tmpvag ; mv tmpvag Vagrantfile # Removes the last line of Vagrantfile
cat >> Vagrantfile << EOF
    config.vm.define :vbox$COUNT do |kconfig_$COUNT|
    kconfig_$COUNT.vm.box = "vbox$COUNT"
    #kconfig_$COUNT.vm.network :bridged	# uncomment to use IPs from DHCP
    kconfig_$COUNT.vm.network :hostonly, "10.10.10.1$COUNT"
  end
end
EOF
echo "VM vbox$COUNT created"
let COUNT=COUNT+1
}
done
echo "Run 'vagrant up' to start all VMs"
echo "Run 'vagrant up vbox1' to start vbox1"
