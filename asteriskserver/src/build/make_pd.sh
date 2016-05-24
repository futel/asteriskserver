#!/bin/bash

cd /tmp
tar -xvzf /vagrant/src/pd-0.47-0.src.tar.gz
cd pd-0.47-0/
sh autogen.sh
./configure --enable-jack
make
make install
