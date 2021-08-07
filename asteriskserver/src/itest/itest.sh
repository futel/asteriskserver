#!/bin/sh

export PYTHONPATH=/opt/asterisk/var/lib/asterisk/agi-bin:$PYTHONPATH
/opt/asterisk/itest/challenge_write.py
