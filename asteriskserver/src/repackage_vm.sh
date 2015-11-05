#!/usr/bin/env bash
# fix interfaces and repackage current vagrant vm
# assume only one vagrant vm with boxtype in name
# this is needed after packaging

set -x

boxtype=$1
boxname=$2
boxfilename=$3

scriptdir=`dirname $0`
export vagrantbox=$boxname

vagrant up --no-provision # will error when configuring network interfaces
cat $scriptdir/fix_package.sh | vagrant ssh -c 'cat>/tmp/fix_package.sh'
vagrant ssh -c 'sudo sh /tmp/fix_package.sh'
$scriptdir/package_vm.sh $boxtype $boxname $boxfilename
