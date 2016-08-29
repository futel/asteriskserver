import datetime

import friction

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
