# Seting up a sip client for the asterisk server.

## requirements

<extension> from pjsip.conf etc
<secret> from pjsip_secret.conf.j2 and update_asterisk_secrets_generic.yml
<server> futel-prod.phu73l.net or futel-stage.phu73l.net

Client must be behind a VPN client.

## set up a spa-1001 linksysPAP etc

line1: NAT mapping enable no
line1: NAT keep alive enable no
line1: proxy/outbound proxy <server>
line1: use outbound proxy no
line1: register yes
       make call without reg yes
       ans call without reg yes
line1: display name, user ID <extension>
line1: password <secret>
line1: use auth ID no
line1: Supplementary Service Subscription: call waiting serv no
line1: dial plan S0<:999> (or desired extension in default-outgoing context)

## set up an unlocked grandstream HT701

basic settings
telnet server: no

advanced settings
admin password:
firmware server path: blank
config server path: blank
automatic upgrade: no
always skip the firmware check: selected

fxs port
account active: yes
primary sip server: <server>
nat traversal: no
sip user id: <extension>
authenticate id: <extension>
authenticate password:
(Twilio credential list password)
sip registration: yes
unregister on reboot: no
outgoing call without registration: yes
Disable Call-Waiting: yes
Disable Call-Waiting Caller ID: yes
Disable Call-Waiting Tone: yes
Offhook Auto-Dial: 999
Offhook Auto-Dial Delay: 0
Hook Flash Timing: minimum: 500 maximum: 500

## set up linphone

- manage sip accounts:
- SIP address: sip:<extension>@futel-stage.phu73l.net
- SIP server address: <sip:futel-stage.phu73l.net;transport=udp>
- transport: UDP
- register: yes

when prompted, enter <secret>
