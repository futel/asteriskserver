function menu_hold_the_phone_main(context, extension)
    return menu(
        {"welcome-to-hold-the-phone",
	"for-peoples-homes",
	"press-one",
	"for-the-futel-menu",
	"press-two",
	"for-more-information-about-hold-the-phone",
	"press-three"},
        "peoples-homes",
        context,
        extension)
end

function menu_hold_the_phone_incoming(context, extension)
    return menu(
        {"welcome-to-hold-the-phone",
	"for-peoples-homes",
	"press-one",
	"for-more-information-about-hold-the-phone",
	"press-two"},
        "peoples-homes",
        context,
        extension)
end

-- execute menu for peoples_homes context
function menu_peoples_homes(context, exten)
    return menu(
        {"to-hear-from-paul-knauls",
        "press-one",
        "to-hear-from-sharon-helgerson",
        "press-two",
        "to-hear-from-norman-sylvester",
        "press-three",
        "for-more-information-about-peoples-homes",
        "press-five"},
        "peoples-homes",
        context,
        extension)
end

function menu_hold_the_phone_info(context, extension)
    return menu(
        {"hold-the-phone-info-content"},
         "peoples-homes",
         context,
         extension)
end

-- execute menu for paul_knauls context
function menu_paul_knauls(context, exten)
    return menu(
        {"to-hear-paul-talk-about-owning-portlands-historic-cotton-club",
	 "press-one",
	 "to-hear-paul-talk-about-gentrification-and-how-portland-has-changed",
	 "press-two",
	 "to-hear-paul-talk-about-work-and-aging",
	 "press-three",
	 "to-leave-a-message-for-paul-or-to-share-a-story-about-portlands-history",
	 "press-four"},
        "peoples-homes",
        context,
        extension)
end

function menu_paul_knauls_content_one(context, extension)
    return play(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_cotton_club"},
         context,
         extension)
end

function menu_paul_knauls_content_two(context, extension)
    return play(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_gentrification"},
         context,
         extension)
end

function menu_paul_knauls_content_three(context, extension)
    return play(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_work_aging"},
         context,
         extension)
end

function menu_paul_knauls_message(context, extension)
    return record(
        "leave-a-message-for-paul-or-share-a-story-about-portlands-history-after-the-tone,peoples-homes",
        "paul-knauls-message")
end

extensions_peopleshomes = {
    hold_the_phone_main = context(
        menu_hold_the_phone_main,
        "hold_the_phone_main",
        {"peoples_homes",
         "outgoing-ivr",	-- extensions.conf
         "hold_the_phone_info"});
    hold_the_phone_incoming = context(
        menu_hold_the_phone_incoming,
        "hold_the_phone_incoming",
        {"peoples_homes",
         "hold_the_phone_info"});
    hold_the_phone_info = context(
        menu_hold_the_phone_info,
        "hold_the_phone_main",
        {});
    peoples_homes = context(
        menu_peoples_homes,
        "hold_the_phone_main",
        {"paul_knauls",
         "sharon-helgerson",	-- extensions.conf
         "norman-sylvester",	-- extensions.conf
         "peoples-homes-info-content"}); -- extensions.conf
    paul_knauls = context(
        menu_paul_knauls,
        "peoples_homes",
        {"paul_knauls_content_one",
         "paul_knauls_content_two",
         "paul_knauls_content_three",
         "paul_knauls_message"});
    paul_knauls_content_one = context(
        menu_paul_knauls_content_one,
        "paul_knauls",
        {});
    paul_knauls_content_two = context(
        menu_paul_knauls_content_two,
        "paul_knauls",
        {});
    paul_knauls_content_three = context(
        menu_paul_knauls_content_three,
        "paul_knauls",
        {});
    paul_knauls_message = context(
        menu_paul_knauls_message, "paul_knauls", {});
    -- sharon_helgerson = context(menu_peoples_homes, {});
    -- norman_sylvester = context(menu_peoples_homes, {});
    -- peoples_homes_info_content = context(menu_peoples_homes, {});
}
