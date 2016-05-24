#!/bin/bash

cd /tmp
wget http://msp.ucsd.edu/Software/pd-0.47-0.src.tar.gz
tar -xvzf pd-0.47-0.src.tar.gz
cd pd-0.47-0/
sh autogen.sh
./configure --enable-jack
make
make install
