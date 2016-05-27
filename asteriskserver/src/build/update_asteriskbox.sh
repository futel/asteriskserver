#!/usr/bin/env bash
# install asterisk config

set -x # print commands as executed

conf_version=$1

# copy asterisk conf into the asterisk tree
rm -rf /opt/asterisk/etc/asterisk
cp -r /vagrant/src/etc/asterisk /opt/asterisk/etc/asterisk

# copy asterisk scripts into the asterisk tree
rm -rf /opt/asterisk/var/lib/asterisk/agi-bin
cp -r /vagrant/src/var/lib/asterisk/agi-bin /opt/asterisk/var/lib/asterisk/agi-bin

# copy asterisk sounds into the asterisk tree
# statements
rm -rf /opt/asterisk/var/lib/asterisk/sounds/futel
cp -r /vagrant/src/var/lib/asterisk/sounds/futel /opt/asterisk/var/lib/asterisk/sounds/futel
# confbridge menu
rm -rf /opt/asterisk/var/lib/asterisk/sounds/en/futelconf
cp -r /vagrant/src/var/lib/asterisk/sounds/en/futelconf /opt/asterisk/var/lib/asterisk/sounds/en/futelconf
# hold music
rm -rf /opt/asterisk/var/lib/asterisk/moh/hold
cp -r /vagrant/src/var/lib/asterisk/moh/hold /opt/asterisk/var/lib/asterisk/moh/hold
# sweet operator hold music
rm -rf /opt/asterisk/var/lib/asterisk/moh/operator
cp -r /vagrant/src/var/lib/asterisk/moh/operator /opt/asterisk/var/lib/asterisk/moh/operator

# write the config files that are local or have secrets
cp /vagrant/conf/sip_callcentric.conf.$conf_version /vagrant/conf/sip_callcentric.conf

cp /vagrant/conf/sip_callcentric.conf /opt/asterisk/etc/asterisk/sip_callcentric.conf
cp /vagrant/conf/sip_secret.conf /opt/asterisk/etc/asterisk/sip_secret.conf
cp /vagrant/conf/extensions_secret.conf /opt/asterisk/etc/asterisk/extensions_secret.conf
cp /vagrant/conf/followme_secret.conf /opt/asterisk/etc/asterisk/followme_secret.conf
cp /vagrant/conf/blocklist.yaml /opt/asterisk/etc/asterisk/blocklist.yaml
cp /vagrant/conf/manager.conf /opt/asterisk/etc/asterisk/manager.conf

# fix up issues due to our janky install locallly as root deployment
chown -R asterisk:asterisk /opt/asterisk
# are these necessary?
chmod -R a+r /opt/asterisk
chmod -R a+x /opt/asterisk
