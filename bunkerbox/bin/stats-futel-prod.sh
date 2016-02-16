#!/bin/sh                                                                       
# make stats from backed up metrics

BINDIR=/opt/futel/bin
BACKUPSDIR=/opt/futel/backups/prod
METRICSFILE=/opt/futel/stats/prod/metrics.db

# get latest metrics directory
for lastdir in $BACKUPSDIR/*; do
    true
done

metrics_filenames="$lastdir/opt/asterisk/var/log/asterisk/metrics $lastdir/opt/asterisk/var/log/asterisk/old/metrics*"

$BINDIR/write_stats.py $metrics_filenames $METRICSFILE
