#!/usr/bin/env python3
""" Read metrics, write stats to files """

import sys

import metrics_util

if __name__ == "__main__":
    stats_filename = sys.argv.pop()
    metrics_filenames = sys.argv[1:]

    metrics_util.read_write_metrics(metrics_filenames, stats_filename)

