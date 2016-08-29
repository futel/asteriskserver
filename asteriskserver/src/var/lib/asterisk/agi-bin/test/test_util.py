import datetime

import util


def test_timestr_to_timetup():
    assert util.timestr_to_timetup("01:01") == [1, 1]
    assert util.timestr_to_timetup("1:1") == [1, 1]

def test_within_timestrs():
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

def test_relevant_config():
    assert util.relevant_config([], 'xyzzy', 'xyzzy') is None
    assert util.relevant_config(
        [{'extension':'666'}], '666', 'xyzzy') is None
    assert util.relevant_config(
        [{'extension':'666',
          'start_time': '01:00',
          'end_time': '02:00'}],
        '666',
        datetime.datetime(2016, 01, 01, 00, 30)) is None
    assert util.relevant_config(
        [{'extension':'666',
          'start_time': '01:00',
          'end_time': '02:00',
          'action': 'bar'}],
        '666',
        datetime.datetime(2016, 01, 01, 01, 30)) == {
            'extension':'666',
            'start_time': '01:00',
            'end_time': '02:00',
            'action': 'bar'}
