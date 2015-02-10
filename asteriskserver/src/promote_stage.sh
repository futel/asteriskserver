#!/usr/bin/env bash
# local script to promote stage to prod
# assume futel-prod.phu73l.net address has propagated here

set -x

stage_ip=$1

rm -rf tmp/*

ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo service asterisk stop"

# XXX should probably stop prod before copying assets from it

# voicemail
scp -o StrictHostKeyChecking=no -i conf/id_rsa futel@futel-prod.phu73l.net:/opt/asterisk/etc/asterisk/vm_futel_users.inc tmp
scp -o StrictHostKeyChecking=no -i conf/id_rsa -r futel@futel-prod.phu73l.net:/opt/asterisk/var/spool/asterisk/voicemail/default tmp
# logs
scp -o StrictHostKeyChecking=no -i conf/id_rsa -r futel@futel-prod.phu73l.net:/opt/asterisk/var/log/asterisk tmp

# voicemail
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/etc/asterisk/vm_futel_users.inc /opt/asterisk/etc/asterisk/vm_futel_users.inc-"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/spool/asterisk/voicemail/default /opt/asterisk/var/spool/asterisk/voicemail/default-"
# logs
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk /opt/asterisk/var/log/asterisk-"

# voicemail
scp -o StrictHostKeyChecking=no -i conf/id_rsa tmp/vm_futel_users.inc futel@$stage_ip:/tmp
scp -o StrictHostKeyChecking=no -i conf/id_rsa -r tmp/default futel@$stage_ip:/tmp
# logs
scp -o StrictHostKeyChecking=no -i conf/id_rsa -r tmp/asterisk futel@$stage_ip:/tmp

# voicemail
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk cp /tmp/vm_futel_users.inc /opt/asterisk/etc/asterisk/vm_futel_users.inc"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk cp -r /tmp/default /opt/asterisk/var/spool/asterisk/voicemail"
# logs
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk cp -r /tmp/asterisk /opt/asterisk/var/log/asterisk"

#ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo service asterisk start"
ssh -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo reboot"
