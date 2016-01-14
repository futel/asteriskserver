#!/usr/bin/env bash
# local script to promote stage to prod
# assume futel-prod.phu73l.net address has propagated here

set -x

stage_ip=$1

SCP="scp -P42422 -o StrictHostKeyChecking=no -i conf/id_rsa"
SSH="ssh -p42422 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -t -i conf/id_rsa"

# reset local stash
rm -rf tmp/stage
[ -d tmp/stage ] || mkdir -p tmp/stage

# reset stash on stage
$SSH futel@$stage_ip "sudo rm -rf /tmp/stage"
$SSH futel@$stage_ip "mkdir /tmp/stage"

$SSH futel@$stage_ip "sudo service asterisk stop"

# copy prod to local stash
# voicemail
$SCP futel@futel-prod.phu73l.net:/opt/asterisk/etc/asterisk/vm_futel_users.inc tmp/stage
$SCP -r futel@futel-prod.phu73l.net:/opt/asterisk/var/spool/asterisk/voicemail/default tmp/stage
# logs
$SCP -r futel@futel-prod.phu73l.net:/opt/asterisk/var/log/asterisk tmp/stage

# clear stage deploy
# voicemail
$SSH futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/etc/asterisk/vm_futel_users.inc /opt/asterisk/etc/asterisk/vm_futel_users.inc-"
$SSH futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/spool/asterisk/voicemail/default /opt/asterisk/var/spool/asterisk/voicemail/default-"
# logs
$SSH futel@$stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk /opt/asterisk/var/log/asterisk-"

# copy local stash to stage stash
# voicemail
$SCP tmp/stage/vm_futel_users.inc futel@$stage_ip:/tmp/stage
$SCP -r tmp/stage/default futel@$stage_ip:/tmp/stage
# logs
$SCP -r tmp/stage/asterisk futel@$stage_ip:/tmp/stage

$SSH futel@$stage_ip "sudo chown -R asterisk:asterisk /tmp/stage"

# copy stage stash to stage deploy
# voicemail
$SSH futel@$stage_ip "sudo -u asterisk cp /tmp/stage/vm_futel_users.inc /opt/asterisk/etc/asterisk/vm_futel_users.inc"
$SSH futel@$stage_ip "sudo -u asterisk cp -r /tmp/stage/default /opt/asterisk/var/spool/asterisk/voicemail"
# logs
$SSH futel@$stage_ip "sudo -u asterisk cp -r /tmp/stage/asterisk/* /opt/asterisk/var/log/asterisk"

#$SSH futel@$stage_ip "sudo service asterisk start"
$SSH futel@$stage_ip "sudo reboot"
