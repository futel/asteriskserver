#!/bin/sh                                                                       
# back up futel directories of interest with rsync                              

HOST=futel-prod.phu73l.net
DIRNAME=prod

REMOTEDIR=/opt/asterisk
KEYFILE=/opt/futel/ssh/id_rsa
SSHCMD="ssh -o StrictHostKeyChecking=no -i $KEYFILE -p 42422"
USER=backup
DATE=`date "+%Y-%m"`
LOCALDIR=/opt/futel/backups/$DIRNAME/$DATE

rsync -avcR --delete -e "$SSHCMD" $USER@$HOST:$REMOTEDIR $LOCALDIR
