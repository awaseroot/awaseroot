from fabric.api import *
from contextlib import contextmanager

env.warn_only=False

@contextmanager
def rollbackwrap():
    try:
        yield
    except SystemExit:
        rollback()
        abort("Fail!")

@task
def multitask():
    with rollbackwrap():
        task1()
        task2()
        task3()
        task4()

def task1():
    sudo("apt-get update")
    sudo("apt-get -y install php5")

def task2():
    sudo("./myscript")

def task3():
    put("foo.conf","/tmp/")

def task4():
    sudo("service apache2 restart")

def rollback():
    sudo("apt-get -y autoremove php5")
    sudo("rm -r mydir")
    sudo("rm /tmp/foo.conf")
