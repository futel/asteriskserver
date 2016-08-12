import datetime

import friction

def test_timestr_to_timetup():
    assert friction.timestr_to_timetup("01:01") == [1, 1]
    assert friction.timestr_to_timetup("1:1") == [1, 1]

def test_within_timestrs():
    assert not friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2016, 01, 01, 00, 30))
    assert friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2016, 01, 01, 01, 00))
    assert friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2016, 01, 01, 01, 30))
    assert not friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2016, 01, 01, 02, 00))
    assert not friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2016, 01, 01, 02, 30))

    assert not friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2017, 02, 02, 00, 30))
    assert friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2017, 02, 02, 01, 00))
    assert friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2017, 02, 02, 01, 30))
    assert not friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2017, 02, 02, 02, 00))
    assert not friction.within_timestrs(
        "01:00", "02:00", datetime.datetime(2017, 02, 02, 02, 30))

def test_action():
    assert friction.action({}, {}) == friction.noop
    assert friction.action({'noop': friction.noop}, {}) == friction.noop
    assert friction.action(
        {'noop': friction.noop}, {'action': 'noop'}) == friction.noop
    assert friction.action(
        {'noop': friction.noop}, {'action': 'xyzzy'}) == friction.noop
    assert friction.action(
        {'delay_5': friction.delay_5},
        {'action': 'delay_5'}) == friction.delay_5
