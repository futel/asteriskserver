#!/usr/bin/env bash
# package current vagrant vm
# assume only one vagrant vm with boxtype in name

set -x

boxtype=$1
boxname=$2
boxfilename=$3

export vagrantbox=$boxname
vmname=`VBoxManage list vms | awk '{print $1}' | sed 's/"//g' | grep $boxtype`
vagrant package --base $vmname # --vagrantfile Vagrantfile
mv -f package.box $boxfilename
vagrant box add -f $boxname $boxfilename
vagrant destroy -f
