#!/usr/bin/env bash

# clear all
ip6tables -F

ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT

# allow localhost
ip6tables -A INPUT -i lo -j ACCEPT
# allow established connections
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
