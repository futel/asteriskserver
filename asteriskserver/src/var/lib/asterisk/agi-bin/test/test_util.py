import datetime

import util

import unittest


class TestUtil(unittest.TestCase):

    def test_timestr_to_timetup(self):
        assert util.timestr_to_timetup("01:01") == [1, 1]
        assert util.timestr_to_timetup("1:1") == [1, 1]

    def test_within_timestrs(self):
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 01, 01, 00, 30))
        assert util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 01, 01, 01, 00))
        assert util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 01, 01, 01, 30))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 01, 01, 02, 00))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 01, 01, 02, 30))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 02, 02, 00, 30))
        assert util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 02, 02, 01, 00))
        assert util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 02, 02, 01, 30))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 02, 02, 02, 00))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 02, 02, 02, 30))

    def test_relevant_config(self):
        assert util.relevant_config(
            [{'extensions':[666]}], '666', 'xyzzy') is None
        assert util.relevant_config(
            [{'extensions':[666],
              'start_time': '01:00',
              'end_time': '02:00'}],
            '666',
            datetime.datetime(2016, 01, 01, 00, 30)) is None
        self.assertEqual(
            util.relevant_config(
                [{'extensions':[666],
                  'start_time': '01:00',
                  'end_time': '02:00',
                  'action': 'bar'}],
                '666',
                datetime.datetime(2016, 01, 01, 01, 30)),
            {'extensions':[666],
             'start_time': '01:00',
             'end_time': '02:00',
             'action': 'bar'})
