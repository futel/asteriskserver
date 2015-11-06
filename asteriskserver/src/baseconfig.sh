#!/usr/bin/env bash
# local script to make baseconfig_stage from baseinstall_stage

set -x

do_ip=$1

scp -o StrictHostKeyChecking=no -r . root@$do_ip:/tmp/vagrant
ssh -o StrictHostKeyChecking=no -t root@$do_ip "sudo ln -sf /tmp/vagrant /vagrant"

ssh -o StrictHostKeyChecking=no root@$do_ip /vagrant/src/build/make_baseconfig.sh
ssh -o StrictHostKeyChecking=no -t root@$do_ip "rm -rf /tmp/vagrant/conf"
# further builds are run by futel user
ssh -o StrictHostKeyChecking=no -t root@$do_ip "chown -R futel:futel /tmp/vagrant"
ssh -o StrictHostKeyChecking=no -t root@$do_ip "halt now"
