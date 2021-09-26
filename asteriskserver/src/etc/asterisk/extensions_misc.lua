function directory_mayor_portland(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", "+15038234120")
end

function directory_mayor_ypsi(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", "+17344822017")
end

function directory_mayor_detroit(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", "+13132243400")
end

function directory_sissyphus(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", channel.e_pants:get())
end

function directory_dream_survey(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", "+19712581465")
end

function directory_natr_xxx(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", "+18336287999")
end

function directory_utopian_hotline(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", "+15036627263")
end

function directory_nuforc(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", "+12067223000")
end

function directory_office_of_night_things(context, exten)
    app.AGI("metric.agi", context)
    app.Macro("dial", "+18003900934")
end

function directory_random_payphone(context, exten)
    app.AGI("metric.agi", context)
    -- no retry, queue rings all members, long timeout
    app.Queue("payphones", "rn")
    -- retry, queue rings members sequentially randomly, short timeout
    app.Queue("payphonespi", "r")
end

function directory_random_concentrationcamp(context, exten)
    app.AGI("metric.agi", context)
    app.Queue("concentrationcamps", "r")
end

local extensions = {
    directory_portland = util.context(
        {menu_entries={
             [1]={"for-the-mayor", "directory_mayor_portland"},
             [2]={"for-a-random-concentration-camp",
                  "directory_random_concentrationcamp"},
             [3]={"for-the-druid-of-sissyphus-gardens",
                  "directory_sissyphus"},
             [4]={"for-a-random-payphone", "directory_random_payphone"},
             [5]={"for-the-wilamette-valley-dream-survey",
                  "directory_dream_survey"},
             [6]={"for-nature-x-x-x", "directory_natr_xxx"},
             [7]={"for-the-utopian-hotline", "directory_utopian_hotline"},
             [8]={"for-the-national-u-f-o-reporting-center",
                  "directory_nuforc"},
             [9]={"for-the-office-of-night-things",
                  "directory_office_of_night_things"}},
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
                  "directory_office_of_night_things"}},
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
                  "directory_office_of_night_things"}},
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
                  "directory_office_of_night_things"}},
         statement_dir="directory"}),
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
    directory_nuforc = util.destination_context(directory_nuforc),    
    directory_office_of_night_things = util.destination_context(
        directory_office_of_night_things),
    directory_random_payphone = util.destination_context(
        directory_random_payphone),
    directory_random_concentrationcamp = util.destination_context(
        directory_random_concentrationcamp)
}

return extensions
