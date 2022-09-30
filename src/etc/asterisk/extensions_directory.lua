util = require("util")
math = require("math")

function directory_mayor_portland(context, exten)
    util.metric(context)
    util.internaldial("+15038234120")
end

function directory_mayor_ypsi(context, exten)
    util.metric(context)
    util.internaldial("+17344822017")
end

function directory_mayor_detroit(context, exten)
    util.metric(context)
    util.internaldial("+13132243400")
end

function directory_sissyphus(context, exten)
    util.metric(context)
    util.internaldial(channel.e_pants:get())
end

function directory_dream_survey(context, exten)
    util.metric(context)
    util.internaldial("+19712581465")
end

function directory_natr_xxx(context, exten)
    util.metric(context)
    util.internaldial("+18336287999")
end

function directory_utopian_hotline(context, exten)
    util.metric(context)
    util.internaldial("+15036627263")
end

function directory_office_of_night_things(context, exten)
    util.metric(context)
    util.internaldial("+18003900934")
end

function directory_random_payphone(context, exten)
    util.metric(context)
    -- no retry, queue rings all members, long timeout
    app.Queue("payphones", "rn")
    -- retry, queue rings members sequentially randomly, short timeout
    app.Queue("payphonespi", "r")
end

function directory_random_concentrationcamp(context, exten)
    util.metric(context)
    app.Queue("concentrationcamps", "r")
end

function directory_tmbg_dial_a_song(context, exten)
    util.metric(context)
    util.internaldial("+18443876962")
end

function random_number(context, exten)
    util.metric(context)
    r = math.random(100)
    for i = 1,util.max_iterations do    
        util.say("your-random-number-is", "utilities")
        app.SayNumber(r)
    end
end

function longmont(context, exten)
    util.metric(context)
    util.play_random_background("/var/lib/asterisk/sounds/futel/longmont")
end

function payphone_radio(context, exten)
    util.metric(context)
    app.MP3Player("http://104.167.4.67:8136/stream")
end

