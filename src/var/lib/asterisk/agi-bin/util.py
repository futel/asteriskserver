import datetime
import sys, os, traceback
import logging
import random
import uuid
import yaml

asterisk_etc_dir = '/etc/asterisk'

# filename suffixes to consider for sound files
soundfile_suffixes = [
    '.gsm', '.sl44', '.sln', '.sln16', '.sln44', '.sln48', '.wav']
# superdirectory for sound files
superdirectory = '/var/lib/asterisk/sounds/'
# general directories for sound files, in order of preference
statement_dirs = [
    'statements/karl_quuux/',
    'statements/tishbite/',
    'statements/sailor/',
    'statements/sofia-general/',
    'statements/rose-foo/',
    'statements/rose-bar/',
    '']
# preferred submenu directories for sound files, in order of preference
preferred_statement_dirs = [
    'statements/karl-robotron/',
    'statements/karl-oracle-dead/',
    'statements/karl-voicemail-ivr/',
    'statements/karl-wildcard-line/',
    'statements/conversations/',
    'statements/challenge/',
    'statements/anzie-wumpus/',
    'statements/konami/',
    'statements/tishbite-wait/',
    'statements/sofia-community/',
    'statements/sofia-community-service/',
    'statements/sofia-directory/',
    'statements/sofia-incoming/',
    'statements/sofia-information/',
    'statements/sofia-network/',
    'statements/sofia-outgoing/',
    'statements/sofia-utilities/',
    'statements/sofia-voicemail/']

metric_filename = '/var/log/asterisk/metrics'

def read_config(config_filename):
    yfile = '/'.join((asterisk_etc_dir, config_filename))
    return yaml.load(open(yfile))

def agi_tracebacker(agi_o, func, *args, **kwargs):
    try:
        return func(*args, **kwargs)
    except:
        agi_o.verbose('ERROR')
        (exc_type, exc_value, exc_traceback) = sys.exc_info()
        for line in traceback.format_exc().splitlines():
            agi_o.verbose(line)
        raise

def sound_path(agi_o, sound_name, preferred_sub=None, language='en'):
    """
    Return path for file for sound_name.
    """
    path = sound_path_find(sound_name, preferred_sub, language)
    if not path:
    # We didn't find a path, create and return an absolute path without suffix.
        error(agi_o,
              "sound_path unable to find sound file %s %s %s" % (sound_name, preferred_sub, language))
        # XXX We are forgetting localization!
        path = sound_path_create(sound_name)
    return path

def sound_path_find(sound_name, preferred_sub=None, language='en'):
    """
    Return partial path for file for sound_name, or None.
    Path does not include extension.
    If preferred_sub is given, prefer a path with it as a substring.
    """
    if sound_name.startswith('/'):
        # absolute path
        return sound_name
    paths = []
    if preferred_sub:
        # add preferred_statement_dirs directory paths that include preferred_sub
        paths.extend([d for d in preferred_statement_dirs if preferred_sub in d])
    # add all statement_dirs directory paths
    paths.extend(statement_dirs)
    paths = [p + sound_name for p in paths]
    # add localization directories
    superdirectories = [superdirectory + language + '/']
    if language != 'en':
        # add fallback to en
        superdirectories.append(superdirectory + 'en' + '/')
    for sd in superdirectories:
        for path in paths:
            # Look for path with all eligible extensions.
            for suffix in soundfile_suffixes:
                if os.path.isfile(sd + path + suffix):
                    # A playable file exists at the path. Return it without the
                    # suffix.
                    return sd + path
    return None

def sound_path_create(sound_name):
    """
    Create a sound file for sound_name, which is in espeak's format,
    and return its path. Path does not include extension.
    """
    path = "/tmp/%s" % sound_name
    os.system("echo {} | espeak-ng -w {}.wav".format(
        sound_name, path))
    # flite version
    # os.system('echo {} | /bin/flite  -o {}.wav'.format(sound_name, path))
    # os.system('echo {} | /bin/flite_cmu_us_awb -o {}.wav'.format(sound_n\
    return path

def say(agi_o, filename, preferred_sub=None, escape=False):
    language = agi_o.env.get('agi_language')
    if escape:
        escape_digits = '0123456789*#ABCD*'
    else:
        escape_digits = ''
    path = sound_path(agi_o, filename, preferred_sub, language)
    if path:
        return agi_o.stream_file(path, escape_digits=escape_digits)

