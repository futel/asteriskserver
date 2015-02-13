#!/usr/bin/env bash
# package current vagrant vm
# assume only one vagrant vm

set -x

boxname=$1
boxfilename=$2

vmname=`VBoxManage list vms | awk '{print $1}' | sed 's/"//g'`
vagrant halt
vagrant package --base $vmname
mv -f package.box $boxfilename
vagrant box add -f $boxname $boxfilename
vagrant destroy -f
