#!/usr/bin/env bash

# XXX add users and access
#     will probably want that for when not virtualbox
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
cd /vagrant/src
tar xvf pyst-0.6.50.tar.gz
cd pyst-0.6.50
python setup.py install --prefix=/usr/local
ln -s /usr/local/lib/python2.6/site-packages/asterisk/ /usr/lib/python2.6/site-packages/

# setup festival server
# XXX this is not exactly safe
echo "su -s /bin/bash nobody -c '/usr/bin/festival --server &'" >> /etc/rc.d/rc.local
# and run it now
/etc/rc.d/rc.local

# XXX build, install asterisk from source
# XXX remove the firewall again?
# XXX clone the git repo into /opt/asterisk/asterisk
# XXX edit sip.conf to match repo
# XXX Setup SIP trunk for an outgoing route with callcentric DID
# XXX edit sip_callcentric.conf
# XXX edit extensions_secret.conf
# XXX perform ops doc actions
# XXX perform voicemail doc actions