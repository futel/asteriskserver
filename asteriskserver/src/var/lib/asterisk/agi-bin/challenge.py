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
