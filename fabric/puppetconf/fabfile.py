from fabric.api import *

env.hosts=["ubuntu1.local","ubuntu2.local","ubuntu3.local","puppetmaster.local"]
env.roledefs={"slaves":["ubuntu1.local","ubuntu2.local","ubuntu3.local"],"master":["puppetmaster.local"]}
env.user="linuxuser"
env.skip_bad_hosts=True
env.warn_only=True
env.timeout=1
env.parallel=True
env.linewise=True

@roles("master")
@runs_once
def pup_master(master):
    """Configure Puppetmaster [master]"""
    sudo("apt-get update")
    sudo("apt-get -y install puppetmaster puppet")
    sudo("service puppetmaster stop")
    sudo("rm -r /var/lib/puppet/ssl")
    sudo("echo 'dns_alt_names = %s' >> /etc/puppet/puppet.conf" % master)
    sudo("service puppetmaster start")
    sudo("mkdir -p /etc/puppet/manifests/ /etc/puppet/modules/")
    # Test module:
    sudo("mkdir -p /etc/puppet/modules/test/manifests/")
    sudo('echo include test > /etc/puppet/manifests/site.pp')
    sudo('echo "class test { file { \\"/tmp/hello\\": content => \\"HelloWorld\\\n\\" } }" > /etc/puppet/modules/test/manifests/init.pp')

@roles("slaves")
def pup(server="puppetmaster.local"):
    """Configure slaves [server], default: puppetmaster.local"""
    sudo("apt-get update")
    sudo("apt-get -y install puppet")
    sudo("echo '[agent]\nserver = %s' >> /etc/puppet/puppet.conf" % server)
    sudo('sed s/START=no/START=yes/ /etc/default/puppet > /tmp/puppi')
    sudo('mv /tmp/puppi /etc/default/puppet')
    sudo('service puppet restart')

@roles('master')
@runs_once
def clist():
    """List certificate requests"""
    sudo("puppet cert --list")

@roles('master')
@runs_once
def csign(agent="--all"):
    """Sign certificate requests, default=all"""
    sudo("puppet cert --sign %s" % agent)
