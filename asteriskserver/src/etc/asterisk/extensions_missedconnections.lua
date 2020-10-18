util = require("util")

MAILBOX_MAIN=1500 -- mailbox to record a new missed connection
--MAILBOX_ONE=1501  -- maibox to record a response to content 1
MAILBOX_TWO=1502  -- maibox to record a response to content 2
MAILBOX_THREE=1503  -- maibox to record a response to content 3
MAILBOX_FOUR=1504  -- maibox to record a response to content 3
MAILBOX_FIVE=1505  -- maibox to record a response to content 3
MAILBOX_SIX=1506  -- maibox to record a response to content 3
MAILBOX_SEVEN=1507  -- maibox to record a response to content 3
MAILBOX_EIGHT=1508  -- maibox to record a response to content 3
MAILBOX_NINE=1509  -- maibox to record a response to content 3

function menu_message_record(context, extension)
    util.say("your-recording-can-last-up-to-two-minutes", "missed-connections")
    util.say("the-first-ten-seconds-will-play-on-the-missed-connections-list", "missed-connections")
    util.say("and-the-rest-will-play-if-the-listener-selects-it", "missed-connections")
    app.VoiceMail(MAILBOX_MAIN, "s")
    app.Hangup()
end

-- function menu_message_one_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_ONE, "s")
--     app.Hangup()
-- end

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

function menu_message_four_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_FOUR, "s")
    app.Hangup()
end

function menu_message_five_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_FIVE, "s")
    app.Hangup()
end

function menu_message_six_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_SIX, "s")
    app.Hangup()
end

function menu_message_seven_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_SEVEN, "s")
    app.Hangup()
end

function menu_message_eight_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_EIGHT, "s")
    app.Hangup()
end

function menu_message_nine_response_record(context, extension)
    util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
    util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
    util.say("record-your-message-after-the-tone", "missed-connections")        
    app.VoiceMail(MAILBOX_NINE, "s")
    app.Hangup()
end

extensions = {
    hold_the_phone_main = util.context(
        {intro_statements={
             "welcome-to-hold-the-phone",
             "para-espanol",
             "oprima-estrella"},
         menu_entries={
             {"for-missed-connections", "missed_connections"},
             {"for-the-futel-menu", "outgoing_portland"},
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
             -- [1]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_12_29_19", "to-hear-more-and-reply"}, "message_one_play"},
             [1]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_01_03_20", "to-hear-more-and-reply"}, "message_two_play"},
             [2]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/clip_01_06_20", "to-hear-more-and-reply"}, "message_three_play"},
             [3]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0000-clip", "to-hear-more-and-reply"}, "message_four_play"},
             [4]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0001-clip", "to-hear-more-and-reply"}, "message_five_play"},
             [5]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0002-clip", "to-hear-more-and-reply"}, "message_six_play"},
             [6]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0003-clip", "to-hear-more-and-reply"}, "message_seven_play"},
             [7]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0004-clip", "to-hear-more-and-reply"}, "message_eight_play"},
             [8]={{"/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0007-clip", "to-hear-more-and-reply"}, "message_nine_play"},             
             [9]={"to-record-a-missed-connection", "message_record"}},
         statement_dir="missed-connections"}),
    message_record = util.context_array(menu_message_record, {}),
    -- message_one_play = util.context(
    --     {intro_statements={
    --          "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1577674262094"},
    --      menu_entries={
    --          {"to-respond-to-this-message-with-a-recording",
    --           "message_one_response_record"}},
    --      -- {"to-play-responses-to-this-message", "message_one_response_play"},
    --      statement_dir="missed-connections"}),
    -- message_one_response_record = util.context_array(
    --     menu_message_one_response_record, {}),
    -- -- message_one_response_play = util.context(
    -- --     {intro_statements={"message-one-response-content"},
    -- --      menu_entries={{"to-respond-to-this-message-with-a-recording",
    -- --      "message_one_response_record"},},
    -- --    statement_dir="missed-connections");
    message_two_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1578094859777"},
         menu_entries={{"to-respond-to-this-message-with-a-recording",
                        "message_two_response_record"}},
         -- {"to-play-responses-to-this-message", "message_two_response_play"}
         statement_dir="missed-connections"}),
    message_two_response_record = util.context_array(
        menu_message_two_response_record, {}),
    -- message_two_response_play = util.context(
    --     {intro_statements={"message-two-response-content"},
    --      menu_entries={"to-respond-to-this-message-with-a-recording", "message_two_response_record"},
    --    statement_dir="missed-connections",
    message_three_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/1578329858737"},
         menu_entries={{"to-respond-to-this-message-with-a-recording",
                        "message_three_response_record"}},
         -- "to-play-responses-to-this-message", "message_three_response_play"
         statement_dir="missed-connections"}),
    message_three_response_record = util.context_array(
        menu_message_three_response_record, {}),
    -- message_three_response_play = util.context(
    --     {intro_statements={"message-three-response-content"},
    --      menu_entries={{"to-respond-to-this-message-with-a-recording", "message_three_response_record"})
    --    statement_dir="missed-connections",
    message_four_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0000"},
         menu_entries={
             {"to-respond-to-this-message-with-a-recording",
              "message_four_response_record"}},
         statement_dir="missed-connections"}),
    message_four_response_record = util.context_array(
        menu_message_four_response_record, {}),
    message_five_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0001"},
         menu_entries={
             {"to-respond-to-this-message-with-a-recording",
              "message_five_response_record"}},
         statement_dir="missed-connections"}),
    message_five_response_record = util.context_array(
        menu_message_five_response_record, {}),
    message_six_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0002"},
         menu_entries={
             {"to-respond-to-this-message-with-a-recording",
              "message_six_response_record"}},
         statement_dir="missed-connections"}),
    message_six_response_record = util.context_array(
        menu_message_six_response_record, {}),
    message_seven_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0003"},
         menu_entries={
             {"to-respond-to-this-message-with-a-recording",
              "message_seven_response_record"}},
         statement_dir="missed-connections"}),
    message_seven_response_record = util.context_array(
        menu_message_seven_response_record, {}),
    message_eight_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0004"},
         menu_entries={
             {"to-respond-to-this-message-with-a-recording",
              "message_eight_response_record"}},
         statement_dir="missed-connections"}),
    message_eight_response_record = util.context_array(
        menu_message_eight_response_record, {}),
    message_nine_play = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/missed-connections/msg0007"},
         menu_entries={
             {"to-respond-to-this-message-with-a-recording",
              "message_nine_response_record"}},
         statement_dir="missed-connections"}),
    message_nine_response_record = util.context_array(
        menu_message_nine_response_record, {}),
    
}

return extensions