local extensions = {
    directory_portland = util.context(
        {menu_entries={
             {"for-the-mayor", "directory_mayor_portland"},
             {"for-a-random-concentration-camp",
              "directory_random_concentrationcamp"},
             {"for-the-druid-of-sissyphus-gardens",
              "directory_sissyphus"},
             {"for-a-random-payphone", "directory_random_payphone"},
             {"for-the-wilamette-valley-dream-survey",
              "directory_dream_survey"},
             {"for-nature-x-x-x", "directory_natr_xxx"},
             {"for-the-utopian-hotline", "directory_utopian_hotline"},
             {"for-they-might-be-giants-dial-a-song",
              "directory_tmbg_dial_a_song"}},
         statement_dir="directory"}),
    directory_ypsi = util.context(
        {menu_entries={
             [1]={"for-the-mayor", "directory_mayor_ypsi"},
             [2]={"for-a-random-concentration-camp",
                  "directory_random_concentrationcamp"},
             [3]={"for-the-druid-of-sissyphus-gardens",
                  "directory_sissyphus"},
             [4]={"for-a-random-payphone", "directory_random_payphone"},
             [5]={"for-nature-x-x-x", "directory_natr_xxx"},
             [6]={"for-the-utopian-hotline", "directory_utopian_hotline"},
             [7]={"for-the-office-of-night-things",
                  "directory_office_of_night_things"},
             [8]={"for-they-might-be-giants-dial-a-song",
                  "directory_tmbg_dial_a_song"}},
         statement_dir="directory"}),
    directory_detroit = util.context(
        {menu_entries={
             [1]={"for-the-mayor", "directory_mayor_detroit"},
             [2]={"for-a-random-concentration-camp",
                  "directory_random_concentrationcamp"},
             [3]={"for-the-druid-of-sissyphus-gardens",
                  "directory_sissyphus"},
             [4]={"for-a-random-payphone",
                  "directory_random_payphone"},
             [5]={"for-nature-x-x-x", "directory_natr_xxx"},
             [6]={"for-the-utopian-hotline", "directory_utopian_hotline"},
             [7]={"for-the-office-of-night-things",
                  "directory_office_of_night_things"},
             [8]={"for-they-might-be-giants-dial-a-song",
                  "directory_tmbg_dial_a_song"}},
         statement_dir="directory"}),
    directory_souwester = util.context(
        {menu_entries={
             [1]={"for-a-random-concentration-camp",
                  "directory_random_concentrationcamp"},
             [2]={"for-the-druid-of-sissyphus-gardens",
                  "directory_sissyphus"},
             [3]={"for-a-random-payphone", "directory_random_payphone"},
             [4]={"for-nature-x-x-x", "directory_natr_xxx"},
             [5]={"for-the-utopian-hotline", "directory_utopian_hotline"},
             [6]={"for-the-office-of-night-things",
                  "directory_office_of_night_things"},
             [7]={"for-they-might-be-giants-dial-a-song",
                  "directory_tmbg_dial_a_song"}},
         statement_dir="directory"}),
    directory_safe = util.context(
        {menu_entries={
             {"for-the-mayor", "directory_mayor_portland"},
             {"for-the-druid-of-sissyphus-gardens",
              "directory_sissyphus"},
             {"for-a-random-payphone", "directory_random_payphone"},
             {"for-the-wilamette-valley-dream-survey",
              "directory_dream_survey"},
             {"for-nature-x-x-x", "directory_natr_xxx"},
             {"for-the-utopian-hotline", "directory_utopian_hotline"},
             {"for-they-might-be-giants-dial-a-song",
              "directory_tmbg_dial_a_song"}},
         statement_dir="directory"}),
    network = util.context(
        {menu_entries={
             {"for-longmont-potion-castle", "longmont"},
             {"for-the-dark-fiber", "dark-fiber"},
             {"for-the-p-l-a-telephone-network-interface", "pla-interface"},
             {"for-the-pink-phone-from-the-future", "pink-phone"},
             {"for-the-collectors-net-inbound-portal", "cnet-portal"},
             {"for-the-mojave-phone-booth-conference-line", "mojave-conference"},
             {"for-the-payphone-radio-network", "payphone_radio"},
             {"for-the-shadytel-voice-bbs", "shady-bbs"}},
         statement_dir="network"}),
    community_services_oregon = util.context(
        {menu_entries={
             {"for-two-one-one-community-resources", "info-211"},
             {"for-multnomah-county-mental-health-crisis-intervention",
              "mental-health-crisis"},
             {"for-the-call-to-safety-crisis-line", "call-to-safety"},
             {"for-the-suicide-prevention-hotline", "suicide-hotline"},
             {"for-an-obamaphone", "obamaphone-oregon"}},
         statement_dir="community-service"}),
    community_services_michigan = util.context(
        {menu_entries={
             {"for-the-suicide-prevention-hotline", "suicide-hotline"},
             {"for-an-obamaphone", "obamaphone-michigan"}},
         statement_dir="community-service"}),
    utilities_portland = util.context(
        {menu_entries={
             {"for-the-current-time", "current-time"},
             {"for-the-trymet-transit-tracker", "trimet-transit-tracker"},
             {"to-access-your-multnomah-county-library-account", "lib-account-line"},
             {"for-a-random-number", "random_number"}},
         statement_dir="utilities"}),
    utilities_generic = util.context(
        {menu_entries={
             {"for-the-current-time", "current-time-ypsi"},
             {"for-a-random-number", "random_number"}},
         statement_dir="utilities"}),
    random_number = util.destination_context(random_number),
    longmont = util.destination_context(longmont),
    payphone_radio = util.destination_context(payphone_radio),
    directory_mayor_portland = util.destination_context(
        directory_mayor_portland),
    directory_mayor_ypsi = util.destination_context(
        directory_mayor_ypsi),
    directory_mayor_detroit = util.destination_context(
        directory_mayor_detroit),
    directory_sissyphus = util.destination_context(
        directory_sissyphus),
    directory_dream_survey = util.destination_context(
        directory_dream_survey),
    directory_natr_xxx = util.destination_context(directory_natr_xxx),
    directory_utopian_hotline = util.destination_context(
        directory_utopian_hotline),
    directory_office_of_night_things = util.destination_context(
        directory_office_of_night_things),
    directory_random_payphone = util.destination_context(
        directory_random_payphone),
    directory_random_concentrationcamp = util.destination_context(
        directory_random_concentrationcamp),
    directory_tmbg_dial_a_song = util.destination_context(
        directory_tmbg_dial_a_song)}

return extensions
