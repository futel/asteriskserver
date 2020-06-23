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

def get_challenge_values(key):
    """
    Return list of values for key in challege file.
    """
    with open(filename, 'r') as f:
	pairs = (line.strip().split(',') for line in f)
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

    with open(filename, 'r') as f:
	pairs = (line.strip().split(',') for line in f)
        for (k,v) in pairs:
            out[k].add(v)
        return out

def get_challenge_leaderboard():
    """
    Return list of (key, score) pairs from challenge file, sorted by score.
    """
    scores = [(key, len(value)) for (key, value) in get_challenge_keys_values()]
    return(sorted(scores, key = lambda x: x[1]))

def get_challenge_leaderboard_position(key):
    """
    Return position for key in challenge file by score, or None.
    """
    leaderboard = get_challenge_leaderboard()
    keyes = [key for (key, values) in leaderboard]
    try:
        return index(key, [key for (key, values) in leaderboard])
    except ValueError:
        return None
