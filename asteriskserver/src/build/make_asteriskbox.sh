#!/usr/bin/env bash
# bootstrap from centos6_32_baseinstall

set -x # print commands as executed
BUILDDIR=/vagrant/src/build

conf_version=$1

# # Are we in a virtualbox?  Should just have vagrant send this as an arg.
# # Wasn't able to pass the value of config.vm.provider, but could just set it
# # manually.
# virtualbox=false
# dmidecode | grep -q 'Product Name:.*VirtualBox' && virtualbox=true

# # XXX if 64bit, --libdir=/usr/lib64, but must be root to install?
# #     maybe we can put libdir within the prefix?
# if [ $virtualbox = true ]; then
#     # virtualbox on ubuntu thinkpad
#     # http://gentoo-what-did-you-say.blogspot.com/2011/07/finding-cpu-flags-using-gcc.html
#     CFLAGS=-march=core2
# fi

mkdir /opt/asterisk/var/log/asterisk/old
chown asterisk: /opt/asterisk/var/log/asterisk/old
cp -f /vagrant/src/logrotate/logrotate.d/asterisk /etc/logrotate.d/asterisk

service asterisk restart

cp -rf /vagrant/src/logwatch/* /etc/logwatch/
cp -f /vagrant/src/logwatch/conf/logwatch.conf /usr/share/logwatch/default.conf/logwatch.conf
# write the config files that are local or have secrets
cp -f /vagrant/conf/logwatch.conf.$conf_version /etc/logwatch/conf/logwatch.conf

# install asterisk event listener
mkdir -p /opt/futel/src
cp /vagrant/src/eventlistener.py /opt/futel/src
# write the config files that are local or have secrets
cp /vagrant/conf/eventlistenerconf.$conf_version.py /opt/futel/src/eventlistenerconf.py
chown -R asterisk:asterisk /opt/futel

# run eventlistnener in rc.local
# XXX need a real daemon or supervisord, this goes down
echo "su -s /bin/bash nobody -c /opt/futel/src/eventlistener.py" >> /etc/rc.d/rc.local

# run rc.local now
nohup /etc/rc.d/rc.local &

# TODO this will be off by default for now. currently 240MB
#	uncomment for testing or for DO build
#cd /tmp
#git clone https://github.com/lboom/futel-assets
#cd futel-assets/
#cp -rf phonetrips /opt/asterisk/var/lib/asterisk/.
#chown -R asterisk: /opt/asterisk/var/lib/asterisk/phonetrips/
