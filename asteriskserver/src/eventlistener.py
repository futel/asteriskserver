"""
Send asterisk manager events to aws sns queue.
"""
#!/usr/bin/python

import eventlistenerconf

import functools
import time
import socket

import boto3
from asterisk import manager

# asterisk manager config
asterisk_ip = "0.0.0.0"
asterisk_user = "futel"

# aws config
aws_region_name = 'us-west-2'

def event_to_message(event):
    return str(
        {'hostname': socket.gethostname(),
         'event': event.headers})

def handle_interesting_event(event, manager, snsclient):
    response = snsclient.publish(
        TopicArn=eventlistenerconf.aws_arn,
        Message=event_to_message(event))

def get_manager():
    snsclient = boto3.client(
        'sns',
        region_name=aws_region_name,
        aws_access_key_id=eventlistenerconf.aws_access_key_id,
        aws_secret_access_key=eventlistenerconf.aws_secret_access_key)

    amanager = manager.Manager()
    amanager.connect(asterisk_ip)
    amanager.login(asterisk_user, eventlistenerconf.asterisk_passwd)
    handler = functools.partial(handle_interesting_event, snsclient=snsclient)
    amanager.register_event('PeerStatus', handler)
    amanager.register_event('Registry', handler)
    amanager.register_event('ConfBridgeJoin', handler)
    amanager.register_event('ConfBridgeLeave', handler)
    return amanager

amanager = get_manager()
while True:
    try:
        if not amanager.connected():
            raise Exception
        _response = amanager.mailbox_count(1337)
        print '.',
    except Exception as exc:
        print 'xxx', exc
        try:
            amanager.logoff()
        except Exception as exc:
            print 'xxx', exc
        try:
            amanager.close()
        except Exception as exc:
            print 'xxx', exc
        try:
            amanager = get_manager()
        except Exception as exc:
            print 'xxx', exc
    finally:
        time.sleep(60)
