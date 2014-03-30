#!/usr/bin/env bash
# bootstrap file that must be run after each package, then repackaged

set -x # print commands as executed

# update virtualbox tools if we updated relevant centos packages before
# making the current package
/etc/init.d/vboxadd setup

# make sure a virtualbox clone won't try to get old mac addrs after packaging
rm /etc/udev/rules.d/70-persistent-net.rules
