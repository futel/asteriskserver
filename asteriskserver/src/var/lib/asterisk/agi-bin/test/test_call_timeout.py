import call_timeout

import unittest

class TestCallTimeout(unittest.TestCase):

    def test_timeout_to_timeout_str(self):
        self.assertEqual(call_timeout.timeout_to_timeout_str(None), "")
        self.assertEqual(call_timeout.timeout_to_timeout_str(1), "L(60000:180000:60000)")
