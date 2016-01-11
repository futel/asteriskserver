#!/bin/sh                                                                       
# make stats from backed up metrics

# HOST=futel-prod.phu73l.net
# DIRNAME=prod
# REMOTEDIR=/opt/asterisk
# KEYFILE=/opt/futel/ssh/id_rsa
# SSHCMD="ssh -o StrictHostKeyChecking=no -i $KEYFILE -p 42422"
# USER=backup
# DATE=`date "+%Y-%m"`

#PRODDIR=/opt/futel/backups/prod
PRODDIR=/tmp/opt/futel/backups/prod
#STATSDIR=/opt/futel/stats/prod
STATSDIR=/tmp/opt/futel/stats/prod

# get latest metrics directory
for lastdir in $PRODDIR/*; do
    true
done

metrics_filenames="$lastdir/opt/asterisk/var/log/asterisk/metrics $lastdir/opt/asterisk/var/log/asterisk/old/metrics*"

# XXX make bindir
./write_stats.py $metrics_filenames $STATSDIR
