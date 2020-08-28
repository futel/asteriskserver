util = require("util")

-- execute background playing of content
-- if no selection, go to conversations menu main
function play_content(contents, context, exten)
    app.AGI("metric.agi", context)
    for content in util.iter(contents) do
        app.Background(content)
    end
    goto_context("conversations", context, exten)
end

-- play content one and be done
function menu_content_one(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/1"},
        "conversations",
        context,
        extension)
end

-- play content two and be done
function menu_content_two(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/2"},
        "conversations",
        context,
        extension)
end

-- play content three and be done
function menu_content_three(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/3"},
        "conversations",
        context,
        extension)
end

-- play content four and be done
function menu_content_four(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/4"},
        "conversations",
        context,
        extension)
end

-- play content five and be done
function menu_content_five(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/5"},
        "conversations",
        context,
        extension)
end

-- play content six and be done
function menu_content_six(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/6"},
        "conversations",
        context,
        extension)
end

-- play content seven and be done
function menu_content_seven(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/7"},
        "conversations",
        context,
        extension)
end

-- play content eight and be done
function menu_content_eight(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8"},
        "conversations",
        context,
        extension)
end

-- play content nine and be done
function menu_content_nine(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content one..nine and be done
function menu_content_one_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/1",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/2",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/3",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/4",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/5",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/6",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/7",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content two..nine and be done
function menu_content_two_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/2",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/3",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/4",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/5",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/6",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/7",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content three..nine and be done
function menu_content_three_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/3",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/4",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/5",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/6",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/7",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content four..nine and be done
function menu_content_four_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/4",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/5",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/6",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/7",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content five..nine and be done
function menu_content_five_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/5",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/6",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/7",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content six..nine and be done
function menu_content_six_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/6",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/7",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content seven..nine and be done
function menu_content_seven_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/7",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content eight..nine and be done
function menu_content_eight_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/8",
         "/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

-- play content nine and be done
function menu_content_nine_selected(context, extension)
    return play_content(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/conversations/9"},
        "conversations",
        context,
        extension)
end

extensions_conversations = {
    hold_the_phone_main_conversations = util.context(
        {intro_statements={"welcome-to-hold-the-phone"},
         loop_statements={"for-conversations",
                          "for-the-futel-menu",
                          "for-more-information-about-conversations",
                          "for-more-information-about-hold-the-phone"},
         statement_dir="conversations",        
         destinations={"conversations",
                       "outgoing-ivr",	-- extensions.conf
                       "conversations_info",
                       "hold_the_phone_info"}}),
    hold_the_phone_incoming_conversations = util.context(
        {intro_statements={"welcome-to-hold-the-phone"},
         loop_statements={
             "for-conversations",
             "for-more-information-about-conversations",
             "for-more-information-about-hold-the-phone"},
         statement_dir="conversations",
         destinations={"conversations",
                       "conversations_info",
                       "hold_the_phone_info"}}),
    hold_the_phone_info = util.context(
        {intro_statements={"hold-the-phone-info-content"},
         loop_statements={},
         statement_dir="conversations",
         destinations={}}),
    conversations_info = util.context(
        {intro_statements={"conversations-info-content"},
         loop_statements={},
         statement_dir="conversations",
         destinations={}});
    conversations = util.context(
        {intro_statement={"conversations-prompt-main"},
         loop_statements={},
         statement_dir="conversations",
         destinations={
             "content_one",
             "content_two",
             "content_three",
             "content_four",
             "content_five",
             "content_six",
             "content_seven",
             "content_eight",
             "content_nine"}}),
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
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
         "content_nine_selected"});
}
