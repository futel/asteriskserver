#!/usr/bin/python
"""
Send asterisk manager events to aws sns queue.
"""

import eventlistenerconf

import functools
import time
import socket
import json
import logging
import sys

import boto3
from asterisk import manager

# asterisk manager config
asterisk_ip = "localhost"
asterisk_user = "futel"

# aws config
aws_region_name = 'us-west-2'

logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format='%(asctime)s %(message)s')

def event_to_message(event):
    return json.dumps(
        {'hostname': socket.gethostname(),
         'event': event.headers})

def handle_interesting_event(event, manager, snsclient):
    message = event_to_message(event)
    logging.info('publishing %s' % message)
    response = snsclient.publish(
        TopicArn=eventlistenerconf.aws_arn, Message=message)

def handle_misc_event(event, manager, snsclient):
    if event.headers.get('AppData') in ('OperatorAttempt', 'OperatorNoPickup'):
        return handle_interesting_event(event, manager, snsclient)
    logging.info('not publishing %s' % event.headers)

def get_manager():
    snsclient = boto3.client(
        'sns',
        region_name=aws_region_name,
        aws_access_key_id=eventlistenerconf.aws_access_key_id,
        aws_secret_access_key=eventlistenerconf.aws_secret_access_key)

    amanager = manager.Manager()
    amanager.connect(asterisk_ip)
    amanager.login(asterisk_user, eventlistenerconf.asterisk_passwd)

    event_handler = functools.partial(
        handle_interesting_event, snsclient=snsclient)
    misc_event_handler = functools.partial(
        handle_misc_event, snsclient=snsclient)
    amanager.register_event('PeerStatus', event_handler)
    amanager.register_event('Registry', event_handler)
    amanager.register_event('ConfbridgeJoin', event_handler)
    amanager.register_event('ConfbridgeLeave', event_handler)
    amanager.register_event('*', misc_event_handler)

    return amanager

def retry_get_manager():
    while True:
        try:
            amanager = get_manager()
            if not amanager.connected():
                raise Exception('not connected')
            return amanager
        except Exception as exc:
            # all of this rescuing is silly
            # should just let supervisord do its thing
            logging.info(str(exc))
        finally:
            time.sleep(60)

def main():
    logging.info('starting')
    amanager = retry_get_manager()
    while True:
        try:
            if not amanager.connected():
                raise Exception('not connected')
            _response = amanager.mailbox_count(1337)
            logging.debug('.')
        except Exception as exc:
            # all of this rescuing is silly
            # should just let supervisord do its thing
            try:
                logging.info(str(exc))
                amanager.logoff()
            except Exception as exc:
                logging.info(str(exc))
            try:
                amanager.close()
            except Exception as exc:
                logging.info(str(exc))
            # XXX we cleaned up the manager, now we need to create a new one
        finally:
            time.sleep(60)

if __name__ == "__main__":
    main()
