#!/usr/bin/env python
""" Read metrics, write stats to files """

import sys

import metrics_util

if __name__ == "__main__":
    stats_dirname = sys.argv.pop()
    metrics_filenames = sys.argv[1:]

    metrics = metrics_util.filenames_to_metrics(metrics_filenames)
    metrics = [metric for metric in metrics]

    for stats in metrics_util.get_stats(metrics):
        stats_filename = '/'.join((stats_dirname, str(stats['delta'].days)))
        metrics_util.write_stats(stats, stats_filename)

