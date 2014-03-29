#!/usr/bin/env bash
# bootstrap centos6_32_baseconfig from centos6_32_baseinstall
# this does system configuration

set -x

# add a futel user to log in as, and for vagrant commands
useradd -m futel
mkdir /home/futel/.ssh
/bin/cp -f /vagrant/src/id_rsa.pub /home/futel/.ssh/authorized_keys
chown -R futel:futel /home/futel/.ssh
chmod -R go-rwx /home/futel/.ssh
usermod -a -G wheel futel

# allow nopasswd sudo for futel user
/bin/cp -f /vagrant/src/futel /etc/sudoers.d/futel
chmod go-rwx /etc/sudoers.d/futel

/bin/cp -f /vagrant/src/sshd_config /etc/ssh/sshd_config
service sshd restart