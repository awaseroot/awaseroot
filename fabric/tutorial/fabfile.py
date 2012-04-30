from fabric.api import *

env.hosts=["simo@10.10.10.10", "webserver.local"]
env.roledefs={"server":["webserver.local"],"workstation":["10.10.10.10"]}
env.user="hng"
#env.password="password"
env.parallel=True
env.skip_bad_hosts=True
env.timeout=2
env.warn_only=True

### TUTORIAL 1 ###

def hostname_check():
    run("hostname")

def command(cmd):
    run(cmd)

def sudo_command(cmd):
    sudo(cmd)

def install(package):
    sudo("apt-get -y install %s" % package)

def local_cmd():
    local("echo fabtest >> test.log")

@parallel
def pcmd(cmd):
    run(cmd)

### TUTORIAL 2 ###

def file_send(localpath,remotepath):
    put(localpath,remotepath,use_sudo=True)

def file_sendm(localpath,remotepath,num):
    put(localpath,remotepath,mode=int(num, 8))

def file_get(remotepath, localpath):
    get(remotepath,localpath+"."+env.host)

@serial
def cmd(cmd):
    with settings(warn_only=True):
        if run(cmd).failed:
            sudo(cmd)


### TUTORIAL 3 ###

@with_settings(warn_only=True)
@hosts("10.10.10.10")
def install_g(package="geany"):
    sudo("apt-get install %s" % package)

def test():
	with settings(user="simo",host_string="Bubuntu.local"):
		run("whoami")
	run("pwd")
	with settings(hide("warnings","running"),warn_only=True):
		run("hostname")

def ssh_conf_backup():
    with cd("/etc/ssh/"):
        sudo("cp -b ssh_config ssh_config")

@roles("server")
def apache():
    sudo("apt-get update")
    sudo("apt-get install -y apache2")
    sudo("a2enmod userdir")

def test():
    env.hosts=["10.10.10.10"]
    env.user="test"
    env.warn_only=True
    env.parallel=True

def production():
    env.hosts=["webserver"]
    env.skip_bad_hosts=True
