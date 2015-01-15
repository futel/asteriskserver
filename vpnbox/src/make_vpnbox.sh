#!/usr/bin/env bash
# local script to make vpnbox_stage from baseinstall_stage

set -x

do_ip=$1

scp -o StrictHostKeyChecking=no -r . root@$do_ip:/vagrant
ssh -o StrictHostKeyChecking=no root@$do_ip /vagrant/src/vpnbox.sh
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo rm -rf /vagrant"
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo halt now"
