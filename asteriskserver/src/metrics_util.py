#!/usr/bin/env python
"""
metrics utils
"""
import sys
import collections
from datetime import datetime
import re

def line_to_metric(line):
    fields = line.split(',')
    fields = [field.strip() for field in fields]
    metric = {'timestamp':fields.pop(0)}
    fields = [field.split('=') for field in fields]
    metric.update(dict(fields))
    # deserialize
    metric['timestamp'] = datetime(
        *map(int, re.split('[^\d]', metric['timestamp'])[:-1]))
    return metric

def file_to_metrics(metricfile):
    return [line_to_metric(line) for line  in metricfile]

def filenames_to_metrics(filenames):
    for filename in filenames:
        with open(filename) as metricfile:
            for line in metricfile:
                yield line_to_metric(line)

def filter_sequence(seq, **kwargs):
    for s in seq:
        for (k, v) in kwargs.items():
            if s[k] == v:
                yield s

def histogram(metrics, key):
    h_dict = collections.defaultdict(int)
    for m in metrics:
        h_dict[m[key]] += 1
    return h_dict

if __name__ == "__main__":
    filenames = sys.argv[1:]
    metrics = filenames_to_metrics(filenames)
    metrics = [m for m in metrics]

    dates = sorted(m['timestamp'] for m in metrics)
    print 'start date', dates[0]
    print 'end date', dates[-1]
    print

    hist = histogram(metrics, 'name')
    items = [(v, k) for (k, v) in hist.items()]
    print [x for x in reversed(sorted(items))]

    #metrics = filter_sequence(metrics, name='outgoing-dialtone-wrapper')
    #for m in metrics:
    #    print m

