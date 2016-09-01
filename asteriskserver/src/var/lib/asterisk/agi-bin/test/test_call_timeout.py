import call_timeout

def test_timeout_to_timeout_str():
    assert call_timeout.timeout_to_timeout_str(None) == ""
    assert call_timeout.timeout_to_timeout_str(1) == "L(1000:180000:60000)"
