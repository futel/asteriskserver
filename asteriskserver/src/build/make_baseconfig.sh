#!/usr/bin/env bash
# bootstrap centos6_32_baseconfig from centos6_32_baseinstall
# this does system configuration

set -x

/bin/cp -f /vagrant/src/sshd_config /etc/ssh/sshd_config
service sshd restart

/etc/init.d/iptables stop
/vagrant/src/iptables.sh
service iptables save
service iptables restart

# add futel user for provisioning and interactive shell
useradd -m futel
mkdir /home/futel/.ssh
/bin/cp -f /vagrant/src/id_rsa.pub /home/futel/.ssh/authorized_keys
chown -R futel:futel /home/futel/.ssh
chmod -R go-rwx /home/futel/.ssh
usermod -a -G wheel futel
usermod -a -G asterisk futel

# allow nopasswd sudo for futel user
/bin/cp -f /vagrant/src/futel /etc/sudoers.d/futel
chmod go-rwx /etc/sudoers.d/futel

# add non-root user for asterisk
useradd -m asterisk -s /bin/false

# add backup user
adduser backup
usermod -a -G asterisk backup
mkdir /home/backup/.ssh
cp /vagrant/src/backup_id_rsa.pub /home/backup/.ssh/authorized_keys
chown -R backup:asterisk /home/backup/.ssh
chmod -R go-rwx /home/backup/.ssh
# add backup task to eurydice
# would be better to make backup's shell rsync or something
# backup user can't see /var/log/messages, /etc, /home

# configure logwatch
cp -rf /vagrant/src/logwatch/* /etc/logwatch/
cp -f /vagrant/conf/logwatch.conf /usr/share/logwatch/default.conf/logwatch.conf

# configure postfix relay
cp -f /vagrant/conf/sasl_passwd /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
cp -f /vagrant/src/postfix/main.cf /etc/postfix/main.cf
service postfix restart

# configure cron for noon logwatch reports
cp -f /vagrant/src/crontab /etc/crontab

# set correct timezone in /etc/localtime
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/PST8PDT /etc/localtime
