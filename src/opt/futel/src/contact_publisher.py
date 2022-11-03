#!/usr/bin/env python3
"""
Send asterisk sip peer status to aws sns queue.
"""

import contact_status
import snspublish

import time
import logging
import sys

publish_secs = 120

#{'Event': 'Hangup', 'Privilege': 'call,all', 'Channel': 'PJSIP/445-0000000b', 'ChannelState': '6', 'ChannelStateDesc': 'Up', 'CallerIDNum': '+15032945966', 'CallerIDName': '<unknown>', 'ConnectedLineNum': '<unknown>', 'ConnectedLineName': '<unknown>', 'Language': 'en', 'AccountCode': '', 'Context': 'voicemail_outgoing', 'Exten': 's', 'Priority': '1', 'Uniqueid': '1664673321.11', 'Linkedid': '1664673321.11', 'Cause': '16', 'Cause-txt': 'Normal Clearing'}

# Event: contact_status_<status>
# Channel: PJSIP/<number>

logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format='%(asctime)s %(message)s')

def line_to_event(line):
    """Return a dict which looks like the event headers from a manager event."""
    return {'Event': f'contact_status_{line.status}', 'Channel': f'PJSIP/{line.extension}'}

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
