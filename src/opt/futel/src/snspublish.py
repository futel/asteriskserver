"""
Publish event to aws sns queue.
"""

import eventlistenerconf

import boto3
from datetime import datetime, timezone
import json
import socket

# aws config
aws_region_name = 'us-west-2'

def get_snsclient():
    return boto3.client(
        'sns',
        region_name=aws_region_name,
        aws_access_key_id=eventlistenerconf.aws_access_key_id,
        aws_secret_access_key=eventlistenerconf.aws_secret_access_key)

def event_to_message(event):
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    return json.dumps(
        {'timestamp': now,
         'hostname': socket.gethostname(),
         'event': event.headers})

def publish(event, snsclient):
    message = event_to_message(event)
    _response = snsclient.publish(
        TopicArn=eventlistenerconf.aws_arn, Message=message)
