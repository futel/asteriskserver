#!/usr/bin/env bash
# local script to promote stage to prod
# assume futel-prod.phu73l.net address has propagated here

set -x

stage_ip=$1

prod_ip=futel-prod.phu73l.net

SCP="scp -F src/ssh_config"
SSH="ssh -F src/ssh_config"

# reset local stash
rm -rf tmp/stage
[ -d tmp/stage ] || mkdir -p tmp/stage

# reset stash on stage
$SSH -t $stage_ip "sudo rm -rf /tmp/stage"
$SSH $stage_ip "mkdir /tmp/stage"
$SSH $stage_ip "mkdir /tmp/stage/backup"
$SSH -t $stage_ip "sudo chown -R asterisk:asterisk /tmp/stage"

$SSH -t $stage_ip "sudo service asterisk stop"

# copy prod to local stash
# voicemail
$SCP $prod_ip:/opt/asterisk/etc/asterisk/vm_futel_users.inc tmp/stage
$SCP -r $prod_ip:/opt/asterisk/var/spool/asterisk/voicemail/default tmp/stage
# logs
$SCP -r $prod_ip:/opt/asterisk/var/log/asterisk/messages tmp/stage
$SCP -r $prod_ip:/opt/asterisk/var/log/asterisk/metrics tmp/stage
$SCP -r $prod_ip:/opt/asterisk/var/log/asterisk/old tmp/stage

# clear stage deploy
# voicemail
$SSH -t $stage_ip "sudo -u asterisk mv /opt/asterisk/etc/asterisk/vm_futel_users.inc /tmp/stage/backup"
$SSH -t $stage_ip "sudo -u asterisk mv /opt/asterisk/var/spool/asterisk/voicemail/default /tmp/stage/backup"
# logs
$SSH -t $stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk/messages /tmp/stage/backup"
$SSH -t $stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk/metrics /tmp/stage/backup"
$SSH -t $stage_ip "sudo -u asterisk mv /opt/asterisk/var/log/asterisk/old /tmp/stage/backup"

# copy local stash to stage stash
# voicemail
$SCP tmp/stage/vm_futel_users.inc $stage_ip:/tmp/stage
$SCP -r tmp/stage/default $stage_ip:/tmp/stage
# logs
$SCP -r tmp/stage/messages $stage_ip:/tmp/stage
$SCP -r tmp/stage/metrics $stage_ip:/tmp/stage
$SCP -r tmp/stage/old $stage_ip:/tmp/stage

$SSH -t $stage_ip "sudo chown -R asterisk:asterisk /tmp/stage"

# copy stage stash to stage deploy
# voicemail
$SSH -t $stage_ip "sudo -u asterisk cp /tmp/stage/vm_futel_users.inc /opt/asterisk/etc/asterisk/vm_futel_users.inc"
$SSH -t $stage_ip "sudo -u asterisk cp -r /tmp/stage/default /opt/asterisk/var/spool/asterisk/voicemail"
# logs
$SSH -t $stage_ip "sudo -u asterisk cp /tmp/stage/messages /opt/asterisk/var/log/asterisk/messages"
$SSH -t $stage_ip "sudo -u asterisk cp /tmp/stage/metrics /opt/asterisk/var/log/asterisk/metrics"
$SSH -t $stage_ip "sudo -u asterisk cp -r /tmp/stage/old /opt/asterisk/var/log/asterisk/old"

#$SSH -t $stage_ip "sudo service asterisk start"
$SSH -t $stage_ip "sudo reboot"
