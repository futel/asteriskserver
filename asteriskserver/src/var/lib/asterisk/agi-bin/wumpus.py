#!/usr/bin/env python
"""
Hunt the wumpus! On the phone!
https://www.filfre.net/2011/05/hunt-the-wumpus-part-2/
"""
import random
import sys
import util

class Wumpus:
    def __init__(self, agi_o):
        self.location = 0
        self.agi_o = agi_o
        self.arrows = 0
        self.hazards = {}
        self.cave = {1: [2,3,4], 2: [1,5,6], 3: [1,7,8], 4: [1,9,10], 5:[2,9,11],
                    6: [2,7,12], 7: [3,6,13], 8: [3,10,14], 9: [4,5,15], 10: [4,8,16], 
                    11: [5,12,17], 12: [6,11,18], 13: [7,14,18], 14: [8,13,19], 
                    15: [9,16,17], 16: [10,15,19], 17: [11,20,15], 18: [12,13,20], 
                    19: [14,16,20], 20: [17,18,19]}

    def num_to_word(self, number):
        """ util.say is bad at the number 4 """
        return {
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

    def hazard_warning(self, hazard):
        """ play hazard warnings """
        if hazard == 'bat':
            self.say('bats-nearby')
        elif hazard == 'pit':
            self.say('i-feel-a-draft')
        elif hazard == 'wumpus':
            self.say('i-smell-a-wumpus')

    def empty_room(self):
        """ return a random empty room """
        return list(set(self.cave.keys()).difference(self.hazards.keys()))

    def populate_cave(self):
        """ pick random empty room, place hazards """
        for hazard in ['bat', 'bat', 'pit', 'pit', 'wumpus']:
            room = random.choice(self.empty_room())
            self.hazards[room] = hazard

    def check_room(self, room):
        """ check for hazards, state, etc """
        # check for instant death
        if self.hazards.get(room) == 'wumpus':
            self.say('tsk-tsk-wumpus-got-you')
            self.warn_and_reset()
        elif self.hazards.get(room) == 'pit':
            self.say('yie-fell-in-a-pit')
            self.warn_and_reset()
        elif self.hazards.get(room) == 'bat':
            self.say('zap-super-bat-snatch-elsewhere-for-you')
            self.location = random.randint(1, 20)

        # check connecting rooms
        for r in self.cave[room]:
            self.hazard_warning(self.hazards.get(r))

    def shoot_arrow(self, room):
        """ shoot arrow into room, check wumpus wake, hits """
        self.arrows -= 1
        hazard = self.hazards.get(room)
        if hazard == 'bat':
            self.say('got-a-bat')
            del self.hazards[room]
        elif hazard in ['pit', None]:
            self.say('you-missed')
        elif hazard == 'wumpus':
            for s in ['aha-you-got-the-wumpus', 'he-he-he-the-wumpus-will-get-you-next-time']:
                self.say(s)
            sys.exit(0)

        # wumpus wake, maybe move
        if random.randint(0, 3):
            for key, val in self.hazards.items():
                if val == 'wumpus':
                    current_loc = key
            new_loc = random.choice(self.cave[current_loc])
            del self.hazards[current_loc]
            self.hazards[new_loc] = 'wumpus'
            # if wumpus lands on you, you die
            if self.location == new_loc:
                self.say('wumpus-enters-the-room-and-eats-you')
                self.warn_and_reset()

        # no arrows, game over man
        if self.arrows == 0:
            self.say('you-wasted-all-of-your-arrows')
            self.warn_and_reset()

    def collect_digits(self):
        """ wrapper script to accept 1 or 2 digits """
        max_digits = 2
        digits = []
        # relying on timeout to get a single digit... sigh
        # wait_for_digit will return an empty string if no digit pressed
        while max_digits > 0:
            digits.append(self.agi_o.wait_for_digit(timeout=1500))
            max_digits -= 1
        return ''.join(digits)

    def validate_choice(self):
        """ validate legal shoot or move """
        while True:
            self.say('where-to')
            room = self.collect_digits()
            # check for invalid entries
            if room in ['', '*', '#']:
                continue
            elif int(room) not in self.cave[self.location]:
                self.say('huh')
                continue
            else:
                return int(room)

    def say(self, statement):
        """ too lazy to add preferred_subs everywhere """
        util.say(self.agi_o, statement, preferred_subs=['anzie-wumpus'])

    def warn_and_reset(self):
        """ restart game on loss """
        self.say('ha-ha-ha-you-lose')
        self.say('let-me-find-a-new-cave-for-you')
        self.hunt()

    def hunt(self):
        """ main game logic """
        self.arrows = 5
        self.populate_cave()
        self.location = random.choice(self.empty_room()) # coward
        
        # enter the cave
        for s in ['welcome-to-hunt-the-wumpus',
                  'to-shoot',
                  'press-one',
                  'to-move',
                  'press-two']:
            self.say(s)

        while True:
            self.check_room(self.location)
            str_loc = self.num_to_word(self.location)
            self.say('you-are-in-room')
            self.say(str_loc)
            self.say('tunnels-lead-to')
            for t in self.cave[self.location]:
                str_room = self.num_to_word(t)
                self.say(str_room)
            self.say('shoot-or-move')
            action = self.agi_o.wait_for_digit(timeout=-1)

            while True:
                if action == '1':
                    room = self.validate_choice()
                    self.shoot_arrow(room)
                    break
                elif action == '2':
                    room = self.validate_choice()
                    self.location = room
                    break
                else:
                    self.say('what-now')
                    action = self.agi_o.wait_for_digit(timeout=-1)

