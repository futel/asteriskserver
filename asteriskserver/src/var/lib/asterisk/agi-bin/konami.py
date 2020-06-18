
import util

PROMPT = 'please-enter-konami-cheat-code'
FAIL = 'buzz'
STEP = 'ding'
DONE = 'konami-code-accepted'

STATES = [
    { 'file': PROMPT, 'next': ord('2') },
    { 'file': STEP,   'next': ord('2') },
    { 'file': STEP,   'next': ord('8') },
    { 'file': STEP,   'next': ord('8') },
    { 'file': STEP,   'next': ord('4') },
    { 'file': STEP,   'next': ord('6') },
    { 'file': STEP,   'next': ord('4') },
    { 'file': STEP,   'next': ord('6') },
    { 'file': STEP,   'next': ord('B') },
    { 'file': STEP,   'next': ord('A') },
    { 'file': STEP,   'next': ord('#') },
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
        key = self._say(file)

        if current_state['next'] is None:
            return 1
        if key <= 0:
            key = self.agi_o.wait_for_digit(timeout=1000)
        if key == current_state['next']:
            self.current = self.current + 1
        else:
            self._say(FAIL)
            self.current = 0
        return 0

    def _say(self, file):
        path = util.sound_path(file, ['challenge'])
        if path:
            return self.agi_o.stream_file(path, escape_digits='0123456789*#ABCD')


def konami(agi_o):
    return Konami(agi_o).run()
