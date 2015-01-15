#!/usr/bin/env bash
# how to set up /etc/sysconfig/iptables on an asteriskbox instance
# do this and then service iptables save

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

# allow from the vpn
# XXX this only needs the asterisk and ssh ports
iptables -A INPUT -s futel-vpnbox.phu73l.net -j ACCEPT
# let ssh in from anywhere
# XXX would be better to have this on a different port
#iptables -A INPUT -p tcp --dport 42422 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# callcentric
iptables -A INPUT -p udp -m udp -s 204.11.192.0/24 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 204.11.192.0/24 --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.35 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.35 --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.54 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.54 --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.58 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.193.176.58 --dport 10000:20000 -j ACCEPT
# ipkall
iptables -A INPUT -p udp -m udp -s 66.54.140.46,66.54.140.47 --dport 5060:5080 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 66.54.140.46,66.54.140.47 --dport 10000:20000 -j ACCEPT
