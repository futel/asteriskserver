import record

import unittest

class TestModule(unittest.TestCase):

    def test_prompt_menu_says(self):
        i = record.prompt_menu_says(
            [(1, 'value_foo'),
             (2, 'value_bar')])
        says = [out for out in i]
        self.assertEqual(
            says,
            ['choose-one',
             'for',
             'value_foo',
             'press',
             'one',
             'for',
             'value_bar',
             'press',
             'two'])
