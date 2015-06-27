#!/usr/bin/env bash
# local script to make vpnbox_stage from baseinstall_stage

set -x

do_ip=$1

scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa -r . futel@$do_ip:/tmp/vagrant
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo ln -s /tmp/vagrant /vagrant"

ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo /vagrant/src/build/make_vpnbox.sh"

ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo rm -rf /vagrant /tmp/vagrant"

