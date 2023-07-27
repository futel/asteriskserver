from unittest import TestCase, mock

import sys
sys.modules['asterisk'] = mock.Mock()
sys.modules['eventlistenerconf'] = mock.Mock()

import eventlistener


class TestEventListener(TestCase):

    def test_transformed_event(self):

        event = {"Event": "UserEvent", "Privilege": "user,all", "Channel": "PJSIP/voipms-00000dd9", "ChannelState": "6", "ChannelStateDesc": "Up", "CallerIDNum": "anonymous", "CallerIDName": "Anonymous", "ConnectedLineNum": "<unknown>", "ConnectedLineName": "<unknown>", "Language": "en", "AccountCode": "", "Context": "incoming_leet", "Exten": "s", "Priority": "1", "Uniqueid": "1690064438.3889", "Linkedid": "1690064438.3889", "UserEvent": "incoming_leet"}
        event = eventlistener.transformed_event(event)
        self.assertEqual(event['endpoint'], 'voipms')

        event = {"Event": "UserEvent", "Privilege": "user,all", "Channel": "PJSIP/twilio-00000e1e", "ChannelState": "6", "ChannelStateDesc": "Up", "CallerIDNum": "+1XXXXXXXXXX", "CallerIDName": "<unknown>", "ConnectedLineNum": "+15039266341", "ConnectedLineName": "<unknown>", "Language": "en", "AccountCode": "", "Context": "incoming_twilio", "Exten": "+1XXXXXXXXXX", "Priority": "1", "Uniqueid": "1690079930.3998", "Linkedid": "1690079930.3998", "UserEvent": "incoming-dialstatus-BUSY-robotron"}
        event = eventlistener.transformed_event(event)
        self.assertEqual(event['endpoint'], 'twilio')
