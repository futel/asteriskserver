#!/usr/bin/env bash
# bootstrap centos6_32_baseinstall from test_32
# this does all the package downloading and installing
# we probably want to store these locally to reduce net and bootstrap time

set -x

yum -y groupremove "FCoE Storage Client"
yum -y groupremove "iSCSI Storage Client"
yum -y groupremove "Network file system client"
yum -y groupremove "Storage Availability Tools"
yum -y remove audit rpcbind selinux-policy selinux-policy-targeted

yum -y install man
yum -y install vim-enhanced gcc gcc-c++ make automake libtool autoconf
yum -y install mlocate lynx cvs git subversion strace ltrace wget lsof tcpdump
yum -y install openssh openssh-server openssh-clients
yum -y install openssl-devel
yum -y install ncurses-devel libxml2-devel newt-devel kernel-devel sqlite-devel
yum -y install libuuid-devel
yum -y install festival # if running festival locally

yum -y update

# install epel
# why do we need this again?
# rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
