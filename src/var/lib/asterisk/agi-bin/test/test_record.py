import record

import unittest

class TestModule(unittest.TestCase):
    def test_key_enumerator_chooser(self):
        (statement_enumerator,
         statement_chooser) = record.key_enumerator_chooser(
             ['foo', 'bar', 'baz'])
        self.assertEqual(
            statement_enumerator,
            [(1, 'foo'), (2, 'bar'), (3, 'baz')])
        self.assertEqual(
            statement_chooser,
            {1: 'foo', 2: 'bar', 3: 'baz'})

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
