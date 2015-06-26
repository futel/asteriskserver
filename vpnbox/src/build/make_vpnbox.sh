#!/usr/bin/env bash
# bootstrap openvpnbox from centos6_32_baseconfig
# this does system configuration
# with some install steps, ok

set -x

/etc/init.d/iptables stop
/vagrant/src/iptables.sh
service iptables save
service iptables restart

# add crontab with logwatch job
cp -f /vagrant/src/crontab /etc/crontab

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

# set up logrotate for openvpn
# this PROBABLY relies on openvpn
mkdir /var/log/openvpn_old
cp -f src/logrotate/openvpn /etc/logrotate.d/openvpn

# set up logwatch
cp -rf /vagrant/src/logwatch/* /etc/logwatch/
cp -f /vagrant/conf/logwatch.conf /usr/share/logwatch/default.conf/logwatch.conf

# apply sysctl settings
sysctl -p
chkconfig openvpn on

# openvpn does not seem to start until reboot
halt now
