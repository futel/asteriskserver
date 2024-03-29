# Set up twilio configuration for Asterisk server

This usage of Twilio connects the Asterisk server to the PSTN for some incoming and outgoing calls.

## elastic sip trunking - credential lists

- foo
- bar
- virtualbox

## elastic sip trunking - trunks

### futel-prod
- termination sip uri futel.pstn.twilio.com
- origination sip uris sip:futel-prod.phu73l.net
- termination credential lists foo bar virtualbox
### futel-stage
- termination sip uri futel-stage.pstn.twilio.com
- origination sip uris sip:futel-stage.phu73l.net
- termination credential lists foo bar virtualbox

## phone numbers - manage - active

We want a phone number for each client, and one or more phone numbers for testing. Each number must have corresponding Asterisk configuration.

For each number used for client extensions:
- friendly name: <client>
- accept incoming: voice calls
- configure with: SIP trunk
- SIP trunk: futel-prod

For each number used by for testing:
- friendly name: stage test (one, two, etc)
- accept incoming: voice calls
- configure with: SIP trunk
- SIP trunk: futel-stage

## to test stage

- set up phone number to go to futel-stage trunk
- asterisk must have aor with contact sip:futel-stage.pstn.twilio.com?
- asterisk must have endpoint using aor?
- asterisk must have aor with contact sip:termination-stage.futel.sip.us1.twilio.com?
- asterisk must have endpoint using aor?
