#!/usr/bin/env bash
# fix interfaces and repackage current vagrant vm
# assume only one vagrant vm
# this is needed after packaging

set -x

boxname=$1
boxfilename=$2

scriptdir=`dirname $0`

vagrant up --no-provision # will error when configuring network interfaces
cat $scriptdir/fix_package.sh | vagrant ssh -c 'cat>/tmp/fix_package.sh'
vagrant ssh -c 'sudo sh /tmp/fix_package.sh'
$scriptdir/package_vm.sh $boxname $boxfilename
