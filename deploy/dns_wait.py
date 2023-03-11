#!/usr/bin/env python
# Wait for DNS for given host to match given value.

import sys
import socket
import time

delay = 15                      # 15 seconds
max_iterations = 4 * 10         # 10 minutes

def main():
    hostname = sys.argv[1]
    ip = sys.argv[2]
    for i in range(max_iterations):
        try:
            ip_out = socket.gethostbyname(hostname)
        except socket.gaierror:
            ip_out = None
        print(ip_out)
        if ip_out == ip:
            return
        time.sleep(delay)
    raise Exception("Ran out of time.")

if __name__ == "__main__":
    main()
