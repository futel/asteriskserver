util = require("util")

MAILBOX_MAIN=1500 -- mailbox to record a new missed connection
MAILBOX_ONE=1501  -- maibox to record a response to content 1
MAILBOX_TWO=1502  -- maibox to record a response to content 2
MAILBOX_THREE=1503  -- maibox to record a response to content 3

function menu_hold_the_phone_main_missedconnections(context, extension)
    return util.menu(
        {"welcome-to-hold-the-phone",
        "para-espanol",
        "oprima-estrella"},
        {"for-missed-connections",
	"press-one",
	"for-the-futel-menu",
	"press-two",
        "for-more-information-about-missed-connections",
        "press-three",
	"for-more-information-about-hold-the-phone",
	"press-four"},
        "missed-connections",
        context,
        extension)
end

function menu_hold_the_phone_incoming_missedconnections(context, extension)
    return util.menu(
        {"welcome-to-hold-the-phone",
        "para-espanol",
        "oprima-estrella"},
        {"for-missed-connections",
	"press-one",
        "for-more-information-about-missed-connections",
        "press-three",
	"for-more-information-about-hold-the-phone",
	"press-four"},
        "missed-connections",
        context,
        extension)
end

function menu_hold_the_phone_info_missedconnections(context, extension)
    return util.menu(
        {"hold-the-phone-info-content"},
        {},
        "missed-connections",
        context,
        extension)
end

function menu_missed_connections_info(context, extension)
    return util.menu(
        {"missed-connections-info-content"},
        {},
        "missed-connections",
        context,
        extension)
end

function menu_missed_connections(context, extension)
    return util.menu(
        {"missed-connections-intro-content"},
        {"to-listen-to-missed-connections",
         "press-one",
         "to-record-a-missed-connection",             
         "press-two"},
        "missed-connections",
        context,
        extension)
end

function menu_missed_connections_listen(context, extension)
    return util.menu(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_12_29_19"},
        {"to-hear-more-and-reply",
         "press-one",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_01_03_20",
         "to-hear-more-and-reply",
         "press-two",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_01_06_20",
         "to-hear-more-and-reply",
         "press-three",
         "to-record-a-missed-connection",             
         "press-nine"},
        "missed-connections",
        context,
        extension)
end

function menu_message_one_play(context, extension)
    return util.menu(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1577674262094"},
        {"to-respond-to-this-message-with-a-recording",
         "press-one",
         -- "to-play-responses-to-this-message",
         -- "press-two"
         },
        "missed-connections",
        context,
        extension)
end

function menu_message_two_play(context, extension)
    return util.menu(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1578094859777"},
        {"to-respond-to-this-message-with-a-recording",
         "press-one",
         -- "to-play-responses-to-this-message",
         -- "press-two"
         },
        "missed-connections",
        context,
        extension)
end

function menu_message_three_play(context, extension)
    return util.menu(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1578329858737"},
        {"to-respond-to-this-message-with-a-recording",
         "press-one",
         -- "to-play-responses-to-this-message",
         -- "press-two"
         },
        "missed-connections",
        context,
        extension)
end

function menu_message_one_response_play(context, extension)
    return util.menu(
        {"message-one-response-content"},
        {"to-respond-to-this-message-with-a-recording",
         "press-one"},
         "missed-connections",
        context,
        extension)
end

function menu_message_two_response_play(context, extension)
    return util.menu(
        {"message-two-response-content"},
        {"to-respond-to-this-message-with-a-recording",
         "press-one"},
         "missed-connections",
        context,
        extension)
end

function menu_message_three_response_play(context, extension)
    return util.menu(
        {"message-three-response-content",},
        {"to-respond-to-this-message-with-a-recording",
         "press-one"},
         "missed-connections",
        context,
        extension)
end

function menu_message_one_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_ONE, "s")
    app.Hangup()
end

function menu_message_two_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_TWO, "s")
    app.Hangup()
end

function menu_message_three_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_THREE, "s")
    app.Hangup()
end

function menu_message_listen(context, extension)
    return util.menu(
        {"message-one-preview"},
        {"to-hear-more-and-reply",
         "press-one",
         "message-two-preview",
         "to-hear-more-and-reply",
         "press-two",
         "to-record-a-missed-connection",             
         "press-nine"},
         "missed-connections",
         context,
         extension)
end

function menu_message_record(context, extension)
    util.say("your-recording-can-last-up-to-two-minutes", "missed-connections")
    util.say("the-first-ten-seconds-will-play-on-the-missed-connections-list", "missed-connections")
    util.say("and-the-rest-will-play-if-the-listener-selects-it", "missed-connections")
    app.VoiceMail(MAILBOX_MAIN, "s")
    app.Hangup()
end

extensions_missedconnections = {
    hold_the_phone_main = util.context(
        menu_hold_the_phone_main_missedconnections,
        {"missed_connections",
         "outgoing-ivr",	-- extensions.conf
         "missed_connections_info",
         "hold_the_phone_info_missedconnections"});
    hold_the_phone_incoming = util.context(
        menu_hold_the_phone_incoming_missedconnections,
        {"missed_connections",
         "missed_connections_info",
         "hold_the_phone_info_missedconnections"});
    hold_the_phone_info_missedconnections = util.context(
        menu_hold_the_phone_info_missedconnections,
        {});
    missed_connections_info = util.context(
        menu_missed_connections_info,
        {});
    missed_connections = util.context(
        menu_missed_connections,
        {"missed_connections_listen",
         "message_record"});
    missed_connections_listen = util.context(
        menu_missed_connections_listen,
        {"message_one_play",
         "message_two_play",
         "message_three_play",         
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder         
         "message_record"});
    message_record = util.context(
        menu_message_record,
        {});
    message_one_play = util.context(
        menu_message_one_play,
        {"message_one_response_record",
         "message_one_response_play"});
    message_one_response_record = util.context(
        menu_message_one_response_record,
        {});
    -- message_one_response_play = util.context(
    --     menu_message_one_response_play,
    --     {"message_one_response_record"});
    message_two_play = util.context(
        menu_message_two_play,    
        {"message_two_response_record",
         "message_two_response_play"});
    message_two_response_record = util.context(
        menu_message_two_response_record,    
        {});
    -- message_two_response_play = util.context(
    --     menu_message_two_response_play,    
    --     {"message_two_response_record"});
    message_three_play = util.context(
        menu_message_three_play,
        {"message_three_response_record",
         "message_three_response_play"});
    message_three_response_record = util.context(
        menu_message_three_response_record,
        {});
    -- message_three_response_play = util.context(
    --     menu_message_three_response_play,
    --     {"message_three_response_record"});
}
