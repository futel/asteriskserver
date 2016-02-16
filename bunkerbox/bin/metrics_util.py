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

# def histogram(metrics):
#     """
#     Given sequence of dicts, return histogram dict of occurances of values
#     for key.
#     """
#     hist = {
#         'latest_timestamp': datetime.datetime.min,
#         'latest_name': None,
#         'histogram': collections.defaultdict(int)}
#     for metric in metrics:
#         if metric['timestamp'] >= hist['latest_timestamp']:
#             hist['latest_timestamp'] = metric['timestamp']
#             hist['latest_name'] = metric['name']
#         hist['histogram'][metric['name']] += 1
#     return hist

# def _frequent_items(items):
#     return list(
#         reversed(
#             sorted(
#                 (freq, event) for (event, freq) in items)))

# def frequent_events(histogram, num_events=7):
#     """
#     Return most frequent (event, frequency) tuples from histogram for events
#     not in events_ignore.
#     """
#     items = _frequent_items(histogram.items())
#     items = items[0:num_events]
#     return [(event, freq) for (freq, event) in items]

# def min_timestamp_filter(metrics, date):
#     return (metric for metric in metrics if metric['timestamp'] >= date)

# def name_ignore_filter(metrics, name_ignore):
#     return (metric for metric in metrics if metric['name'] not in name_ignore)

# def extension_filter(metrics, extensions):
#     if extensions is None:
#         return (metric for metric in metrics)
#     else:
#         for metric in metrics:
#             channel_name = metric['CHANNEL'].split('/').pop()
#             extension = channel_name.split('-').pop()
#             if extension in extensions:
#                 yield metric

# def metrics_to_stats(metrics, delta, now):
#     """ Return dict of stats about metrics """
#     stats = {
#         'timestamp': now,
#         'delta': delta}
#     stats.update(histogram(metrics))
#     stats['histogram'] = frequent_events(stats['histogram'])
#     return stats

# def get_stats(metrics, days, extensions=None):
#     now = datetime.datetime.now()
#     delta = datetime.timedelta(days=days)
#     metrics = min_timestamp_filter(metrics, now - delta)
#     metrics = extension_filter(metrics, extensions)
#     metrics = name_ignore_filter(metrics, events_ignore)
#     return metrics_to_stats(
#         metrics,
#         delta,
#         now)

# def serialize_stats(stats):
#     """ Serialize given stats dict to json. """
#     stats['timestamp'] = stats['timestamp'].strftime('%Y-%m-%d %H:%M:%S')
#     stats['latest_timestamp'] = stats['latest_timestamp'].strftime(
#         '%Y-%m-%d %H:%M:%S')
#     if stats['delta'].seconds:
#         stats['delta'] = str(stats['delta'])
#     else:
#         if stats['delta'].days == 1:
#             stats['delta'] = '%d day' % stats['delta'].days
#         else:
#             stats['delta'] = '%d days' % stats['delta'].days
#     return json.dumps(stats)

# def write_stats(stats, filename):
#     """ Serialize given stats dict to json and write to filename. """
#     open(filename, 'w').writelines(serialize_stats(stats))

# if __name__ == "__main__":
#     # demonstration/test of stats for metric filenames given in args
#     filenames = sys.argv[1:]
#     metrics = filenames_to_metrics(filenames)
#     # get_stats needs a non-generator iterable
#     metrics = [metric for metric in metrics]

#     for days in (1, 7, 28):
#         stats = get_stats(metrics, days)
#         if stats:
#             stats = serialize_stats(stats)
#             stats = json.loads(stats)
#             print(
#                 'events last %s from %s' %
#                 (str(stats['delta']), str(stats['timestamp'])))
#             print(
#                 'latest event %s %s' %
#                 (stats['latest_timestamp'], stats['latest_name']))
#             print('most frequent events:')
#             for (event, freq) in stats['histogram']:
#                 print('%s (%s)' % (event, freq))
#             print
