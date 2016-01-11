#!/bin/sh                                                                       
# back up futel directories of interest with rsync
# assume we have a futel user and group locally

HOST=futel-prod.phu73l.net
DIRNAME=prod

BINDIR=/opt/futel/bin
REMOTEDIR=/opt/asterisk
KEYFILE=/opt/futel/ssh/id_rsa
SSHCMD="ssh -o StrictHostKeyChecking=no -i $KEYFILE -p 42422"
USER=backup
DATE=`date "+%Y-%m"`
LOCALDIR=/opt/futel/backups/$DIRNAME/$DATE

# sync backups
rsync -avcR --delete --usermap=asterisk:futel --groupmap asterisk:futel -e "$SSHCMD" $USER@$HOST:$REMOTEDIR $LOCALDIR
# write stats from backups
$BINDIR/stats-futel-prod.sh 
