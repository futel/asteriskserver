#!/usr/bin/env bash

# if not virtualbox:
# XXX add users and access
# XXX uncomment wheel access in /etc/sudoers
# XXX edit /etc/ssh/sshd_config

# XXX kill firewall for now, fix it later?  Not needed anymore?
#     /etc/init.d/iptables stop

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
# XXX install dyndns client if necessary?

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
cd /tmp # can't chown in /vagrant, and this is faster
sudo -u asterisk tar xvf /vagrant/src/asterisk-11-current.tar.gz
cd asterisk-11.5.1
# XXX if 64bit, --libdir=/usr/lib64, but must be root to install?
#     maybe we can put libdir within the prefix?
sudo -u asterisk ./configure --prefix=/opt/asterisk --exec_prefix=/opt/asterisk
# XXX if virtualbox, add CFLAGS=-march=core2
# http://gentoo-what-did-you-say.blogspot.com/2011/07/finding-cpu-flags-using-gcc.html
# XXX we created these files with 'make menuselect' and quitting without
#     selecting or deselecting anything.  We want to pare this down.
# XXX may be broken, make menuselect if so
cp /vagrant/src/menuselect.makeopts .
chown asterisk:asterisk menuselect.makeopts
cp /vagrant/src/menuselect.makedeps .
chown asterisk:asterisk menuselect.makedeps
# XXX if we configured with CFLAGS, edit menuselect.makeopts
#MENUSELECT_CFLAGS=LOADABLE_MODULES 
sudo -u asterisk make

# XXX if we were 64 bit, we must be root to do this because of libdir,
#     do we need to chown back to asterisk in that case?
sudo -u asterisk make install
# XXX want to pare this down
sudo -u asterisk make samples
make config # as root
# XXX make install-logrotate?
# this adds ASTARGS="-U asterisk"
# XXX make sure this works
cp /vagrant/src/safe_asterisk /opt/asterisk/sbin
chown asterisk:asterisk /opt/asterisk/sbin/safe_asterisk

# add the git host key
mkdir /home/asterisk/.ssh
chown asterisk:asterisk /home/asterisk/.ssh
cat /vagrant/src/known_hosts | sudo -u asterisk tee -a /home/asterisk/.ssh/known_hosts
chmod go-rwx /home/asterisk/.ssh

# clone the git repos into the asterisk tree
cd /opt/asterisk
rm -rf etc/asterisk
sudo -u asterisk git clone https://github.com/kra/futel-ceres-opt-asterisk-asterisk.git asterisk
cd /opt/asterisk/var/lib/asterisk
rm -rf agi-bin
sudo -u asterisk git clone https://github.com/lboom/futel-ceres-opt-asterisk-var-lib-asterisk-agi-bin.git agi-bin

# copy vm_futel_users.inc template
cat /vagrant/src/vm_futel_users.inc | sudo -u asterisk tee -a /opt/asterisk/etc/asterisk/vm_futel_users.inc
# XXX this has an XXXX password for the user in there, can we just keep that
#     and make it a dummy mbox?  Else edit password.

# XXX sip.conf:
#     if behind firewall with a DNS name,
#     externhost=<hostname> localnet=<addrs in firewall> nat=force_rport,comedia
#     if virtualbox:
#     externip=<router ip>
#     localnet=10.0.0.0/255.255.255.0
#     localnet=192.168.0.0/255.255.255.0
#     nat=force_rport,comedia
# XXX peform the edits that have secrets:
#     edit sip_callcentric.conf
#     edit extensions_secret.conf
#     secrets should refer to an /opt/futel/etc conf file for easier setup

# XXX sigh, this can be made unnecessary
find . -exec chown asterisk:asterisk {} \;

# XXX will need more ports for iax2 later - asterisk to asterisk
/vagrant/src/iptables.sh
# XXX if on virtualbox, default ssh port for 'vagrant ssh':
#     iptables -A INPUT -p tcp --dport 22 -j ACCEPT
service iptables save

# setup backups
adduser backup
usermod -a -G asterisk backup
sudo -u backup mkdir /home/backup/.ssh
sudo -u backup chmod go-rx /home/backup/.ssh
# XXX copy backup key to backup's ~/.ssh/authorized_keys
# XXX would be better to make backup's shell rsync or something
# XXX backup user can't see /var/log/messages, /etc, /home

# XXX logwatch

# XXX restart asterisk, or reboot