def metric(agi_o, name):
    """
    Create a metric event with name and values from agi_o.
    Log it to the verbose and metric logs.
    Send a UserEvent with it.
    """
    # A metric event is a key-value map, a plain metric is just a name,
    # timestamp, and optional arbitrary value and we should probably
    # keep it simple. Only the name (and implied timestamp) gets into
    # the UserEvent. But we add a lot of default attributes to basically
    # turn the log entries into verbose logs.
    items = dict(
        (var, agi_o.get_variable(var))
        for var in ('UNIQUEID', 'CHANNEL', 'CALLERID(number)'))
    items['name'] = name

    endpoint = agi_o.get_variable("CHANNEL(endpoint)")
    if endpoint == 'twilio':
        # CHANNEL(endpoint) is correct for incoming from Twilio Elastic
        # SIP (phone number to SIP trunk), but we get 'twilio' for that
        # and for Twilio PV, so we need get Twilio PV from callerid.
        callerid_name = agi_o.get_variable("CALLERID(name)")
        if callerid_name:
            # Outgoing from Twilio PV.
            endpoint = callerid_name
    items['endpoint'] = endpoint

    metric_agilog(agi_o, **items)
    metric_metriclog(**items)
    agi_o.appexec("UserEvent", name)

def metric_agilog(agi_o, **kwargs):
    """ Log a formatted metric line to the asterisk log. """
    line = ', '.join("%s=%s" % (k, v) for (k, v) in kwargs.items())
    # we only get verbose!
    agi_o.verbose(line, 1)

def metric_metriclog(**kwargs):
    """ Log a formatted line to the metric logfile. """
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    ch = logging.FileHandler(metric_filename)
    # write a line of comma separated key=value, should quote them!
    logline = ', '.join("%s=%s" % (k, v) for (k, v) in kwargs.items())
    logline = ' '.join(('%(asctime)s', logline))
    formatter = logging.Formatter(logline)
    ch.setFormatter(formatter)
    logger.addHandler(ch)
    logger.info('')

def error(agi_o, message):
    """Log an error in the asterisk log."""
    # Asterisk argument string marshalling is fun.
    agi_o.appexec("log", "ERROR,%s" % message)

def calling_extension(agi_o):
    """ Return the calling extension. """
    return agi_o.get_variable('calling_extension')

def timestr_to_datetime(timestr):
    try:
        return datetime.datetime.strptime(timestr, '%H:%M')
    except ValueError:
        return datetime.datetime.strptime(timestr, '%Y-%m-%dT%H:%M')
    return [int(s) for s in timestr.split(':')]

def cmp_time(dt, now):
    if dt.year != 1900:
        # includes date
        if now.year < dt.year:
            return -1
        if now.year > dt.year:
            return 1
        if now.month < dt.month:
            return -1
        if now.month > dt.month:
            return 1
    if now.hour < dt.hour:
        return -1
    if now.hour > dt.hour:
        return 1
    if now.minute < dt.minute:
        return -1
    if now.minute > dt.minute:
        return 1
    return 0

def within_timestrs(start_string, end_string, now):
    if start_string and end_string:
        start_time = timestr_to_datetime(start_string)
        if cmp_time(start_time, now) >= 0:
            end_time = timestr_to_datetime(end_string)
            if cmp_time(end_time, now) < 0:
                return True
    return False

def relevant_config(config, extension, now, context=None):
    """
    Return map from config corresponding to extension and now and context,
    or None."""
    extension = int(extension)  # normalize
    for config_map in config:
        if extension in config_map['extensions']:
            if context is None or config_map.get('context') == context:
                (start_time, end_time) = (
                    config_map.get('start_time'), config_map.get('end_time'))
                if within_timestrs(start_time, end_time, now):
                    return config_map

def random_file(dirpath, do_strip):
    """Return full path for random file chosen from given directory"""
    # find files
    paths = list(filter(
        os.path.isfile,
        (os.path.join(dirpath, f) for f in os.listdir(dirpath))))
    # choose file
    path = random.choice(paths)
    if do_strip:
        path = path.split('.').pop(0)
    return path

def get_username():
    return str(uuid.uuid4())

def get_filename(agi_o):
    """Return unique string suitable for a filename."""
    return get_username() + agi_o.get_variable('CALLERID(number)')
