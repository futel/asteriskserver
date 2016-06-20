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
# allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# let ssh in from anywhere
iptables -A INPUT -p tcp --dport 42422 -j ACCEPT
# let anything in from vpnbox
# this should be changed to only be the asterisk and ssh ports
iptables -A INPUT -s vpnbox-prod-foo.phu73l.net -j ACCEPT
iptables -A INPUT -s vpnbox-prod-bar.phu73l.net -j ACCEPT

# callcentric
iptables -A INPUT -p udp -m udp -s 204.11.192.0/24 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 204.11.192.0/24 --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.35 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.35 --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.54 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.54 --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.58 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.58 --dport 10000:20000 -j ACCEPT
# voip.ms
iptables -A INPUT -p udp -m udp -s sanjose.voip.ms --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s sanjose.voip.ms --dport 10000:20000 -j ACCEPT
# twilio
iptables -A INPUT -p udp -m udp -s 54.172.60.0/30 --dport 5060:5061 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 54.172.60.0/23 --dport 10000:20000 -j ACCEPT
