util = require("conf")
util = require("util")

-- peoples homes

-- function menu_paul_knauls_message(context, extension)
--     return util.record(
--         "leave-a-message-for-paul-or-share-a-story-about-portlands-history-after-the-tone,peoples-homes",
--         "paul-knauls-message")
-- end

-- conversations

-- execute background playing of content
-- if no selection, go to conversations menu main
function play_content(contents, context, exten)
    util.metric(context)
    for content in util.iter(contents) do
        app.Background(content)
    end
    goto_context("conversations", context, exten)
end

-- play content one and be done
function menu_content_one(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/1"},
        "conversations",
        context,
        extension)
end

-- play content two and be done
function menu_content_two(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/2"},
        "conversations",
        context,
        extension)
end

-- play content three and be done
function menu_content_three(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/3"},
        "conversations",
        context,
        extension)
end

-- play content four and be done
function menu_content_four(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/4"},
        "conversations",
        context,
        extension)
end

-- play content five and be done
function menu_content_five(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/5"},
        "conversations",
        context,
        extension)
end

-- play content six and be done
function menu_content_six(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/6"},
        "conversations",
        context,
        extension)
end

-- play content seven and be done
function menu_content_seven(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/7"},
        "conversations",
        context,
        extension)
end

-- play content eight and be done
function menu_content_eight(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8"},
        "conversations",
        context,
        extension)
end

-- play content nine and be done
function menu_content_nine(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content one..nine and be done
function menu_content_one_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/1",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/2",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/3",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/4",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/5",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/6",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/7",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content two..nine and be done
function menu_content_two_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/2",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/3",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/4",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/5",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/6",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/7",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content three..nine and be done
function menu_content_three_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/3",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/4",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/5",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/6",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/7",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content four..nine and be done
function menu_content_four_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/4",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/5",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/6",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/7",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content five..nine and be done
function menu_content_five_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/5",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/6",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/7",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content six..nine and be done
function menu_content_six_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/6",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/7",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content seven..nine and be done
function menu_content_seven_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/7",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content eight..nine and be done
function menu_content_eight_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/8",
         conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content nine and be done
function menu_content_nine_selected(context, extension)
    return play_content(
        {conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- missed connections

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
MAILBOX_TEN=1510  -- maibox to record a response to content 3

-- function menu_message_record(context, extension)
--     util.say("your-recording-can-last-up-to-two-minutes", "missed-connections")
--     util.say("the-first-ten-seconds-will-play-on-the-missed-connections-list", "missed-connections")
--     util.say("and-the-rest-will-play-if-the-listener-selects-it", "missed-connections")
--     app.VoiceMail(MAILBOX_MAIN, "s")
--     app.Hangup()
-- end

-- function menu_message_one_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_ONE, "s")
--     app.Hangup()
-- end

-- function menu_message_two_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_TWO, "s")
--     app.Hangup()
-- end

-- function menu_message_three_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_THREE, "s")
--     app.Hangup()
-- end

-- function menu_message_four_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_FOUR, "s")
--     app.Hangup()
-- end

-- function menu_message_five_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_FIVE, "s")
--     app.Hangup()
-- end

-- function menu_message_six_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_SIX, "s")
--     app.Hangup()
-- end

-- function menu_message_seven_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_SEVEN, "s")
--     app.Hangup()
-- end

-- function menu_message_eight_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_EIGHT, "s")
--     app.Hangup()
-- end

-- function menu_message_nine_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_NINE, "s")
--     app.Hangup()
-- end

-- function menu_message_ten_response_record(context, extension)
--     util.say("your-response-can-last-up-to-2-minutes", "missed-connections")
--     util.say("any-listener-can-hear-responses-to-this-missed-connection", "missed-connections")
--     util.say("record-your-message-after-the-tone", "missed-connections")        
--     app.VoiceMail(MAILBOX_TEN, "s")
--     app.Hangup()
-- end

