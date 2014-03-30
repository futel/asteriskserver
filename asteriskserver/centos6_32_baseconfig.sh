#!/usr/bin/env bash
# bootstrap centos6_32_baseconfig from centos6_32_baseinstall
# this does system configuration

set -x

/bin/cp -f /vagrant/src/sshd_config /etc/ssh/sshd_config
service sshd restart

# XXX will need more ports for iax2 later - asterisk to asterisk
/etc/init.d/iptables stop
/vagrant/src/iptables.sh
service iptables save
service iptables restart

# if not virtualbox:
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

# add non-root user for asterisk
useradd -m asterisk -s /bin/false

# add backup user
adduser backup
usermod -a -G asterisk backup
sudo -u backup mkdir /home/backup/.ssh
sudo -u backup chmod go-rx /home/backup/.ssh
# XXX add backup user's key on server to local backup's ~/.ssh/authorized_keys
# XXX would be better to make backup's shell rsync or something
# XXX backup user can't see /var/log/messages, /etc, /home
