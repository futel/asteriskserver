#!/bin/sh

export PYTHONPATH=/var/lib/asterisk/agi-bin:$PYTHONPATH

/opt/futel/itest/test_challenge.py
/opt/futel/itest/test_wumpus.py
/opt/futel/itest/test_konami.py
