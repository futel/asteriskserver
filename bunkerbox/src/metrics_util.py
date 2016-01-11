#!/usr/bin/env python
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

_sentinel = object()

events_ignore = [
    'outgoing-by-extension',
    'default-incoming']
# events_notice = [
#     'outgoing-ivr',
#     'outgoing-dialtone-wrapper',
#     'ring-oskar',
#     'incoming-ivr',
#     'futel-conf',
#     #'community-ivr',
#     'operator',
#     #'internal-dialtone-wrapper',
#     'ring-r2d2',
#     #'utilities-ivr',
#     'ring-oskar-in',
#     #'directory-ivr',
#     #'futel-information',
#     #'voicemail-ivr',
#     #'current-time',
#     #'voicemail-main',
#     #'incoming-fake-admin-auth',
#     #'lance-e-pants',
#     #'next-vm',
#     #'lib-account-line',
#     #'voicemail',
#     #'mayor-vm',
#     #'info-211',
#     #'apology-line',
#     #'admin-auth',
#     #'add-futel-conf'
# ]

def line_to_metric(line):
    """ Return dict from metric line. """
    # line of csv to list
    fields = line.split(',')
    fields = [field.strip() for field in fields]
    # list of k=v to dict
    metric = {'timestamp':fields.pop(0)}
    fields = [field.split('=') for field in fields]
    metric.update(dict(fields))
    # deserialize values
    metric['timestamp'] = datetime.datetime(
        *map(int, re.split('[^\d]', metric['timestamp'])[:-1]))
    return metric

def file_to_metrics(metricfile):
    return [line_to_metric(line) for line  in metricfile]

def filenames_to_metrics(filenames):
    for filename in filenames:
        with open(filename) as metricfile:
            for line in metricfile:
                yield line_to_metric(line)

# def filter_metrics_timestamp(metrics, now=_sentinel, **kwargs):
#     """ Yield metrics with timestamps later than timedelta made with kwargs. """
#     if now is _sentinel:
#         now = datetime.datetime.now()
#     earliest = now - datetime.timedelta(**kwargs)
#     return itertools.ifilter(
#         lambda metric: metric['timestamp'] >= earliest, metrics)

# def filter_sequence(seq, **kwargs):
#     for s in seq:
#         for (k, v) in kwargs.items():
#             if s[k] == v:
#                 yield s

def histogram(metrics, key='name'):
    """
    Given sequence of dicts, return histogram dict of occurances of values
    for key.
    """
    h_dict = collections.defaultdict(int)
    for m in metrics:
        h_dict[m[key]] += 1
    return h_dict

def _frequent_items(items):
    return list(
        reversed(
            sorted(
                (freq, event) for (event, freq) in items)))

def frequent_events(histogram, num_events=7, events_ignore=events_ignore):
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

# def frequency_of_events(histogram, events_notice=events_notice):
#     """
#     Return (event, frequency) tuples from histogram for events
#     in events_notice.
#     """
#     items = (
#         (event, freq) for (event, freq) in histogram.items()
#         if event in events_notice)
#     items = _frequent_items(items)
#     return [(event, freq) for (freq, event) in items]

def apply_delta(metrics, delta):
    return [
        metric for metric in metrics
        if metric['timestamp'] >= delta]

def metrics_to_stats(metrics, delta, now=_sentinel):
    """ Return dict of stats about metrics """
    if now is _sentinel:
        now = datetime.datetime.now()
        pmetrics = apply_delta(metrics, now - delta)
        if not pmetrics:
            return {}
        pmetrics = sorted(pmetrics, key=operator.itemgetter('timestamp'))
        hist = histogram(pmetrics)
        frequents = frequent_events(hist)
        return {
            'timestamp': now,
            'delta': delta,
            'latest_timestamp': pmetrics[-1]['timestamp'],
            'latest_name': pmetrics[-1]['name'],
            'histogram': frequents}

def get_stats(metrics):
    now = datetime.datetime.now()
    delta_day = datetime.timedelta(days=1)
    delta_week = datetime.timedelta(weeks=1)
    delta_month =  datetime.timedelta(weeks=4)
    return [
        metrics_to_stats(metrics, delta)
        for delta in (delta_day, delta_week, delta_month)]

def write_stats(stats, filename):
    # serialize
    stats['timestamp'] = str(stats['timestamp'])
    stats['latest_timestamp'] = str(stats['latest_timestamp'])
    stats['delta'] = str(stats['delta'])
    open(filename, 'w').writelines(json.dumps(stats))

if __name__ == "__main__":
    filenames = sys.argv[1:]
    metrics = filenames_to_metrics(filenames)
    metrics = [metric for metric in metrics]

    for stats in get_stats(metrics):
        if stats:
            print(
                'events last %s from %s' %
                (str(stats['delta']), str(stats['timestamp'])))
            print(
                'latest event %s %s' %
                (stats['latest_timestamp'], stats['latest_name']))
            print('most frequent events:')
            for (event, freq) in stats['histogram']:
                print('%s (%s)' % (event, freq))
            print
