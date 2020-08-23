require("util")

-- execute background playing of content
-- if no selection, go to conversations menu main
function play_content(contents, context, exten)
    app.AGI("metric.agi", context)
    for _, content in ipairs(contents) do
        app.Background(content)
    end
    goto_context("conversations", context, exten)
end

function menu_hold_the_phone_main_conversations(context, extension)
    return menu(
        {"welcome-to-hold-the-phone",
	"for-conversations",
	"press-one",
	"for-the-futel-menu",
	"press-two",
	"for-more-information-about-conversations",
	"press-three",
	"for-more-information-about-hold-the-phone",
	"press-four"},
        "conversations",
        context,
        extension)
end

function menu_hold_the_phone_incoming_conversations(context, extension)
    return menu(
        {"welcome-to-hold-the-phone",
	"for-conversations",
	"press-one",
	"for-more-information-about-conversations",
	"press-two",
	"for-more-information-about-hold-the-phone",
	"press-three"},
        "conversations",
        context,
        extension)
end

function menu_hold_the_phone_info_conversations(context, extension)
    return menu(
        {"hold-the-phone-info-content"},
         "conversations",
         context,
         extension)
end

function menu_conversations_info(context, extension)
    return menu(
        {"conversations-info-content"},
         "conversations",
         context,
         extension)
end

function menu_conversations(context, extension)
    return menu(
        {"conversations-prompt-main"},
        "conversations",
        context,
        extension)
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
    hold_the_phone_main_conversations = context(
        menu_hold_the_phone_main_conversations,
        "hold_the_phone_main_conversations",
        {"conversations",
         "outgoing-ivr",	-- extensions.conf
         "conversations_info",
         "hold_the_phone_info"});
    hold_the_phone_incoming_conversations = context(
        menu_hold_the_phone_incoming_conversations,
        "hold_the_phone_incoming",
        {"conversations",
         "conversations_info",
         "hold_the_phone_info"});
    hold_the_phone_info = context(
        menu_hold_the_phone_info_conversations,
        "hold_the_phone_info",  -- same context to avoid access from incoming
        {});
    conversations_info = context(
        menu_conversations_info,
        "conversations_info",  -- same context to avoid access from incoming
        {});
    conversations = context(
        menu_conversations,
        "conversations",  -- same context to avoid access from incoming
        {"content_one",
         "content_two",
         "content_three",
         "content_four",
         "content_five",
         "content_six",
         "content_seven",
         "content_eight",
         "content_nine",         
         });
    content_one = context(
        menu_content_one,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_one_selected = context(
        menu_content_one_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_two = context(
        menu_content_two,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_two_selected = context(
        menu_content_two_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_three = context(
        menu_content_three,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_three_selected = context(
        menu_content_three_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_four = context(
        menu_content_four,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_four_selected = context(
        menu_content_four_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_five = context(
        menu_content_five,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_five_selected = context(
        menu_content_five_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_six = context(
        menu_content_six,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_six_selected = context(
        menu_content_six_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_seven = context(
        menu_content_seven,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_seven_selected = context(
        menu_content_seven_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_eight = context(
        menu_content_eight,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_eight_selected = context(
        menu_content_eight_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_nine = context(
        menu_content_nine,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_nine_selected = context(
        menu_content_nine_selected,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_ten = context(
        menu_content_ten,
        "conversations",
        {"content_one_selected",
         "content_two_selected",
         "content_three_selected",
         "content_four_selected",
         "content_five_selected",
         "content_six_selected",
         "content_seven_selected",
         "content_eight_selected",         
         "content_nine_selected"});
    content_ten_selected = context(
        menu_content_ten_selected,
        "conversations",
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
