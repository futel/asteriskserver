#!/usr/bin/env python3
"""
Send asterisk sip peer status to aws sns queue.
"""

import contact_status
import snspublish

import time
import logging
import sys

publish_secs = 600

# Event: contact_status_<status>
# endpoint: <number>
# Channel: PJSIP/<number>

logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format='%(asctime)s %(message)s')

def line_to_event(line):
    """Return a dict which looks like the event headers from a manager event."""
    return {
        'Event': f'contact_status_{line.status}',
        'endpoint': line.extension,
        'Channel': f'PJSIP/{line.extension}'}

def main():
    logging.info('starting')
    snsclient = snspublish.get_snsclient()
    while True:
        lines = contact_status.get_extension_lines(
            contact_status.get_contact_lines())
        for line in lines:
            event = line_to_event(line)
            logging.info('publishing %s' % event)
            snspublish.publish(event, snsclient)
        logging.debug('.')
        time.sleep(publish_secs)

if __name__ == "__main__":
    main()
