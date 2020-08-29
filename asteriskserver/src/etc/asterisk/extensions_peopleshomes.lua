util = require("util")

function menu_paul_knauls_message(context, extension)
    return util.record(
        "leave-a-message-for-paul-or-share-a-story-about-portlands-history-after-the-tone,peoples-homes",
        "paul-knauls-message")
end

extensions_peopleshomes = {
    hold_the_phone_main_peopleshomes = util.context(
        {intro_statements={"welcome-to-hold-the-phone"},
         menu_entries={
             {"for-peoples-homes", "peoples_homes"},
             {"for-the-futel-menu", "outgoing-ivr"},
             {"for-more-information-about-hold-the-phone", "hold_the_phone_info"}},
         statement_dir="peoples-homes"}),
    hold_the_phone_incoming_peopleshomes = util.context(
        {intro_statements={"welcome-to-hold-the-phone"},
         menu_entries={
             {"for-peoples-homes", "peoples_homes"},
             {"for-more-information-about-hold-the-phone", "hold_the_phone_info"}},
         statement_dir="peoples-homes"}),
    hold_the_phone_info_peopleshomes = util.context(
        {intro_statements={"hold-the-phone-info-content"},
         menu_entries={},
         statement_dir="peoples-homes"}),
    peoples_homes = util.context(
        {intro_statements={},
         menu_entries={
             {"to-hear-from-paul-knauls", "paul_knauls"},
             {"to-hear-from-sharon-helgerson", "sharon-helgerson"},
             {"to-hear-from-norman-sylvester", "norman-sylvester"},
             {"for-more-information-about-peoples-homes",
              "peoples-homes-info-content"}},
         statement_dir="peoples-homes"}),
    paul_knauls = util.context(
        {intro_statements={},
         menu_entries={
             {"to-hear-paul-talk-about-owning-portlands-historic-cotton-club",
              "paul_knauls_content_one"},
             {"to-hear-paul-talk-about-gentrification-and-how-portland-has-changed",
              "paul_knauls_content_two"},
             {"to-hear-paul-talk-about-work-and-aging",
              "paul_knauls_content_three"},
             {"to-leave-a-message-for-paul-or-to-share-a-story-about-portlands-history",
              "paul_knauls_message"}},
         statement_dir="peoples-homes"}),
    paul_knauls_content_one = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_cotton_club"},
         menu_entries={},
         statement_dir=nil}),
    paul_knauls_content_two = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_gentrification"},
         menu_entries={},
         statement_dir=nil}),
    paul_knauls_content_three = util.context(
        {intro_statements={
             "/opt/asterisk/var/lib/asterisk/sounds/futel/peoples-homes/paul_knauls_work_aging"},
         menu_entries={},
         statement_dir=nil}),
    paul_knauls_message = util.context_array(menu_paul_knauls_message, {});
    -- sharon_helgerson = util.context(menu_peoples_homes, {});
    -- norman_sylvester = util.context(menu_peoples_homes, {});
    -- peoples_homes_info_content = util.context(menu_peoples_homes, {});
}
