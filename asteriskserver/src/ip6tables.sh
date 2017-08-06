#!/usr/bin/env bash
# how to set up /etc/sysconfig/ip6tables on asteriskbox
# do this and then service ip6tables save && service ip6tables restart

# clear all
ip6tables -F

# close everything
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT

# allow localhost
ip6tables -A INPUT -i lo -j ACCEPT
# allow established connections
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
