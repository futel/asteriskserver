#!/usr/bin/env bash
# bootstrap openvpnbox from centos6_32_baseinstall
# this does system configuration
# with some install steps, ok

set -x

# XXX do we want this the same?
/bin/cp -f /vagrant/src/sshd_config /etc/ssh/sshd_config
service sshd restart

/etc/init.d/iptables stop
/vagrant/vpnbox/src/iptables.sh
service iptables save
service iptables restart

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

rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum install -y openvpn
/bin/cp -f /vagrant/vpnbox/src/server.conf /etc/openvpn
/bin/cp -f /vagrant/vpnbox/conf/server.key /etc/openpvn
/bin/cp -f /vagrant/vpnbox/src/sysctl.conf /etc
# apply sysctl settings
sysctl -p
chkconfig openvpn on
