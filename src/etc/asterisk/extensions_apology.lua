util = require("util")

function apology_service(context, exten)
    util.metric(context)
    util.say("begin-to-apologize-after-the-tone", "apology-service")
    app.Playtones("record")
    app.Wait(600)
    app.Busy()
end

local extensions = {
    apology_intro = util.context(
        {menu_entries={
             {"to-apologize", "apology_service"},
             {"to-learn-more-about-the-apology-service",
              "apology_about"}},
         statement_dir="apology-service"}),
    apology_service = util.context_array(apology_service, {}),
    apology_about = util.context(
        {intro_statements={
             "apologies-are-not-recorded-or-listened-to",
             "this-apology-service-is-an-homage-to-allen-bridges-apology-line",
             "we-hope-you-find-the-act-of-apologizing-helpful"},
         menu_entries={},
         statement_dir="apology-service"})}

return extensions
