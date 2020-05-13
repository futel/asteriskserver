MAILBOX_MAIN=1500 -- mailbox to record a new missed connection
MAILBOX_ONE=1501  -- maibox to record a response to content 1
MAILBOX_TWO=1502  -- maibox to record a response to content 2

function menu_hold_the_phone_main_missedconnections(context, extension)
    return menu(
        {"welcome-to-hold-the-phone",
        "para-espanol",
        "oprima-estrella",
	"for-missed-connections",
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
    return menu(
        {"welcome-to-hold-the-phone",
        "para-espanol",
        "oprima-estrella",
	"for-missed-connections",
	"press-one",
        "for-more-information-about-missed-connections",
        "press-three",
	"for-more-information-about-hold-the-phone",
	"press-four"},
        "missed-connections",
        context,
        extension)
end

-- the only way this seems workable from lua is to call a conf macro
-- exten => s,1,Set(CHANNEL(language)=es)
-- channel.LANGUAGE = "es"
-- channel.LANGUAGE:set("es")
-- channel.LANGUAGE():set("es")
function set_language_es(context, extension)
    app.Macro("languagees")     -- extensions.conf
    return app.Goto("hold_the_phone_main_missedconnections", "s", 1)
end

function menu_hold_the_phone_info_missedconnections(context, extension)
    return menu(
        {"hold-the-phone-info-content"},
        "missed-connections",
        context,
        extension)
end

function menu_missed_connections_info(context, extension)
    return menu(
        {"missed-connections-info-content"},
         "missed-connections",
         context,
         extension)
end

function menu_missed_connections(context, extension)
    return menu(
        {"missed-connections-intro-content",
         "to-listen-to-missed-connections",
         "press-one",
         "to-record-a-missed-connection",             
         "press-two"},
        "missed-connections",
        context,
        extension)
end

function menu_missed_connections_listen(context, extension)
    menu(
        {"message-one-preview-content",
         "to-hear-more-and-reply",
         "press-one",
         "message-two-preview-content",
         "to-hear-more-and-reply",
         "press-two",
         "to-record-a-missed-connection",             
         "press-nine"},
        "missed-connections",
        context,
        extension)
end

-- xxx add responses when available
function menu_message_one_play(context, extension)
    return menu(
        {"message-one-full-content",
         "message-one-info",
         "to-respond-to-this-message-with-a-recording",
         "press-one",
         "to-play-responses-to-this-message",
         "press-two"},
        "missed-connections",
        context,
        extension)
end

-- xxx only add response entries when available
function menu_message_two_play(context, extension)
    return menu(
        {"message-two-full-content",
         "message-two-info",
         "to-respond-to-this-message-with-a-recording",
         "press-one",
         "to-play-responses-to-this-message",
         "press-two"},
        "missed-connections",
        context,
        extension)
end

-- xxx only add response entries when available
function menu_message_one_response_play(context, extension)
    return menu(
        {"message-one-response-content",
         "to-respond-to-this-message-with-a-recording",
         "press-one"},
         "missed-connections",
        context,
        extension)
end

-- XXX only add when available
function menu_message_two_response_play(context, extension)
    return menu(
        {"message-two-response-content",
         "to-respond-to-this-message-with-a-recording",
         "press-one"},
         "missed-connections",
        context,
        extension)
end

function menu_message_one_response_record(context, extension)
    app.VoiceMail(MAILBOX_ONE, "s")
    app.Hangup()
end

function menu_message_two_response_record(context, extension)
    app.VoiceMail(MAILBOX_TWO, "s")
    app.Hangup()
end

function menu_message_listen(context, extension)
    return menu(
        {"message-one-preview",
         "to-hear-more-and-reply",
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
    app.VoiceMail(MAILBOX_MAIN, "s")
    app.Hangup()
end

-- return context array with an es localization option on star
function main_context_en(menu_function, parent_context, destinations)
    context_array = context(menu_function, parent_context, destinations)
    context_array["*"] = set_language_es
    return context_array
end

extensions_missedconnections = {
    hold_the_phone_main_missedconnections = main_context_en(
        menu_hold_the_phone_main_missedconnections,
        "hold_the_phone_main_missedconnections",
        {"missed_connections",
         "outgoing-ivr",	-- extensions.conf
         "missed_connections_info",
         "hold_the_phone_info_missedconnections"});
    hold_the_phone_incoming_missedconnections = main_context_en(
        menu_hold_the_phone_incoming_missedconnections,
        "hold_the_phone_incoming_missedconnections",
        {"missed_connections",
         "missed_connections_info",
         "hold_the_phone_info_missedconnections"});
    hold_the_phone_info_missedconnections = context(
        menu_hold_the_phone_info_missedconnections,
        "hold_the_phone_info_missedconnections", -- same context to avoid access from incoming
        {});
    missed_connections_info = context(
        menu_missed_connections_info,
        "missed_connections_info", -- same context to avoid access from incoming
        {});
    missed_connections = context(
        menu_missed_connections,
        "missed_conections",    -- same context to avoid access from incoming
        {"missed_connections_listen",
         "message_record"});
    missed_connections_listen = context(
        menu_missed_connections_listen,
        "missed_connections_listen", -- same context to avoid access from incoming
        {"message_one_play",
         "message_two_play",
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder
         "missed_connections_listen", -- placeholder         
         "message_record"});
    message_record = context(
        menu_message_record,
        "missed_connections",
        {});
    message_one_play = context(
        menu_message_one_play,
        "missed_connections_listen",
        {"message_one_response_record",
         "message_one_response_play"});
    message_one_response_record = context(
        menu_message_one_response_record,
        "message_one_play",
        {});
    -- XXX only add when available
    message_one_response_play = context(
        menu_message_one_response_play,
        "message_one_play",
        {"message_one_response_record"});
    message_two_play = context(
        menu_message_two_play,    
        "missed_connections_listen",
        {"message_two_response_record",
         "message_two_response_play"});
    message_two_response_record = context(
        menu_message_two_response_record,    
        "message_two_play",
        {});
    -- XXX only add when available
    message_two_response_play = context(
        menu_message_two_response_play,    
        "message_two_play",
        {"message_two_response_record"});
}
