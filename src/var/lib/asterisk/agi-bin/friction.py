import util

config_filename = 'friction.yml'

def noop(agi):
    return

def busy(agi):
    util.metric(agi, 'friction-busy')
    agi.appexec('busy')
    # above command should not return

def delay_5(agi):
    util.metric(agi, 'friction-delay-5')
    agi.appexec('wait', 5)

def delay_10(agi):
    util.metric(agi, 'friction-delay-10')
    agi.appexec('wait', 5)
    agi.appexec('MusicOnHold', ',5')

def delay_20(agi):
    util.metric(agi, 'friction-delay-20')
    agi.appexec('wait', 5)
    util.say(agi, 'please-hold')
    agi.appexec('wait', 1)
    util.say(agi, 'for-the-next-available-outgoing-line')
    agi.appexec('wait', 3)
    agi.appexec('MusicOnHold', ',6')
    agi.appexec('wait', 1)

def context_restricted_dialtone(agi):
    util.metric(agi, 'friction-context-restricted-dialtone')
    agi.set_context('restricted-outgoing-dialtone-wrapper')
    agi.set_extension('s')
    agi.set_priority(1)

def vmauthenticate(agi):
    """Authenticate a voice mailbox and continue, or busy."""
    util.metric(agi, 'friction-vmauthenticate')
    # Note vmauthenticate lets user jump to 'a' extension if existing,
    # so don't call this in a context that defines that!
    try:
        util.say(agi, 'authenticate-with-your-voice-mail-box-to-continue')
        res = agi.appexec('VMAuthenticate')
    except Exception as exc:
        # we expect AGIAppError('Error executing application, or hangup',)
        util.metric(agi, 'friction-vmauthenticate-deny')
        agi.appexec('busy')
        # above command should not exit
    else:
        util.metric(agi, 'friction-vmauthenticate-allow')
        # if we got here, user authed, we are done

action_map = {
    'noop': noop,
    'busy': busy,
    'delay_5': delay_5,
    'delay_10': delay_10,
    'delay_20': delay_20,
    'context_restricted_dialtone': context_restricted_dialtone,
    'vmauthenticate': vmauthenticate
}

def action(action_map, config_map):
    """Return action_map indicated by config_map, or default."""
    return action_map.get(config_map.get('action', 'noop'), noop)

def friction(agi, extension, now, context):
    if extension:
        config = util.read_config(config_filename)
        if config:
            config_map = util.relevant_config(
                config, extension, now, context)
            if config_map:
                action(action_map, config_map)(agi)

