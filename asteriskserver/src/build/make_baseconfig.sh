#!/usr/bin/env bash
# bootstrap centos6_32_baseconfig from centos6_32_baseinstall
# this does system configuration

set -x

/bin/cp -f /vagrant/src/sshd_config /etc/ssh/sshd_config
service sshd restart

/etc/init.d/iptables stop
/vagrant/src/iptables.sh
service iptables save
service iptables restart

