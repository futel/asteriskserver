#!/usr/bin/env bash
# how to set up /etc/sysconfig/iptables on vpnbox
# do this and then service iptables save

# clear all
iptables -F

# close everything
iptables -P INPUT DROP
iptables -P FORWARD DROP
# XXX can we do this?
#iptables -P OUTPUT ACCEPT

# allow localhost
iptables -A INPUT -i lo -j ACCEPT
# allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# let ssh in from anywhere
iptables -A INPUT -p tcp --dport 42422 -j ACCEPT
# let openvpn in from anywhere
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
# let openvpn out from anywhere
# ESTABLISHED,RELATED makes this unnecessary?
#iptables -A OUTPUT -p udp --sport 1194 -j ACCEPT

# route the openvpn subnet
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT 

iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
