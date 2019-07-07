import redis
import time

call_key = "ratelimiter:call"
call_secs = 3
incoming_key = "ratelimiter:incoming"
incoming_secs = 3

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
    """
    Block until ratelimiter for outgoing calls.
    """
    return block_ratelimit(call_key, incoming_secs)

def incoming_ratelimit():
    """
    Block until ratelimiter for misc limited actions accessible from incoming
    calls.
    """
    return block_ratelimit(incoming_key, incoming_secs)
