#import datetime
import sys, os, traceback
import logging

# directories for gsm files, in order of preference
statement_dirs = [
    '/opt/asterisk/var/lib/asterisk/sounds/futel/recordings/karl_baz/',
    '/opt/asterisk/var/lib/asterisk/sounds/futel/recordings/karl_foo/',
    '/opt/asterisk/var/lib/asterisk/sounds/futel/recordings/karl_bar/',
    '/opt/asterisk/var/lib/asterisk/sounds/en/'
    ]

metric_filename = '/opt/asterisk/var/log/asterisk/metrics'

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

def metric(agi_o, name):
    """ Create a metric event with name and values from agi_o. """
    # A metric event is a key-value map, a plain metric is just a name and an
    # optional arbitrary value and we should probably keep it simple. But we
    # add a lot of default attributes to basically combine it with a verbose
    # log.
    items = dict(
        (var, agi_o.get_variable(var))
        for var in ('UNIQUEID', 'CHANNEL', 'CALLERID(number)'))
    items['name'] = name
    # writer is responsible for adding timestamp
    metric_agilog(agi_o, **items)
    metric_metriclog(**items)

def metric_agilog(agi_o, **kwargs):
    """ Log a formatted line to the asterisk log. """
    line = ', '.join("%s=%s" % (k, v) for (k, v) in kwargs.items())
    # we only get verbose!
    agi_o.verbose(line, 1)

def metric_metriclog(**kwargs):
    """ Log a formatted line to the metric logfile. """
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    ch = logging.FileHandler(metric_filename)
    # write a line of comma separated key=value, should quote them!
    logline = ', '.join("%s=%s" % (k, v) for (k, v) in kwargs.iteritems())
    logline = ' '.join(('%(asctime)s', logline))
    formatter = logging.Formatter(logline)
    ch.setFormatter(formatter)
    logger.addHandler(ch)
    logger.info('')

