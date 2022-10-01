#!/usr/bin/env python3
"""
Send asterisk manager events to aws sns queue.
"""

import eventlistenerconf
import snspublish

import functools
import time
import logging
import sys

from asterisk import manager

# asterisk manager config
asterisk_ip = "localhost"
asterisk_user = "futel"

logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format='%(asctime)s %(message)s')

def handle_interesting_event(event, manager, snsclient):
    logging.info('publishing %s' % message)
    snspublish.publish(event, snsclient)

def handle_misc_event(event, manager, snsclient):
    #if event.headers.get('AppData') in ('OperatorAttempt', 'OperatorNoPickup'):
    #    return handle_interesting_event(event, manager, snsclient)
    logging.info('not publishing %s' % event.headers)

def get_manager():
    snsclient = snspublish.get_snsclient()

    amanager = manager.Manager()
    amanager.connect(asterisk_ip)
    amanager.login(asterisk_user, eventlistenerconf.asterisk_passwd)

    # XXX Exceptions raised by event handlers just cause us to hang, is this because they are
    #     in a separate thread?
    event_handler = functools.partial(
        handle_interesting_event, snsclient=snsclient)
    misc_event_handler = functools.partial(
        handle_misc_event, snsclient=snsclient)
    amanager.register_event('PeerStatus', event_handler)
    amanager.register_event('Registry', event_handler)
    amanager.register_event('ConfbridgeJoin', event_handler)
    amanager.register_event('ConfbridgeLeave', event_handler)
    amanager.register_event('HangupRequest', event_handler)
    amanager.register_event('SoftHangupRequest', event_handler)
    amanager.register_event('Hangup', event_handler)
    amanager.register_event('UserEvent', event_handler)
    amanager.register_event('*', misc_event_handler)

    return amanager

def retry_get_manager():
    while True:
        amanager = get_manager()
        if amanager.connected():
            return amanager
        logging.info('not connected')
        time.sleep(60)

def main():
    logging.info('starting')
    amanager = retry_get_manager()
    while True:
        if not amanager.connected():
            raise Exception('not connected')
        _response = amanager.mailbox_count(1337)
        logging.debug('.')
        time.sleep(60)

if __name__ == "__main__":
    main()
