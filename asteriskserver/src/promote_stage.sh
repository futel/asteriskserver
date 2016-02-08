#!/usr/bin/env bash
# local script to promote stage to prod
# assume futel-prod.phu73l.net address has propagated here

set -x

stage_ip=$1

prod_ip=futel-prod.phu73l.net

SCP="scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa"
SSH="ssh -p42422 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -t -i conf/id_rsa"

# reset local stash
rm -rf tmp/stage
[ -d tmp/stage ] || mkdir -p tmp/stage

# reset stash on stage
$SSH futel@$stage_ip "sudo rm -rf /tmp/stage"
$SSH futel@$stage_ip "mkdir /tmp/stage"
$SSH futel@$stage_ip "mkdir /tmp/stage/backup"
$SSH futel@$stage_ip "sudo chown -R asterisk:asterisk /tmp/stage"

$SSH futel@$stage_ip "sudo service asterisk stop"

# copy prod to local stash
# voicemail
$SCP futel@$prod_ip:/opt/asterisk/etc/asterisk/vm_futel_users.inc tmp/stage
$SCP -r futel@$prod_ip:/opt/asterisk/var/spool/asterisk/voicemail/default tmp/stage
# logs
$SCP -r futel@$prod_ip:/opt/asterisk/var/log/asterisk/messages tmp/stage
$SCP -r futel@$prod_ip:/opt/asterisk/var/log/asterisk/metrics tmp/stage
$SCP -r futel@$prod_ip:/opt/asterisk/var/log/asterisk/old tmp/stage

# clear stage deploy
# voicemail
$SSH futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/etc/asterisk/vm_futel_users.inc /tmp/stage/backup"
$SSH futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/spool/asterisk/voicemail/default /tmp/stage/backup"
# logs
$SSH futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk/messages /tmp/stage/backup"
$SSH futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk/metrics /tmp/stage/backup"
$SSH futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk/old /tmp/stage/backup"

# copy local stash to stage stash
# voicemail
$SCP tmp/stage/vm_futel_users.inc futel@$stage_ip:/tmp/stage
$SCP -r tmp/stage/default futel@$stage_ip:/tmp/stage
# logs
$SCP -r tmp/stage/messages futel@$stage_ip:/tmp/stage
$SCP -r tmp/stage/metrics futel@$stage_ip:/tmp/stage
$SCP -r tmp/stage/old futel@$stage_ip:/tmp/stage

$SSH futel@$stage_ip "sudo chown -R asterisk:asterisk /tmp/stage"

# copy stage stash to stage deploy
# voicemail
$SSH futel@$stage_ip "sudo -u asterisk cp /tmp/stage/vm_futel_users.inc /opt/asterisk/etc/asterisk/vm_futel_users.inc"
$SSH futel@$stage_ip "sudo -u asterisk cp -r /tmp/stage/default /opt/asterisk/var/spool/asterisk/voicemail"
# logs
$SSH futel@$stage_ip "sudo -u asterisk cp /tmp/stage/messages /opt/asterisk/var/log/asterisk/messages"
$SSH futel@$stage_ip "sudo -u asterisk cp /tmp/stage/metrics /opt/asterisk/var/log/asterisk/metrics"
$SSH futel@$stage_ip "sudo -u asterisk cp -r /tmp/stage/old /opt/asterisk/var/log/asterisk/old"

#$SSH futel@$stage_ip "sudo service asterisk start"
$SSH futel@$stage_ip "sudo reboot"
