#!/usr/bin/env python3
"""
Prompt for and collect recordings.
"""

from itertools import cycle
import os, errno

import conf
import util
import statements


RECORDING_DIR = os.path.join(
    conf.asterisk_root, 'var/lib/asterisk/sounds/futel/recordings')

def mkdir(path):
    """Make directory and parents, silently ignoring existing directories."""
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise

def statement_to_filename(statement):
    return statement            # assume appropriate

def statement_path(statement, username):
    """
    Setup and return a path to store recording of statement in.  Assume
    statement and username are appropriate for paths.
    """
    path = os.path.join(RECORDING_DIR, username)
    mkdir(path)
    return os.path.join(path, statement_to_filename(statement))

def prompt_and_record(agi_o, statement, username):
    """
    Play prompts for statement, record gsm file,
    save at path for statement and username.
    """
    util.say(agi_o, 'please-repeat')
    util.say(agi_o, statement)
    path = statement_path(statement, username)
    path_in = path  + ':gsm'
    agi_o.appexec('record', path_in)
    agi_o.stream_file(path)

def digit_pound(agi_o):
    says = ['to-accept', 'press-pound', 'to-reject', 'press-any-key']
    for say in says:
        digit = util.say(agi_o, say, escape=True)
        if digit is not '':
            return digit == '#'
    digit = agi_o.wait_for_digit(timeout=-1)
    return digit == '#'

def int_to_ordinal_string(i):
    return {
        0:'zero',
        1:'one',
        2:'two',
        3:'three',
        4:'four',
        5:'five',
        6:'six',
        7:'seven',
        8:'eight',
        9:'nine'}.get(i)

def prompt_menu_says(statement_enumerator):
    """Yield strings suitable for a menu-driven choice from given dict."""
    yield 'choose-one'
    for (expected_key, statement_key) in statement_enumerator:
        yield  'for'
        yield statement_key
        yield  'press'
        yield int_to_ordinal_string(expected_key)

def say_and_get_digit(agi_o, statement):
    """Say statement and return digit pressed, or None."""
    choice = util.say(agi_o, statement, escape=True)
    try:
        return int(choice)
    except Exception:
        return None

def key_enumerator_chooser(keys):
    """Return structures that let us do things with given list of keys."""
    statement_enumerator = [tup for tup in enumerate(keys, 1)]
    statement_chooser = dict(
        (i, statement) for (i, statement) in statement_enumerator)
    return (statement_enumerator, statement_chooser)

def prompt_menu(agi_o, keys):
    """
    Prompt user to choose a key, and return valid key when chosen.
    """
    (statement_enumerator, statement_chooser) = key_enumerator_chooser(keys)
    says = cycle(prompt_menu_says(statement_enumerator))
    for say in says:
        chosen_statement_key = say_and_get_digit(agi_o, say)
        if chosen_statement_key in statement_chooser.keys():
            return statement_chooser[chosen_statement_key]

def interruptable_statements(agi_o, statements):
    """
    Say statements until a key is entered or statements run out.
    Return key entered or None.
    """
    for statement in statements:
        digit = util.say(agi_o, statement, escape=True)
        if digit is not '':
            return digit
    return None

def record_feature(agi_o, dirname):
    """Top function to record one recording to unique wav file."""
    path = os.path.join(RECORDING_DIR, dirname)
    mkdir(path)
    username = util.get_username()
    path = os.path.join(path, username)
    path_in = path  + ':wav'
    options = ','.join([path_in, ',,ky'])
    agi_o.appexec('record', options)

def record_statements(agi_o):
    """Top function to prompt, select, and record statements."""
    username = util.get_username()
    util.say(agi_o, 'hello')

    statement_keys = [group['name'] for group in statements.statement_groups]
    statement_key = prompt_menu(agi_o, statement_keys)

    intro_statements = [
        'after-each-statement',
        'please-repeat',
        'then-press-pound',
        'to-begin',
        'press-any-key']
    digit = interruptable_statements(agi_o, intro_statements)
    if digit is None:
        agi_o.wait_for_digit(timeout=-1)

    (statement_statements,) = [
        group['statements']
        for group in statements.statement_groups
        if group['name'] == statement_key]

    for statement in statement_statements:
        prompt_and_record(agi_o, statement, username)
        while not digit_pound(agi_o):
            prompt_and_record(agi_o, statement, username)

    util.say(agi_o, 'thank-you')
    util.say(agi_o, 'goodbye')
    util.metric(agi_o, 'record-menu')
