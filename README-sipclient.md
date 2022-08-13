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

advanced settings
telnet server: no
admin password:
firmware server path: blank
config server path: blank
automatic upgrade: no
always skip the firmware check: selected

fxs port
account active: yes
primary sip server: <server>
nat traversal: no
sip user id:
authenticate id:
authenticate password:
name:
sip registration: yes
unregister on reboot: no
outgoing call without registration: yes
Disable Call-Waiting: yes
Disable Call-Waiting Caller ID: yes
Disable Call-Waiting Tone: yes
Offhook Auto-Dial: 999
Offhook Auto-Dial Delay: 0
Hook Flash Timing: minimum: 500 maximum: 500
