#!/usr/bin/env bash
# how to set up /etc/sysconfig/iptables on vpnbox
# do this and then service iptables save

# XXX tighten this up again 

# clear all
iptables -F

# # allow localhost
# iptables -A INPUT -i lo -j ACCEPT
# # allow established connections
# iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# # let ssh in from anywhere
# # XXX would be better to have this on a different port
# #iptables -A INPUT -p tcp --dport 42422 -j ACCEPT
# iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# route the openvpn subnet
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

# # close everything
# iptables -P INPUT DROP
# iptables -P FORWARD DROP
# iptables -P OUTPUT ACCEPT
