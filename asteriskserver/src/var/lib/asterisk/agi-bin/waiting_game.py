#!/usr/bin/env python
"""
please hold for the next available game...
"""
import random
import util
import sys
from time import sleep

class Waiting:
    def __init__(self, agi_o):
        self.wait_time = 0
        self.agi_o = agi_o

    def num_to_word(self, number):
        """ translate numbers for util """
        return {
            0: "zero",
            1: "one",
            2: "two",
            3: "three",
            4: "four",
            5: "five",
            6: "six",
            7: "seven",
            8: "eight",
            9: "nine",
            10: "ten",
            11: "eleven",
            12: "twelve",
            13: "thirteen",
            14: "fourteen",
            15: "fifteen",
            16: "sixteen",
            17: "seventeen",
            18: "eighteen",
            19: "nineteen",
            20: "twenty"}[number]

    def wait_with_music(self, time):
        """ wait for given time while playing good music """
        str_wait_time = self.num_to_word(time)
        for t in ['your-expected-wait-time-is', str_wait_time, 'minutes']:
            util.say(self.agi_o, t, preferred_subs='tishbite_wait')
        # MW test... the greatest music
        self.agi_o.appexec('Playtones', '1004/1000')
        sleep(120)

    def end_game(self):
        """ prompt for any key in 10 seconds """
        util.say(self.agi_o, 'press-any-key', preferred_subs='tishbite_wait')
        key = self.agi_o.wait_for_digit(timeout=10000)
        if not key:
            self.agi_o.appexec('Busy')
        else:
            util.say(self.agi_o, 'please-call-back-during-business-hours', preferred_subs='tishbite_wait')
            sys.exit(0)

    def start_waiting(self):
        """ main game """
        self.wait_time = random.randint(5, 20)
        util.say(self.agi_o, 'please-hold', preferred_subs='tishbite_wait')

        while True:
            self.wait_time = self.wait_time - 2 + random.randint(0, 1)
            if self.wait_time < 0:
                self.wait_time = 0

            if self.wait_time > 0:
                self.wait_with_music(self.wait_time)
            elif self.wait_time == 0:
                self.end_game()

