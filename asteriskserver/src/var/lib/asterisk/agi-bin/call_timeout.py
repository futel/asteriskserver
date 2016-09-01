import util

def timeout_to_timeout_str(minutes):
    """Return string usable for timeout in dialplan Dial command."""
    if minutes is None:
        return ""
    millis = int(minutes) * 1000 * 60
    # limit call to millis minutes,
    # warn when 3 minutes remain,
    # repeat warning every 60 seconds
    return "L(%s:180000:60000)" % millis

def call_timeout(config, extension, now):
    """Return timeout string from config for extension and now."""
    if config:
        config_map = util.relevant_config(config, extension, now)
        if config_map:
            return timeout_to_timeout_str(config_map.get('timeout'))
    return ""
