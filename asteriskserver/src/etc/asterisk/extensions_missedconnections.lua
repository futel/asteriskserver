-- have 1500..1502 vm boxes
-- [default]
-- 999 => XXXX,,,,attach=no|saycid=no|envelope=no|delete=no
-- 1500 => 3841,,,,attach=no|saycid=no|envelope=no|delete=no
-- 1501 => 3841,,,,attach=no|saycid=no|envelope=no|delete=no
-- 1502 => 3841,,,,attach=no|saycid=no|envelope=no|delete=no

MAILBOX_MAIN=1500
MAILBOX_ONE=1501
MAILBOX_TWO=1502

function menu_hold_the_phone_main_missedconnections(context, extension)
    return menu(
        {"welcome-to-hold-the-phone",
	"for-missed-connections",
	"press-one",
	"for-the-futel-menu",
	"press-two",
        "for-more-information-about-missed-connections",
        "press-three",
	"for-more-information-about-hold-the-phone",
	"press-four"},
        "peoples-homes",
        context,
        extension)
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

function menu_message_one_response_play(context, extension)
    return menu(
        {"message-one-response-content",
         "to-respond-to-this-message-with-a-recording",
         "press-one"},
         "missed-connections",
        context,
        extension)
end

function menu_message_two_response_play(context, extension)
    return menu(
        {"message-two-response-content",
         "to-respond-to-this-message-with-a-recording",
         "press-one"},
         "missed-connections",
        context,
        extension)
end

-- Your recording can last up to 2 minutes. The first 10 seconds will play on the Missed Connections List, and the rest will play if the listener selects it
-- Record your message after the tone.
function menu_message_one_response_record(context, extension)
    app.VoiceMail(MAILBOX_ONE,u)
    app.Hangup()
end

function menu_message_two_response_record(context, extension)
    app.VoiceMail(MAILBOX_TWO,u)
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
    app.VoiceMail(MAILBOX_MAIN,u)
    app.Hangup()
end

extensions_missedconnections = {
    hold_the_phone_main_missedconnections = context(
        menu_hold_the_phone_main_missedconnections,
        "hold_the_phone_main_missedconnections",
        {"missed_connections",
         "outgoing-ivr",	-- extensions.conf
         "missed_connections_info",
         "hold_the_phone_info_missedconnections"});
    hold_the_phone_info_missedconnections = context(
        menu_hold_the_phone_info_missedconnections,
        "hold_the_phone_main_missedconnections",
        {});
    missed_connections_info = context(
        menu_missed_connections_info,
        "hold_the_phone_main_missedconnections",
        {});
    missed_connections = context(
        menu_missed_connections,
        "hold_the_phone_main_missedconnections",
        {"missed_connections_listen",
         "message_record"});
    missed_connections_listen = context(
        menu_missed_connections_listen,
        "missed_connections",
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
    message_two_response_play = context(
        menu_message_two_response_play,    
        "message_two_play",
        {"message_two_response_record"});
}
