import redis
import time

call_key = "ratelimiter:call"
call_secs = 2

def block_ratelimit(key, secs):
    """
    Block until ratelimiter at key is available, then consume rate and return.
    """
    conn = redis.StrictRedis()
    while True:
        if conn.set(key, '', ex=secs, nx=True):
            return
        time.sleep(0.1)

def call_ratelimit():
    return block_ratelimit(call_key, call_secs)

