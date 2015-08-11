#!/usr/bin/env bash
# local script to make baseconfig_stage from baseinstall_stage

set -x

do_ip=$1

scp -o StrictHostKeyChecking=no -r . root@$do_ip:/tmp/vagrant
ssh -o StrictHostKeyChecking=no -t root@$do_ip "sudo ln -sf /tmp/vagrant /vagrant"

ssh -o StrictHostKeyChecking=no root@$do_ip /vagrant/src/build/make_baseconfig.sh

# XXX let futel user read /tmp/vagrant
