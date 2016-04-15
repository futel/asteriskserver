#!/usr/bin/env bash
# local script to make asteriskbox_stage from baseconfig_stage

set -x

do_ip=$1
conf_version=$2

scp -F src/ssh_config -r . $do_ip:/tmp/vagrant
ssh -F src/ssh_config -t $do_ip "sudo ln -sf /tmp/vagrant /vagrant"

ssh -F src/ssh_config -t $do_ip "sudo /vagrant/src/build/make_asteriskbox.sh $conf_version"

ssh -F src/ssh_config -t $do_ip "sudo rm -rf /tmp/vagrant/conf"
ssh -F src/ssh_config -t $do_ip "sudo halt now"

