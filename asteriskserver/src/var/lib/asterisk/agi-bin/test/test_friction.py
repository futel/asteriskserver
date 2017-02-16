import friction

import unittest

class TestFriction(unittest.TestCase):

    def test_action_empty(self):
        self.assertEqual(friction.action({}, {}), friction.noop)

    def test_action_noop(self):
        self.assertEqual(friction.action({'noop': friction.noop}, {}), friction.noop)
        self.assertEqual(friction.action(
            {'noop': friction.noop}, {'action': 'noop'}), friction.noop)
        self.assertEqual(friction.action(
            {'noop': friction.noop}, {'action': 'xyzzy'}), friction.noop)
        self.assertEqual(
            friction.action(
                {'delay_5': friction.delay_5}, {'action': 'delay_5'}),
            friction.delay_5)
