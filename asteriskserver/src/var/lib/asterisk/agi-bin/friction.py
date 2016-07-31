import util

def noop(agi):
    return

def busy(agi):
    util.metric(agi, 'friction-busy')
    agi.appexec('busy')

def friction_5(agi):
    util.metric(agi, 'friction-5')
    agi.appexec('wait', 5)

def friction_10(agi):
    util.metric(agi, 'friction-10')
    agi.appexec('wait', 5)
    agi.appexec('MusicOnHold', None, 5)

action_map = {
    'noop': noop,
    'busy': busy,
    'friction_5': friction_5,
    'friction_10': friction_10
}

def timestr_to_timetup(timestr):
    return [int(s) for s in timestr.split(':')]

def cmp_time(hour, minute, now):
    if now.hour < hour:
        return -1
    if now.hour > hour:
        return 1
    if now.minute < minute:
        return -1
    if now.minute > minute:
        return 1
    return 0

def within_timestrs(start_time, end_time, now):
    if start_time and end_time:
        (hour, minute) = timestr_to_timetup(start_time)
        if cmp_time(hour, minute, now) >= 0:
            (hour, minute) = timestr_to_timetup(end_time)
            if cmp_time(hour, minute, now) < 0:
                return True
    return False

def action(action_map, config_map):
    """Return action_map indicated by config_map, or default."""
    return action_map.get(config_map.get('action', 'noop'), noop)

def friction(agi, config, extension, now):
    if config:
        for config_map in config:
            if str(config_map['extension']) == extension:
                (start_time, end_time) = (
                    config_map.get('start_time'), config_map.get('end_time'))
                if within_timestrs(start_time, end_time, now):
                    action(action_map, config_map)(agi)
