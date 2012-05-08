from fabric.api import *

env.user="vagrant"
env.password="vagrant"
env.skip_bad_hosts=True
env.timeout=4

def hfile(file="lucid32.list"):
    env.hosts = open(file, 'r').readlines()

def ifile(file="10.10.10.10.list"):
    env.hosts = open(file, 'r').readlines()

def cmd(cmd):
        run(cmd)
