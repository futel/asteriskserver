"""
Tools to read and write challenge attributes.
Attributes are key-values.
SQLite would be easier, but this is a text file.
"""

import collections
import os

import ratelimiter

filename = "/etc/asterisk/challenge.csv"


def write_challenge_line(key, value):
    """
    Add line with key and value to challenge file.
    """
    # We don't care if we are adding a duplicate key or pair.
    # The challenge file is a rudimentary CSV.
    line = "{},{}\n".format(key, value)
    with open(filename, 'a') as f:
        f.write(line)

def set_challenge_value(key, value):
    """
    Set key and value in challege file.
    """
    def callback():
        write_challenge_line(key, value)
    ratelimiter.block_mutex(ratelimiter.challenge_mutex_key, callback)

def get_challenge_pairs():
    """Read the challenge file and return pairs."""
    with open(filename, 'r') as f:
        # The challenge file is a rudimentary CSV.
        lines = (line.strip() for line in f)
        lines = (line for line in lines if line)
        lines = (line.split(',') for line in lines)
        return list(lines)

def get_challenge_values(key):
    """
    Return list of values for key in challege file.
    """
    pairs = get_challenge_pairs()
    return [v for (k, v) in pairs if k == key]

def has_challenge_value(key, value):
    """
    Return True if key has value in challege file.
    """
    return value in get_challenge_values(key)

def get_challenge_keys_values():
    """
    Return map of sets of all unique values for all keys in challenge file.
    """
    out = collections.defaultdict(set)
    pairs = get_challenge_pairs()
    for (k, v) in pairs:
        out[k].add(v)
    return out

def get_challenge_keys_with_value(value):
    """ Return iterator of all keys with value in challenge file."""
    return (k for (k, v) in get_challenge_keys_values().items() if value in v)

def get_challenge_leaderboard():
    """
    Return dict with challenge file scores as keys and challenge file keys as
    values.
    """
    kvs = get_challenge_keys_values()
    scores = [(len(value), key) for (key, value) in kvs.items()]
    out = collections.defaultdict(set)
    for (score, key) in scores:
        out[score].add(key)
    return out

def get_challenge_leaderboard_positions():
    """
    Return sequence of (score, keys) pairs, sorted by ascending score.
    """
    leaderboard = get_challenge_leaderboard()
    return reversed(
        sorted(leaderboard.items(), key = lambda item: item[0]))

def get_challenge_leaderboard_position(key):
    """
    Return (position, tied) for key,
    or None if key is not in the first five positions.
    """
    leaderboard = get_challenge_leaderboard_positions()
    leaderboard = enumerate(leaderboard)
    for _dummy in range(5):
        try:
            (position, (_score, keys)) = next(leaderboard)
        except StopIteration:
            return None
        if key in keys:
            if len(keys) > 1:
                return (position, True)
            return (position, False)
    return None

def get_challenge_leaderboard_score(key):
    """
    Return score for key, or None.
    """
    leaderboard = get_challenge_leaderboard_positions()
    for (score, keys) in leaderboard:
        if key in keys:
            return score
    return None

def get_challenge_leaderboard_line(key):
    """
    Return a string describing the position for key, or None.
    """
    position = get_challenge_leaderboard_position(key)
    if position is not None:
        (position, tied) = position
        if position == 0:
            if tied:
                return "you-are-tied-for-first-place"
            return "you-are-in-first-place"
        if position == 1:
            if tied:
                return "you-are-tied-for-second-place"
            return "you-are-in-second-place"
        if position == 2:
            if tied:
                return "you-are-tied-for-third-place"
            return "you-are-in-third-place"
        if position == 3:
            if tied:
                return "you-are-tied-for-fourth-place"
            return "you-are-in-fourth-place"
        if position == 4:
            if tied:
                return "you-are-tied-for-fifth-place"
            return "you-are-in-fifth-place"
    return None

def get_challenge_leaderboard_lines():
    """
    Yield a sequence of strings describing the leaderboard.
    """
    leaderboard = get_challenge_leaderboard_positions()
    for (score, keys) in leaderboard:
        for key in keys:
            yield (score, key)
