#!/usr/bin/env bash

# if not virtualbox:
# XXX add users and access
# XXX uncomment wheel access in /etc/sudoers
# XXX edit /etc/ssh/sshd_config

# XXX kill firewall for now, fix it later?

# setup centos
yum -y groupremove "FCoE Storage Client"
yum -y groupremove "iSCSI Storage Client"
yum -y groupremove "Network file system client"
yum -y groupremove "Storage Availability Tools"
yum -y remove audit rpcbind selinux-policy selinux-policy-targeted
yum -y update

yum -y install man
yum -y install vim-enhanced gcc gcc-g++ make automake libtool autoconf
yum -y install mlocate lynx cvs git subversion strace ltrace wget lsof tcpdump
yum -y install openssh openssh-server openssh-clients
yum -y install openssl-devel
yum -y install ncurses-devel libxml2-devel newt-devel kernel-devel sqlite-devel
yum -y install libuuid-devel
yum -y install festival # if running festival locally

# install epel
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# add non-root user for asterisk
useradd -m asterisk -s /bin/false

# XXX make sure hostname is in /etc/hosts
# XXX install dyndns client?

# install pyst
cd /vagrant/src                 # XXX faster to do this in /tmp or something
tar xvf pyst-0.6.50.tar.gz
cd pyst-0.6.50
python setup.py install --prefix=/usr/local
ln -s /usr/local/lib/python2.6/site-packages/asterisk/ /usr/lib/python2.6/site-packages/

# setup festival server
# XXX this is not exactly safe
echo "su -s /bin/bash nobody -c '/usr/bin/festival --server &'" >> /etc/rc.d/rc.local
# and run it now
/etc/rc.d/rc.local

# build, install asterisk from source
mkdir /opt/asterisk
chown asterisk:asterisk /opt/asterisk
cd /tmp # can't chown in /vagrant
tar xvf /vagrant/src/asterisk-11-current.tar.gz
find asterisk-11.5.1 -exec chown asterisk:asterisk {} \;
cd asterisk-11.5.1
# XXX if 64bit, --libdir=/usr/lib64, but must be root to install?
sudo -u asterisk ./configure --libdir=/usr/lib64 --prefix=/opt/asterisk --sysconfdir=/opt/asterisk --localstatedir=/opt/asterisk
# XXX we created these files with 'make menuselect' and quitting without
#     selecting or deselecting anything.  We want to pare this down.
cp /vagrant/src/menuselect.makeopts .
chown asterisk:asterisk menuselect.makeopts
cp /vagrant/src/menuselect.makedeps .
chown asterisk:asterisk menuselect.makedeps
sudo -u asterisk make
# XXX if we were 64 bit, we must be root to do this, do we need to chown
#     back to asterisk in that case?
sudo -u asterisk make install
# XXX want to pare this down
sudo -u asterisk make samples
make config # as root
# this adds ASTARGS="-U asterisk"
cp /vagrant/src/safe_asterisk /opt/asterisk/sbin
chown asterisk:asterisk /opt/asterisk/sbin/safe_asterisk

# XXX remove the firewall again?

# add the git host key
cat /vagrant/src/known_hosts | sudo -u asterisk tee -a /home/asterisk/.ssh/known_hosts
# clone the git repos into the asterisk tree
cd /opt/asterisk
rm -rf asterisk
sudo -u asterisk git clone https://github.com/kra/futel-ceres-opt-asterisk-asterisk.git asterisk
# XXX on ceres, this was /opt/asterisk/var/lib/asterisk
#     looking at config.log in the build directory, it looks like localstatedir
#     was defined differently there for some reason.  Probably OK.
cd /opt/asterisk/lib/asterisk
rm -rf agi-bin
sudo -u asterisk git clone https://github.com/lboom/futel-ceres-opt-asterisk-var-lib-asterisk-agi-bin.git agi-bin

# copy vm_futel_users.inc template
cat /vagrant/src/vm_futel_users.inc | sudo -u asterisk tee -a /opt/asterisk/asterisk/vm_futel_users.inc

# XXX sip.conf externhost, externip must be customized for each host
# XXX sip.conf localnet, nat probably must be customized for each host
# XXX edit sip_callcentric.conf
# XXX edit extensions_secret.conf
# XXX edit vm_futel_users.inc
#     these should refer to an /opt/futel/etc conf file?

# if we removed any firewall,
# service add iptables
# chkconfig --add iptables
/vagrant/src/iptables.sh
service iptables save

# setup backups
adduser backup
usermod -a -G asterisk backup
sudo -u backup mkdir /home/backup/.ssh
sudo -u backup chmod go-rx /home/backup/.ssh
# XXX copy backup key to backup's ~/.ssh/authorized_keys
# XXX make this for an unpriveleged user on eurydice so we can put it in src
# XXX would be better to make backup's shell rsync or something
# XXX backup user can't see /var/log/messages, /etc, /home

# XXX logwatch

# XXX restart asterisk and whatever net is needed, or reboot
