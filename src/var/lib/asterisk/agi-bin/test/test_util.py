import datetime

import util

import unittest


class TestUtil(unittest.TestCase):

    def test_sound_path(self):
        self.assertEqual(util.sound_path("dummy", "/foo/bar"), "/foo/bar")

    def test_timestr_to_datetime(self):
        self.assertEqual(util.timestr_to_datetime("01:01").hour, 1)
        self.assertEqual(util.timestr_to_datetime("01:01").minute, 1)
        self.assertEqual(util.timestr_to_datetime("1:01").hour, 1)
        self.assertEqual(util.timestr_to_datetime("1:01").minute, 1)

    def test_within_timestrs_hour_minute(self):
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 1, 1, 0, 30))
        assert util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 1, 1, 1, 0))
        assert util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 1, 1, 1, 30))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 1, 1, 2, 0))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2016, 1, 1, 2, 30))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 2, 2, 0, 30))
        assert util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 2, 2, 1, 0))
        assert util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 2, 2, 1, 30))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 2, 2, 2, 0))
        assert not util.within_timestrs(
            "01:00", "02:00", datetime.datetime(2017, 2, 2, 2, 30))

    def test_within_timestrs_iso(self):
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2016, 1, 1, 0, 30)))
        self.assertTrue(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2016, 1, 1, 1, 0)))
        self.assertTrue(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2016, 1, 1, 1, 30)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2016, 1, 1, 2, 0)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2016, 1, 1, 2, 30)))

        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2017, 1, 1, 0, 30)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2017, 1, 1, 1, 0)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2017, 1, 1, 1, 30)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2017, 1, 1, 2, 0)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2017, 1, 1, 2, 30)))

        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2015, 1, 1, 0, 30)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2015, 1, 1, 1, 0)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2015, 1, 1, 1, 30)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2015, 1, 1, 2, 0)))
        self.assertFalse(util.within_timestrs(
            "2016-01-01T1:00", "2016-01-01T2:00", datetime.datetime(2015, 1, 1, 2, 30)))

    def test_relevant_config(self):
        assert util.relevant_config(
            [{'extensions':[666]}], '666', 'xyzzy') is None
        assert util.relevant_config(
            [{'extensions':[666],
              'start_time': '01:00',
              'end_time': '02:00'}],
            '666',
            datetime.datetime(2016, 1, 1, 0, 30)) is None
        self.assertEqual(
            util.relevant_config(
                [{'extensions':[666],
                  'start_time': '01:00',
                  'end_time': '02:00',
                  'action': 'bar'}],
                '666',
                datetime.datetime(2016, 1, 1, 1, 30)),
            {'extensions':[666],
             'start_time': '01:00',
             'end_time': '02:00',
             'action': 'bar'})
        self.assertEqual(
            util.relevant_config(
                [{'extensions':[666],
                  'start_time': '2016-01-01T01:00',
                  'end_time': '2016-01-01T02:00',
                  'action': 'bar'}],
                '666',
                datetime.datetime(2016, 1, 1, 1, 30)),
            {'extensions':[666],
             'start_time': '2016-01-01T01:00',
             'end_time': '2016-01-01T02:00',
             'action': 'bar'})
