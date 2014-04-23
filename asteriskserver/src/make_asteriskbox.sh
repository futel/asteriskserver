#!/usr/bin/env bash
# local script to make baseconfig from test_32

set -x

do_ip=$1

scp -o StrictHostKeyChecking=no -i conf/id_rsa -r . futel@$do_ip:/tmp/vagrant
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo ln -s /tmp/vagrant /vagrant"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo cp /vagrant/conf/sip_local.conf.prod /vagrant/conf/sip_local.conf"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo cp /vagrant/conf/sip_callcentric.conf.prod /vagrant/conf/sip_callcentric.conf"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo /vagrant/src/bootstrap.sh"
# XXX need to service asterisk stop/start again?
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo rm -rf /tmp/src /tmp/conf"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$do_ip "sudo halt now"
