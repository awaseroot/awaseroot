from fabric.api import *

env.user="hng"
env.hosts=["host1.local","host2.local"]
#env.password="p"
env.warn_only=True
env.paralle=True

def r_upgrade_y():
	sudo('echo "y\n\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive /usr/bin/do-release-upgrade')

def r_upgrade_n():
	sudo('echo "y\n\ny\nN\nN\nN\nN\nN\nN\nN\nN\nN\nN\nN\n" | DEBIAN_FRONTEND=noninteractive /usr/bin/do-release-upgrade')

