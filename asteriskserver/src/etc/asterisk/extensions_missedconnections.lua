util = require("util")

MAILBOX_MAIN=1500 -- mailbox to record a new missed connection
MAILBOX_ONE=1501  -- maibox to record a response to content 1
MAILBOX_TWO=1502  -- maibox to record a response to content 2
MAILBOX_THREE=1503  -- maibox to record a response to content 3

function menu_message_record(context, extension)
    util.say("your-recording-can-last-up-to-two-minutes", "missed-connections")
    util.say("the-first-ten-seconds-will-play-on-the-missed-connections-list", "missed-connections")
    util.say("and-the-rest-will-play-if-the-listener-selects-it", "missed-connections")
    app.VoiceMail(MAILBOX_MAIN, "s")
    app.Hangup()
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

extensions_missedconnections = {
    hold_the_phone_main = util.context(
        {intro_statements={
             "welcome-to-hold-the-phone",
             "para-espanol",
             "oprima-estrella"},
         menu_entries={
             {"for-missed-connections", "missed_connections"},
             {"for-the-futel-menu", "outgoing-ivr"},
             {"for-more-information-about-missed-connections",
              "missed_connections_info"},
             {"for-more-information-about-hold-the-phone",
              "hold_the_phone_info_missedconnections"}},
         statement_dir="missed-connections"}),
    hold_the_phone_incoming = util.context(
        {intro_statements={
             "welcome-to-hold-the-phone",
             "para-espanol",
             "oprima-estrella"},
         menu_entries={
             {"for-missed-connections", "missed_connections"},
             {"for-more-information-about-missed-connections",
              "missed_connections_info"},
             {"for-more-information-about-hold-the-phone",
              "hold_the_phone_info_missedconnections"}},
         statement_dir="missed-connections"}),
    hold_the_phone_info_missedconnections = util.context(
        {intro_statements={"hold-the-phone-info-content"},
         menu_entries={},
         statement_dir="missed-connections",
         destinations={}}),
    missed_connections_info = util.context(
        {intro_statements={"missed-connections-info-content"},
         menu_entries={},
         statement_dir="missed-connections",        
         destinations={}}),
    missed_connections = util.context(
        {intro_statements={"missed-connections-intro-content"},
         menu_entries={
             {"to-listen-to-missed-connections", "missed_connections_listen"},
             {"to-record-a-missed-connection", "message_record"}},
         statement_dir="missed-connections"}),
    missed_connections_listen = util.context(
        {intro_statements={},
         menu_entries={
             [1]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_12_29_19", "to-hear-more-and-reply"}, "message_one_play"},
             [2]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_01_03_20", "to-hear-more-and-reply"}, "message_two_play"},
             [3]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_01_06_20", "to-hear-more-and-reply"}, "message_three_play"},
             [9]={"to-record-a-missed-connection", "message_record"}},
         statement_dir="missed-connections"}),
    message_record = util.context_array(menu_message_record, {}),
    message_one_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1577674262094"},
         menu_entries={
             {"to-respond-to-this-message-with-a-recording",
              "message_one_response_record"}},
         -- {"to-play-responses-to-this-message", "message_one_response_play"},
         statement_dir="missed-connections"}),
    message_one_response_record = util.context_array(
        menu_message_one_response_record, {}),
    -- message_one_response_play = util.context(
    --     {intro_statements={"message-one-response-content"},
    --      menu_entries={{"to-respond-to-this-message-with-a-recording",
    --      "message_one_response_record"},},
    --    statement_dir="missed-connections");
    message_two_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1578094859777"},
         menu_entries={{"to-respond-to-this-message-with-a-recording",
                        "message_two_response_record"}},
         -- {"to-play-responses-to-this-message", "message_two_response_play"}
         statement_dir="missed-connections"}),
    message_one_response_record = util.context_array(
        menu_message_two_response_record, {}),
    -- message_two_response_play = util.context(
    --     {intro_statements={"message-two-response-content"},
    --      menu_entries={"to-respond-to-this-message-with-a-recording", "message_one_response_record"},
    --    statement_dir="missed-connections",
    message_three_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1578329858737"},
         menu_entries={{"to-respond-to-this-message-with-a-recording",
                        "message_three_response_record"}},
         -- "to-play-responses-to-this-message", "message_three_response_play"
         statement_dir="missed-connections"}),
    message_one_response_record = util.context_array(
        menu_message_three_response_record, {}),
    -- message_two_response_play = util.context(
    --     {intro_statements={"message-three-response-content"},
    --      menu_entries={{"to-respond-to-this-message-with-a-recording", "message_one_response_record"})
    --    statement_dir="missed-connections",
}
