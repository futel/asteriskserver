#!/usr/bin/env bash
# local script to promote stage to prod
# assume futel-prod.phu73l.net address has propagated here

set -x

stage_ip=$1

rm -rf tmp/*

ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo service asterisk stop"

# XXX should probably stop prod before copying assets from it

[ -d tmp/stage ] || mkdir tmp/stage

# voicemail
scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa futel@futel-prod.phu73l.net:/opt/asterisk/etc/asterisk/vm_futel_users.inc tmp/stage
scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa -r futel@futel-prod.phu73l.net:/opt/asterisk/var/spool/asterisk/voicemail/default tmp/stage
# logs
scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa -r futel@futel-prod.phu73l.net:/opt/asterisk/var/log/asterisk tmp/stage

# voicemail
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/etc/asterisk/vm_futel_users.inc /opt/asterisk/etc/asterisk/vm_futel_users.inc-"
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/spool/asterisk/voicemail/default /opt/asterisk/var/spool/asterisk/voicemail/default-"
# logs
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk /opt/asterisk/var/log/asterisk-"

ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "mkdir /tmp/stage"

# voicemail
scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa tmp/stage/vm_futel_users.inc futel@$stage_ip:/tmp/stage
scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa -r tmp/stage/default futel@$stage_ip:/tmp/stage
# logs
scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa -r tmp/stage/asterisk futel@$stage_ip:/tmp/stage

ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo chown -R asterisk:asterisk /tmp/stage"

# voicemail
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk cp /tmp/stage/vm_futel_users.inc /opt/asterisk/etc/asterisk/vm_futel_users.inc"
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk cp -r /tmp/stage/default /opt/asterisk/var/spool/asterisk/voicemail"
# logs
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo -u asterisk cp -r /tmp/stage/asterisk /opt/asterisk/var/log/asterisk"

#ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo service asterisk start"
ssh -p42422 -o StrictHostKeyChecking=no -t -i conf/id_rsa futel@$stage_ip "sudo reboot"
