#!/usr/bin/env bash
# bootstrap openvpnbox from centos6_32_baseinstall
# this does system configuration
# with some install steps, ok

set -x

# XXX do we want this the same?
/bin/cp -f /vagrant/src/sshd_config /etc/ssh/sshd_config
service sshd restart

/etc/init.d/iptables stop
/vagrant/src/iptables.sh
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
# can't copy files into /etc/openvpn like normal people? Copy a directory.
#/bin/cp -f /vagrant/src/server.conf /etc/openvpn
#/bin/cp -f /vagrant/conf/ca.crt /etc/openpvn
#/bin/cp -f /vagrant/conf/server.crt /etc/openpvn
#/bin/cp -f /vagrant/conf/server.key /etc/openpvn
#/bin/cp -f /vagrant/conf/dh1024.pem /etc/openpvn
cd /vagrant
mkdir openvpn
cp src/server.conf openvpn
cp conf/ca.crt openvpn
cp conf/server.crt openvpn
cp conf/server.key openvpn
cp conf/dh1024.pem openvpn
mv /etc/openvpn /etc/openvpn-
mv openvpn /etc
/bin/cp -f /vagrant/src/sysctl.conf /etc
# apply sysctl settings
sysctl -p
chkconfig openvpn on
