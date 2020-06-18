
import util

PROMPT = 'please-enter-konami-cheat-code'
FAIL = 'buzz'
STEP = 'ding'
DONE = 'konami-code-accepted'

STATES = [
    { 'file': PROMPT, 'next': '2' },
    { 'file': STEP,   'next': '2' },
    { 'file': STEP,   'next': '8' },
    { 'file': STEP,   'next': '8' },
    { 'file': STEP,   'next': '4' },
    { 'file': STEP,   'next': '6' },
    { 'file': STEP,   'next': '4' },
    { 'file': STEP,   'next': '6' },
    { 'file': STEP,   'next': 'B' },
    { 'file': STEP,   'next': 'A' },
    { 'file': STEP,   'next': '#' },
    { 'file': DONE,   'next': None },
]

class Konami:
    def __init__(self, agi_o):
        self.current = 0
        self.agi_o = agi_o

    def run(self):
        while(True):
            completed = self._do_state()
            if(completed):
                return 0

    def _do_state(self):
        current_state = STATES[self.current]
        file = current_state['file']
        key = util.say(self.agi_o, file, preferred_subs=['challenge'], escape=True)

        if current_state['next'] is None:
            return 1

        if key is '':
            key = self.agi_o.wait_for_digit(timeout=1000)
        if key == current_state['next']:
            self.current = self.current + 1
        else:
            util.say(self.agi_o, FAIL, preferred_subs=['challenge'], escape=True)

        self.current = 0

def konami(agi_o):
    return Konami(agi_o).run()
