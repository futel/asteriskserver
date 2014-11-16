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

def say(agi_o, filename):
    for statement_dir in statement_dirs:
        path = statement_dir + filename
        # must check for file existence, agi won't return or raise meaningfully
        if os.path.isfile(path + '.gsm'):
            return agi_o.stream_file(path)
    # this seems to be parsed into args, punctuation may break it
    return agi_o.appexec('festival', filename)
