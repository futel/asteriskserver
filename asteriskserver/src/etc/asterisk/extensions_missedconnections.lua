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
         loop_statements={
             "for-missed-connections",
             "for-the-futel-menu",
             "for-more-information-about-missed-connections",
             "for-more-information-about-hold-the-phone"},
         statement_dir="missed-connections",
         destinations={
             "missed_connections",
             "outgoing-ivr",	-- extensions.conf
             "missed_connections_info",
             "hold_the_phone_info_missedconnections"}}),
    hold_the_phone_incoming = util.context(
        {intro_statements={
             "welcome-to-hold-the-phone",
             "para-espanol",
             "oprima-estrella"},
         loop_statements={
             "for-missed-connections",
             "for-more-information-about-missed-connections",
             "for-more-information-about-hold-the-phone"},
         statement_dir="missed-connections",
         destinations={
             "missed_connections",
             "missed_connections_info",
             "hold_the_phone_info_missedconnections"}}),
    hold_the_phone_info_missedconnections = util.context(
        {intro_statements={"hold-the-phone-info-content"},
         loop_statements={},
         statement_dir="missed-connections",
         destinations={}}),
    missed_connections_info = util.context(
        {intro_statements={"missed-connections-info-content"},
         loop_statements={},
         statement_dir="missed-connections",        
         destinations={}});
    missed_connections = util.context(
        {intro_statements={"missed-connections-intro-content"},
         loop_statements={
             "to-listen-to-missed-connections",
             "to-record-a-missed-connection"},
         statement_dir="missed-connections",
         destinations={
             "missed_connections_listen",
             "message_record"}});
    missed_connections_listen = util.context(
        {intro_statements={},
         loop_statements={
             [1]={"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_12_29_19",
                  "to-hear-more-and-reply"},
             [2]={"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_01_03_20",
                  "to-hear-more-and-reply"},
             
             [3]={"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_01_06_20",
                  "to-hear-more-and-reply"},
             [9]="to-record-a-missed-connection"},
         statement_dir="missed-connections",
         destinations={
             [1]="message_one_play",
             [2]="message_two_play",
             [3]="message_three_play",         
             [9]="message_record"}}),
    message_record = util.context_array(menu_message_record, {}),
    message_one_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1577674262094"},
         loop_statements={
             "to-respond-to-this-message-with-a-recording"},
         -- "to-play-responses-to-this-message",
        statement_dir="missed-connections",
        destinations={
            "message_one_response_record",
            "message_one_response_play"}}),
    message_one_response_record = util.context_array(
        menu_message_one_response_record, {}),
    -- message_one_response_play = util.context(
    --     {intro_statements={"message-one-response-content"},
    --      loop_statements={"to-respond-to-this-message-with-a-recording"},
    --    statement_dir="missed-connections",
    --     destinations={"message_one_response_record"});
    message_two_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1578094859777"},
         loop_statements={"to-respond-to-this-message-with-a-recording"},
         -- "to-play-responses-to-this-message",
         statement_dir="missed-connections",
         destinations={
             "message_two_response_record",
             "message_two_response_play"}}),
    message_one_response_record = util.context_array(
        menu_message_two_response_record, {}),
    -- message_two_response_play = util.context(
    --     {intro_statements={"message-two-response-content"},
    --      loop_statements={"to-respond-to-this-message-with-a-recording"},
    --    statement_dir="missed-connections",
    --     destinations={"message_one_response_record"});
    message_three_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1578329858737"},
         loop_statements={"to-respond-to-this-message-with-a-recording"},
         -- "to-play-responses-to-this-message",
         statement_dir="missed-connections",        
         destinations={
             "message_three_response_record",
             "message_three_response_play"}}),
    message_one_response_record = util.context_array(
        menu_message_three_response_record, {}),
    -- message_two_response_play = util.context(
    --     {intro_statements={"message-three-response-content"},
    --      loop_statements={"to-respond-to-this-message-with-a-recording"},
    --    statement_dir="missed-connections",
    --     destinations={"message_one_response_record"});
}
