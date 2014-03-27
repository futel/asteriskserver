#!/usr/bin/env bash
# bootstrap from centos6_32_baseinstall

set -x # print commands as executed

# Are we in a virtualbox?  Should just have vagrant send this as an arg.
# Wasn't able to pass the value of config.vm.provider, but could just set it
# manually.
virtualbox=false
dmidecode | grep -q 'Product Name:.*VirtualBox' && virtualbox=true

# XXX set this up if not virtualbox
# XXX will need more ports for iax2 later - asterisk to asterisk
#/vagrant/src/iptables.sh
# XXX if on virtualbox, default ssh port for 'vagrant ssh':
#     iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#service iptables save
# XXX remove vagrant stuff like users

# XXX kill firewall for now because we didn't update the ssh port
# XXX also need to disable service for when we reboot
/etc/init.d/iptables stop

# if not virtualbox:
# XXX add users and access
# XXX uncomment wheel access in /etc/sudoers
# XXX edit /etc/ssh/sshd_config

# add non-root user for asterisk
useradd -m asterisk -s /bin/false

# XXX install dyndns client if necessary?

# install pyst
cd /tmp
tar xvf /vagrant/src/pyst-0.6.50.tar.gz
cd pyst-0.6.50
python setup.py install --prefix=/usr/local
ln -s /usr/local/lib/python2.6/site-packages/asterisk/ /usr/lib/python2.6/site-packages/

# setup festival server
# XXX need a real daemon, this goes down
# XXX this is not exactly safe
echo "su -s /bin/bash nobody -c '/usr/bin/festival --server &'" >> /etc/rc.d/rc.local
# and run it now
/etc/rc.d/rc.local

# build, install asterisk from source
mkdir /opt/asterisk
chown asterisk:asterisk /opt/asterisk
cd /tmp
sudo -u asterisk tar xvf /vagrant/src/asterisk-11-current.tar.gz
cd asterisk-11.5.1

# # XXX if 64bit, --libdir=/usr/lib64, but must be root to install?
# #     maybe we can put libdir within the prefix?
# if [ $virtualbox = true ]; then
#     # virtualbox on ubuntu thinkpad
#     # http://gentoo-what-did-you-say.blogspot.com/2011/07/finding-cpu-flags-using-gcc.html
#     CFLAGS=-march=core2
# fi
sudo -u asterisk ./configure --prefix=/opt/asterisk --exec_prefix=/opt/asterisk #CFLAGS=$CFLAGS

# do some things that make menuselect does
# XXX what a crock!  Some of these may be superstition.
sudo -u asterisk make menuselect.makeopts menuselect-tree
sudo -u asterisk make menuselect/cmenuselect menuselect/nmenuselect menuselect/gmenuselect
sudo -u asterisk rm -f channels/h323/Makefile.ast main/asterisk

# create files normally done with make menuselect
# XXX need to pare these files down
#     alternative, create a smaller menuselect file starting with:
#     sudo -u asterisk menuselect/menuselect --enable-all menuselect.makeopts
# the virtualbox version is used for virtualbox and digital ocean
/bin/cp -f /vagrant/src/menuselect.makeopts.virtualbox ./menuselect.makeopts
# virtualbox, digital ocean, and probably all virtual providers disbable native
# optimizations
sudo -u asterisk menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts
# the ceres version is used for... ceres
#/bin/cp -f /vagrant/src/menuselect.makeopts.ceres ./menuselect.makeopts
/bin/cp -f /vagrant/src/menuselect.makedeps ./menuselect.makedeps
/bin/cp -f /vagrant/src/menuselect-tree ./menuselect-tree

sudo -u asterisk make

# XXX if we were 64 bit, we must be root to do this because of libdir?
#     do we need to chown back to asterisk in that case?
sudo -u asterisk make install
# XXX want to pare this down
sudo -u asterisk make samples

make config # as root
# XXX make install-logrotate?
# this adds ASTARGS="-U asterisk"
sudo -u asterisk cp /vagrant/src/safe_asterisk /opt/asterisk/sbin
chown asterisk:asterisk /opt/asterisk/sbin/safe_asterisk

# add the git host key so we can clone
mkdir /home/asterisk/.ssh
chown asterisk:asterisk /home/asterisk/.ssh
cat /vagrant/src/known_hosts | sudo -u asterisk tee -a /home/asterisk/.ssh/known_hosts
chmod go-rwx /home/asterisk/.ssh

# clone the git repos into the asterisk tree
cd /opt/asterisk
rm -rf etc/asterisk
sudo -u asterisk git clone https://github.com/kra/futel-ceres-opt-asterisk-asterisk.git etc/asterisk
rm -rf var/lib/asterisk/agi-bin
sudo -u asterisk git clone https://github.com/lboom/futel-ceres-opt-asterisk-var-lib-asterisk-agi-bin.git var/lib/asterisk/agi-bin
sudo -u asterisk git clone https://github.com/kra/futel-opt-asterisk-var-lib-asterisk-sounds-futel.git var/lib/asterisk/sounds/futel
# copy vm_futel_users.inc template
cat /vagrant/src/vm_futel_users.inc | sudo -u asterisk tee /opt/asterisk/etc/asterisk/vm_futel_users.inc
# XXX this has an XXXX password for the user in there, can we just keep that
#     and make it a dummy mbox?  Else edit password.

# write the files that have secrets
# XXX secrets should refer to an /opt/futel/etc conf file for easier setup
cat /vagrant/sip_local.conf | sudo -u asterisk tee /opt/asterisk/etc/asterisk/sip_local.conf
cat /vagrant/sip_callcentric.conf | sudo -u asterisk tee /opt/asterisk/etc/asterisk/sip_callcentric.conf
cat /vagrant/extensions_secret.conf | sudo -u asterisk tee /opt/asterisk/etc/asterisk/extensions_secret.conf

# XXX sigh, this can be made unnecessary
find /opt/asterisk -exec chown asterisk:asterisk {} \;

# XXX logwatch

service asterisk stop
service asterisk start

# setup backups
adduser backup
usermod -a -G asterisk backup
sudo -u backup mkdir /home/backup/.ssh
sudo -u backup chmod go-rx /home/backup/.ssh
# if not a devbox:
# XXX copy backup key to backup's ~/.ssh/authorized_keys
# XXX would be better to make backup's shell rsync or something
# XXX backup user can't see /var/log/messages, /etc, /home

# XXX Better take out the vagrant defaults or start with a different base!
#     vagrant user and keys, ssh port, ssh config? what else?
#     Probably better to start with a less-vagranty base box?
