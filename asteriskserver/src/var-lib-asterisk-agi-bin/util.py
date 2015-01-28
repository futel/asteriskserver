#import datetime
import sys, os, traceback

# directories for gsm files, in order of preference
statement_dirs = [
    '/opt/asterisk/var/lib/asterisk/sounds/futel/recordings/karl_baz/',
    '/opt/asterisk/var/lib/asterisk/sounds/futel/recordings/karl_foo/',
    '/opt/asterisk/var/lib/asterisk/sounds/futel/recordings/karl_bar/',
    '/opt/asterisk/var/lib/asterisk/sounds/en/'
    ]

def agi_tracebacker(agi_o, func, *args, **kwargs):
    try:
        return func(*args, **kwargs)
    except:
        agi_o.verbose('ERROR')
        (exc_type, exc_value, exc_traceback) = sys.exc_info()
        for line in traceback.format_exc().splitlines():
            agi_o.verbose(line)
        raise

def sound_path(sound_name):
    """
    Return full path without extension for file for sound_name, or None.
    """
    # this is how stream_file and Background want it
    for statement_dir in statement_dirs:
        path = statement_dir + sound_name
        if os.path.isfile(path + '.gsm'):
            return path
    return None

def say(agi_o, filename):
    path = sound_path(filename)
    if path:
        return agi_o.stream_file(path)
    # this seems to be parsed into args, punctuation may break it
    return agi_o.appexec('festival', filename)

def format_log(name, val):
    return "%s=%s" % (name, val)

def metric(agi_o, message=None):
    # if we're just logging, assume this is in there
    #agi_o.verbose(str(datetime.datetime.now()), 1)
    items = [(var, agi_o.get_variable(var))
              for var in ('UNIQUEID', 'CHANNEL', 'CONTEXT', 'CALLERID(number)')]
    if message:
        items.append(('message', message))
    line = ', '.join(format_log(name, value) for (name, value) in items)
    # we only get verbose!
    agi_o.verbose(line, 1)
