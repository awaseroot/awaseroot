#!/bin/bash

sudo apt-get update
sudo apt-get -y install python-pip
sudo pip install fabric
wget https://raw.github.com/awaseroot/awaseroot/master/fabric/vagrant/fabfile.py
fab -l
