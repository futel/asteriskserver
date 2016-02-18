#!/usr/bin/env python3
"""
metrics utils
"""
import collections
import datetime
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


def line_to_metric(line):
    """ Return dict from metric line. """
    # convert line of csv to list
    # sigh, the first field is not quoted
    (date, time, fields) = line.split(' ', 2)
    metric = {'timestamp':" ".join((date, time))}
    fields = fields.split(',')
    fields = [field.strip() for field in fields]
    # list of k=v to dict
    fields = [field.split('=') for field in fields]
    metric.update(dict(fields))
    # deserialize values
    metric['timestamp'] = datetime.datetime(
        *map(int, re.split('[^\d]', metric['timestamp'])[:-1]))
    return metric

def read_write_metrics(metrics_paths, db_path):
    write_metrics(read_metrics(metrics_paths), db_path)

def write_metrics(metrics, db_path):
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute('DELETE FROM metrics')
    for metric in metrics:
        c.execute(
            'INSERT INTO metrics '
            '(timestamp, callerid, uniqueid, channel, name) '
            'VALUES (datetime(?),?,?,?,?)',
            (metric['timestamp'],
             metric['CALLERID(number)'],
             metric['UNIQUEID'],
             metric['CHANNEL'],
             metric['name']))
    conn.commit()
    conn.close()

def read_metrics(metrics_paths):
    for path in metrics_paths:
        with open(path) as metricfile:
            for line in metricfile:
                yield line_to_metric(line)
