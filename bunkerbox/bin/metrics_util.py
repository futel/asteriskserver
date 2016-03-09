#!/usr/bin/env python3
"""
metrics utils
"""
import collections
import datetime
import time
import itertools
import json
import operator
import re
import sys
import sqlite3

_sentinel = object()

events_ignore = [
    'outgoing-by-extension',
    'default-incoming']


# schema:
# CREATE TABLE metrics
# (timestamp, callerid, uniqueid, channel, channel_extension, name)
def line_to_metric(line):
    """Return normalized dict from metric line."""
    # convert line of csv to list
    # sigh, the first field is not quoted eg '2010-09-06 22:38:15,292', and
    # uses the old logging datetime format
    (datestr, timestr, fields) = line.split(' ', 2)
    fields = fields.split(',')
    fields = [field.strip() for field in fields]
    # convert list of k=v to dict
    fields = [field.split('=') for field in fields]
    metric = dict(fields)
    # normalize keys, deserialize values, add derived values
    # would be more rigorous to have a seprate table for derived values
    metric['callerid'] = metric.pop('CALLERID(number)')
    metric['uniqueid'] = metric.pop('UNIQUEID')
    metric['channel'] = metric.pop('CHANNEL')
    # deserialize values
    (timestr, millistr) = timestr.split(',')
    datestr = ' '.join((datestr, timestr))
    timestamp = (
        datetime.datetime.fromtimestamp(
            time.mktime(time.strptime(datestr, '%Y-%m-%d %H:%M:%S'))) +
        datetime.timedelta(milliseconds=int(millistr)))
    metric['timestamp'] = timestamp
    # split ext from eg SIP/668-000002f1 SIP/callcentric-default-000002f3
    (_proto, extension) = metric['channel'].split('/')
    extension = '-'.join(extension.split('-')[:-1])
    metric['channel_extension'] = extension
    return metric

def read_write_metrics(metrics_paths, db_path):
    write_metrics(read_metrics(metrics_paths), db_path)

def write_metrics(metrics, db_path):
    """Replace all metrics at db_path database with given metrics."""
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute('DELETE FROM metrics')
    for metric in metrics:
        c.execute(
            'INSERT INTO metrics '
            '(timestamp, callerid, uniqueid, channel, channel_extension, name) '
            'VALUES (?,?,?,?,?,?)',
            (metric['timestamp'],
             metric['callerid'],
             metric['uniqueid'],
             metric['channel'],
             metric['channel_extension'],
             metric['name']))
    conn.commit()
    conn.close()

def read_metrics(metrics_paths):
    for path in metrics_paths:
        with open(path) as metricfile:
            for line in metricfile:
                yield line_to_metric(line)
