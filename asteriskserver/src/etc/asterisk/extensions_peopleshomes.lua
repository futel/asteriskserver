util = require("util")

function menu_paul_knauls_message(context, extension)
    return util.record(
        "leave-a-message-for-paul-or-share-a-story-about-portlands-history-after-the-tone,peoples-homes",
        "paul-knauls-message")
end

extensions_peopleshomes = {
    hold_the_phone_main_peopleshomes = util.context(
        {intro_statements={"welcome-to-hold-the-phone"},
         loop_statements={
             "for-peoples-homes",
             "for-the-futel-menu",
             "for-more-information-about-hold-the-phone"},
         statement_dir="peoples-homes",
         destinations={
             "peoples_homes",
             "outgoing-ivr",	-- extensions.conf
             "hold_the_phone_info"}}),
    hold_the_phone_incoming_peopleshomes = util.context(
        {intro_statements={"welcome-to-hold-the-phone"},
         loop_statements={
             "for-peoples-homes",
             "for-more-information-about-hold-the-phone"},
         statement_dir="peoples-homes",
         destinations={
             "peoples_homes",
             "hold_the_phone_info"}}),
    hold_the_phone_info_peopleshomes = util.context(
        {intro_statements={"hold-the-phone-info-content"},
         loop_statements={},
         statement_dir="peoples-homes",
         destinations={}}),
    peoples_homes = util.context(
        {intro_statements={},
         loop_statements={
             "to-hear-from-paul-knauls",
             "to-hear-from-sharon-helgerson",
             "to-hear-from-norman-sylvester",
             "for-more-information-about-peoples-homes"},
         statement_dir="peoples-homes",
         destinations={"paul_knauls",
          "sharon-helgerson",	-- extensions.conf
          "norman-sylvester",	-- extensions.conf
          "peoples-homes-info-content"}}); -- extensions.conf
    paul_knauls = util.context(
        {intro_statements={},
         loop_statements={
             "to-hear-paul-talk-about-owning-portlands-historic-cotton-club",
             "to-hear-paul-talk-about-gentrification-and-how-portland-has-changed",
             "to-hear-paul-talk-about-work-and-aging",
             "to-leave-a-message-for-paul-or-to-share-a-story-about-portlands-history"},             
         statement_dir="peoples-homes",
         destinations={
             "paul_knauls_content_one",
             "paul_knauls_content_two",
             "paul_knauls_content_three",
             "paul_knauls_message"}}),
    paul_knauls_content_one = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_cotton_club"},
         loop_statements={},
         statement_dir=nil,
         destinations={}}),
    paul_knauls_content_two = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_gentrification"},
         loop_statements={},
         statement_dir=nil,
         destinations={}}),
    paul_knauls_content_three = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_work_aging"},
         loop_statements={},
         statement_dir=nil,
         destinations={}}),
    paul_knauls_message = util.context_array(menu_paul_knauls_message, {});
    -- sharon_helgerson = util.context(menu_peoples_homes, {});
    -- norman_sylvester = util.context(menu_peoples_homes, {});
    -- peoples_homes_info_content = util.context(menu_peoples_homes, {});
}
