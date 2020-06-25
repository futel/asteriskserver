"""
Tools to read and write challenge attributes.
Attributes are key-values.
SQLite would be easier, but this is a text file.
"""

import collections

import ratelimiter

filename = "/opt/asterisk/etc/asterisk/challenge.csv"


def write_challenge_line(key, value):
    """
    Add line with key and value to challenge file.
    """
    # note we ignore duplicates
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
    with open(filename, 'r') as f:
	return (line.strip().split(',') for line in f)

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
    Return map of sets of all values for all keys in challenge file.
    """
    out = collections.defaultdict(set)
    pairs = get_challenge_pairs()
    for (k, v) in pairs:
        out[k].add(v)
    return out

def get_challenge_leaderboard():
    """
    Return dict with challenge file scores as keys and challenge file keys as
    values.
    """
    scores = [(len(value), key) for (key, value) in get_challenge_keys_values()]
    out = collections.defaultdict(set)
    for (score, key) in scores:
        out[score].add(key)
    return scores

def get_challenge_leaderboard_positions():
    """
    Return list of three highest sorted (score, keys) pairs.
    """
    leaderboard = get_challenge_leaderboard()
    leaderboard = sorted(leaderboard, key = lambda x: x[0]))
    leaderboard = leaderboard[0:3]
    return leaderboard

def get_challenge_leaderboard_position(key):
    """
    Return (position, tied) for key, or None.
    """
    leaderboard = get_challenge_leaderboard_positions()
    for (position, (score, keys)) in enumerate(leaderboard):
        if key in keys:
            if len(keys) > 1:
                return (position, True)
            return (position, False)
    return None

def get_challenge_leaderboard_line(key):
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
    return None
