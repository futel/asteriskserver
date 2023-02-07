#!/usr/bin/env bash
# how to set up /etc/sysconfig/iptables on asteriskbox
# do this and then service iptables save && service iptables restart

# clear all
iptables -F

# close everything
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# allow localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
# allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# let ssh in from anywhere
iptables -A INPUT -p tcp --dport 42422 -j ACCEPT
# let anything in from vpnbox
# this should just be the openvpn proto/port once all asterisk clients are behind the vpn
iptables -A INPUT -s vpnbox-prod-foo.phu73l.net -j ACCEPT
iptables -A INPUT -s vpnbox-prod-bar.phu73l.net -j ACCEPT
iptables -A INPUT -s vpnbox-prod-baz.phu73l.net -j ACCEPT
# let anything in from vpn interface
# 10.8.0.0 255.255.255.0
# 192.168.0.0 255.255.255.0
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT

# voip.ms SIP
iptables -A INPUT -p udp -m udp -s sanjose.voip.ms --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s sanjose.voip.ms --dport 10000:20000 -j ACCEPT
# twilio us1 (east coast) SIP
# https://www.twilio.com/docs/sip-trunking/ip-addresses
iptables -A INPUT -p udp -m udp -s 54.172.60.0/30 --dport 5060:5061 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 54.172.60.0/23 --dport 10000:20000 -j ACCEPT
# twilio us2 (west coast) SIP
# https://www.twilio.com/docs/sip-trunking/ip-addresses
iptables -A INPUT -p udp -m udp -s 54.244.51.0/30 --dport 5060:5061 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 54.244.51.0/24 --dport 10000:20000 -j ACCEPT
# philtel IAX
iptables -A INPUT -p udp -m udp -s 137.184.53.70 --dport 4569 -j ACCEPT
