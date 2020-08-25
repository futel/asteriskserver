util = require("util")

function menu_hold_the_phone_main(context, extension)
    return util.menu(
        {},
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
    return util.menu(
        {},
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
    return util.menu(
        {},
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
    return util.menu(
        {},
        {"hold-the-phone-info-content"},
         "peoples-homes",
         context,
         extension)
end

-- execute menu for paul_knauls context
function menu_paul_knauls(context, exten)
    return util.menu(
        {},
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
    return util.menu(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_cotton_club"},
        {},
        nil,
        context,
        extension)
end

function menu_paul_knauls_content_two(context, extension)
    return util.menu(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_gentrification"},
        {},
        nil,
        context,
        extension)
end

function menu_paul_knauls_content_three(context, extension)
    return util.menu(
        {"/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_work_aging"},
        {},
        nil,
        context,
        extension)
end

function menu_paul_knauls_message(context, extension)
    return util.record(
        "leave-a-message-for-paul-or-share-a-story-about-portlands-history-after-the-tone,peoples-homes",
        "paul-knauls-message")
end

extensions_peopleshomes = {
    hold_the_phone_main_peopleshomes = util.context(
        menu_hold_the_phone_main,
        {"peoples_homes",
         "outgoing-ivr",	-- extensions.conf
         "hold_the_phone_info"});
    hold_the_phone_incoming_peopleshomes = util.context(
        menu_hold_the_phone_incoming,
        {"peoples_homes",
         "hold_the_phone_info"});
    hold_the_phone_info_peopleshomes = util.context(
        menu_hold_the_phone_info,
        {});
    peoples_homes = util.context(
        menu_peoples_homes,
        {"paul_knauls",
         "sharon-helgerson",	-- extensions.conf
         "norman-sylvester",	-- extensions.conf
         "peoples-homes-info-content"}); -- extensions.conf
    paul_knauls = util.context(
        menu_paul_knauls,
        {"paul_knauls_content_one",
         "paul_knauls_content_two",
         "paul_knauls_content_three",
         "paul_knauls_message"});
    paul_knauls_content_one = util.context(
        menu_paul_knauls_content_one,
        {});
    paul_knauls_content_two = util.context(
        menu_paul_knauls_content_two,
        {});
    paul_knauls_content_three = util.context(
        menu_paul_knauls_content_three,
        {});
    paul_knauls_message = util.context(menu_paul_knauls_message, {});
    -- sharon_helgerson = util.context(menu_peoples_homes, {});
    -- norman_sylvester = util.context(menu_peoples_homes, {});
    -- peoples_homes_info_content = util.context(menu_peoples_homes, {});
}
