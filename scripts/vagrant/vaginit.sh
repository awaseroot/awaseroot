#!/bin/bash

# This script installs Vagrant, downloads a base box, configures it
# to use IP 10.10.10.10. Then installs libnss-mdns
# to the vagrant box and packages it.
# Run vagmulti.sh script after this to add multiple boxes.

sudo apt-get update
sudo apt-get -y install vagrant
vagrant box add base http://files.vagrantup.com/lucid32.box
vagrant init
cat Vagrantfile | sed s/'# config.vm.network :hostonly, "192.168.33.10"'/'config.vm.network :hostonly, "10.10.10.10"'/ > tmpvag
mv tmpvag Vagrantfile
vagrant up
ssh vagrant@10.10.10.10 sh -c 'sudo apt-get update ; sudo apt-get -y install libnss-mdns ; sudo service avahi-daemon restart'
vagrant package
