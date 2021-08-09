#!/bin/sh

export PYTHONPATH=/opt/asterisk/var/lib/asterisk/agi-bin:$PYTHONPATH

/opt/asterisk/itest/test_challenge.py
/opt/asterisk/itest/test_wumpus.py
/opt/asterisk/itest/test_konami.py
