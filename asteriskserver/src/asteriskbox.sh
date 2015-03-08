#!/usr/bin/env bash
# local script to make asteriskbox_stage from baseconfig_stage

set -x

do_ip=$1
conf_version=$2

scp -o StrictHostKeyChecking=no -i conf/id_rsa -r . futel@$do_ip:/tmp/vagrant
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo ln -s /tmp/vagrant /vagrant"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo /vagrant/src/build/make_asteriskbox.sh $conf_version"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo rm -rf /vagrant /tmp/vagrant"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo halt now"