extensions = {
    hold_the_phone_main = util.context(
        {intro_statements={"welcome-to-hold-the-phone"},
         menu_entries={
             {"for-peoples-homes", "peoples_homes"},
             {"for-conversations", "conversations"},
             {"for-missed-connections", "missed_connections"},
             {"for-more-information-about-hold-the-phone", "hold_the_phone_info_intro"}},
         statement_dir="conversations"}),
    hold_the_phone_info_intro = util.context(
        {intro_statements={},
         menu_entries={
             {"for-more-information-about-hold-the-phone", "hold_the_phone_info"},
             {"for-more-information-about-peoples-homes",
              "peoples-homes-info-content"},
             {"for-more-information-about-conversations", "conversations_info"},
             {"for-more-information-about-missed-connections",
              "missed_connections_info"}},
         statement_dir="conversations"}),
    hold_the_phone_info = util.context(
        {intro_statements={"hold-the-phone-info-content"},
         menu_entries={},
         statement_dir="conversations"}),
    
    -- peoples homes

    peoples_homes = util.context(
        {intro_statements={},
         menu_entries={
             {"to-hear-from-paul-knauls", "paul_knauls"},
             {"to-hear-from-sharon-helgerson", "sharon-helgerson"},
             {"to-hear-from-norman-sylvester", "norman-sylvester"}},
         statement_dir="peoples-homes"}),
    paul_knauls = util.context(
        {intro_statements={},
         menu_entries={
             {"to-hear-paul-talk-about-owning-portlands-historic-cotton-club",
              "paul_knauls_content_one"},
             {"to-hear-paul-talk-about-gentrification-and-how-portland-has-changed",
              "paul_knauls_content_two"},
             {"to-hear-paul-talk-about-work-and-aging",
              "paul_knauls_content_three"}
             --{"to-leave-a-message-for-paul-or-to-share-a-story-about-portlands-history",
             --"paul_knauls_message"}
         },
         statement_dir="peoples-homes"}),
    paul_knauls_content_one = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_cotton_club"},
         menu_entries={},
         statement_dir=nil}),
    paul_knauls_content_two = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_gentrification"},
         menu_entries={},
         statement_dir=nil}),
    paul_knauls_content_three = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_work_aging"},
         menu_entries={},
         statement_dir=nil}),
    -- paul_knauls_message = util.context_array(menu_paul_knauls_message, {}),
    -- sharon_helgerson = util.context(menu_peoples_homes, {});
    -- norman_sylvester = util.context(menu_peoples_homes, {});
    -- peoples_homes_info_content = util.context(menu_peoples_homes, {});
    
    -- conversations
    
    conversations_info = util.context(
        {intro_statements={"conversations-info-content"},
         menu_entries={},
         statement_dir="conversations"}),
    conversations = util.context(
        {intro_statements={"conversations-prompt-main"},
         menu_entries={
             {nil, "content_one"},
             {nil, "content_two"},
             {nil, "content_three"},
             {nil, "content_four"},
             {nil, "content_five"},
             {nil, "content_six"},
             {nil, "content_seven"},
             {nil, "content_eight"},
             {nil, "content_nine"}},
         statement_dir="conversations"}),
    content_one = util.context_array(
        menu_content_one,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_one_selected = util.context_array(
        menu_content_one_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_two = util.context_array(
        menu_content_two,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_two_selected = util.context_array(
        menu_content_two_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_three = util.context_array(
        menu_content_three,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_three_selected = util.context_array(
        menu_content_three_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_four = util.context_array(
        menu_content_four,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_four_selected = util.context_array(
        menu_content_four_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_five = util.context_array(
        menu_content_five,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_five_selected = util.context_array(
        menu_content_five_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_six = util.context_array(
        menu_content_six,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_six_selected = util.context_array(
        menu_content_six_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_seven = util.context_array(
        menu_content_seven,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_seven_selected = util.context_array(
        menu_content_seven_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_eight = util.context_array(
        menu_content_eight,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_eight_selected = util.context_array(
        menu_content_eight_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_nine = util.context_array(
        menu_content_nine,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_nine_selected = util.context_array(
        menu_content_nine_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_ten = util.context_array(
        menu_content_ten,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    content_ten_selected = util.context_array(
        menu_content_ten_selected,
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"}),
    
    -- missed connections
    
    missed_connections_info = util.context(
        {intro_statements={"missed-connections-info-content"},
         menu_entries={},
         statement_dir="missed-connections",        
         destinations={}}),
    missed_connections = util.context(
        {intro_statements={"missed-connections-intro-content"},
         menu_entries={
             {"to-listen-to-missed-connections", "missed_connections_listen"},
             {"for-more-information-about-missed-connections",
              "missed_connections_info"}},
         statement_dir="missed-connections"}),
    missed_connections_listen = util.context(
        {intro_statements={},
         menu_entries={
             [1]={{conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/clip_01_06_20", "to-hear-more-and-reply"}, "message_three_play"},
             [2]={{conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0000-clip", "to-hear-more-and-reply"}, "message_four_play"},
             [3]={{conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0001-clip", "to-hear-more-and-reply"}, "message_five_play"},
             [4]={{conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0002-clip", "to-hear-more-and-reply"}, "message_six_play"},
             [5]={{conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0003-clip", "to-hear-more-and-reply"}, "message_seven_play"},
             [6]={{conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0004-clip", "to-hear-more-and-reply"}, "message_eight_play"},
             [7]={{conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0007-clip", "to-hear-more-and-reply"}, "message_nine_play"},
             [8]={{conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0008-clip", "to-hear-more-and-reply"}, "message_ten_play"}},
         statement_dir="missed-connections"}),
    message_three_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/1578329858737"},
         menu_entries={},
         statement_dir="missed-connections"}),
    message_four_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0000"},
         menu_entries={},         
         statement_dir="missed-connections"}),
    message_five_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0001"},
         menu_entries={
             {"to-play-responses-to-this-message", "message_five_response_play"}},
         statement_dir="missed-connections"}),
    message_five_response_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0001-reply"},
         menu_entries={
             {"to-play-responses-to-this-message", "message_five_response_play"}},
         statement_dir="missed-connections"}),
    message_six_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0002"},
         menu_entries={},         
         statement_dir="missed-connections"}),
    message_seven_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0003"},
         menu_entries={},
         statement_dir="missed-connections"}),
    message_eight_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0004"},
         menu_entries={},         
         statement_dir="missed-connections"}),
    message_nine_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0007"},
         menu_entries={},         
         statement_dir="missed-connections"}),
    message_ten_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/missed-connections/msg0008"},
         menu_entries={},         
         statement_dir="missed-connections"}),

}

return extensions
