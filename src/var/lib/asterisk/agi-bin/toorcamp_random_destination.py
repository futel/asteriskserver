#!/usr/bin/env python3

from asterisk import *
import util

import toorcamp_random_destination

agi = agi.AGI()

def main(agi_o, sequences, prefix_len):
    agi_o.goto_on_exit(
        context='toorcamp_random_destination', extension='s')
    #, priority='1')
