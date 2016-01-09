#!/usr/bin/env python
"""
metrics utils
"""
import sys
import collections
from datetime import datetime
import re

events_ignore = [
    'outgoing-by-extension',
    'default-incoming']
events_notice = [
    'outgoing-ivr',
    'outgoing-dialtone-wrapper',
    'ring-oskar',
    'incoming-ivr',
    'futel-conf',
    'community-ivr',
    'operator',
    'internal-dialtone-wrapper',
    'ring-r2d2',
    'utilities-ivr',
    'ring-oskar-in',
    'directory-ivr',
    'futel-information',
    'voicemail-ivr',
    'current-time',
    'voicemail-main',
    'incoming-fake-admin-auth',
    'lance-e-pants',
    'next-vm',
    'lib-account-line',
    'voicemail',
    'mayor-vm',
    'info-211',
    'apology-line',
    'admin-auth',
    'add-futel-conf']

def line_to_metric(line):
    # line of csv to list
    fields = line.split(',')
    fields = [field.strip() for field in fields]
    # list of k=v to dict
    metric = {'timestamp':fields.pop(0)}
    fields = [field.split('=') for field in fields]
    metric.update(dict(fields))
    # deserialize values
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

# def filter_sequence(seq, **kwargs):
#     for s in seq:
#         for (k, v) in kwargs.items():
#             if s[k] == v:
#                 yield s

def histogram(metrics, key='name'):
    h_dict = collections.defaultdict(int)
    for m in metrics:
        h_dict[m[key]] += 1
    return h_dict

def _frequent_items(items):
    return list(
        reversed(
            sorted(
                (freq, event) for (event, freq) in items)))

def frequent_events(histogram, num_events=5, events_ignore=events_ignore):
    """
    Return most frequent (event, frequency) tuples from histogram for events
    not in events_ignore.
    """
    items = (
        (event, freq) for (event, freq) in histogram.items()
        if event not in events_ignore)
    items = _frequent_items(items)
    items = items[0:num_events]
    return [(event, freq) for (freq, event) in items]

def frequency_of_events(histogram, events_notice=events_notice):
    """
    Return (event, frequency) tuples from histogram for events
    in events_notice.
    """
    items = (
        (event, freq) for (event, freq) in histogram.items()
        if event in events_notice)
    items = _frequent_items(items)
    return [(event, freq) for (freq, event) in items]

if __name__ == "__main__":
    filenames = sys.argv[1:]
    metrics = filenames_to_metrics(filenames)
    metrics = [m for m in metrics]

    dates = sorted(m['timestamp'] for m in metrics)
    print 'start date', dates[0]
    print 'end date', dates[-1]
    print

    hist = histogram(metrics)
    items = [(v, k) for (k, v) in hist.items()]
    #print [x for x in reversed(sorted(items))]
    print frequent_events(hist)
    print frequency_of_events(hist)

    #metrics = filter_sequence(metrics, name='outgoing-dialtone-wrapper')
    #for m in metrics:
    #    print m

