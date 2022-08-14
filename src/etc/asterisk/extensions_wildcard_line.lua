util = require("util")

function wildcard_context(filename)
    statement_dir = "/var/lib/asterisk/sounds/futel/wildcard-line/"
    statement_file = statement_dir .. filename
    return util.statement_context({statements={statement_file}})
end

function menu_contribute(context, extension)
    app.AGI("metric.agi", context)
    util.say("wildcard-line-welcome", "wildcard-line")
    util.say("wildcard-line-leave-message", "wildcard-line")
    app.VoiceMail(1337, "s")
    util.say("wildcard-line-thank-you", "wildcard-line")
    util.say("wildcard-line-come-back", "wildcard-line")
    app.Hangup()
end

extensions = {
    wildcard_line_outgoing = util.context(
        {intro_statements={"wildcard-line-welcome"},
         menu_entries={
             {"wildcard-line-to-contribute", "wildcard_line_contribute"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-eight"},
                 "wildcard_line_play_eight"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-seven"},
                 "wildcard_line_play_seven"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-six"},
                 "wildcard_line_play_six"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-five"},
                 "wildcard_line_play_five"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-four"},
                 "wildcard_line_play_four"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-three"},
                 "wildcard_line_play_three"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-two"},
                 "wildcard_line_play_two"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-one"},
                 "wildcard_line_play_one"}},
         statement_dir="wildcard-line"}),
    wildcard_line_incoming = util.context(
        {intro_statements={"wildcard-line-welcome"},
         menu_entries={
             {{"wildcard-line-to-hear", "wildcard-line-episode-eight"},
                 "wildcard_line_play_eight"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-seven"},
                 "wildcard_line_play_seven"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-six"},
                 "wildcard_line_play_six"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-five"},
                 "wildcard_line_play_five"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-four"},
                 "wildcard_line_play_four"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-three"},
                 "wildcard_line_play_three"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-two"},
                 "wildcard_line_play_two"},
             {{"wildcard-line-to-hear", "wildcard-line-episode-one"},
                 "wildcard_line_play_one"}},
         statement_dir="wildcard-line"}),
    wildcard_line_contribute = util.context_array(menu_contribute, {}),
    wildcard_line_play_one = wildcard_context("1"),
    wildcard_line_play_two = wildcard_context("2"),
    wildcard_line_play_three = wildcard_context("3"),
    wildcard_line_play_four = wildcard_context("4"),
    wildcard_line_play_five = wildcard_context("5"),
    wildcard_line_play_six = wildcard_context("6"),
    wildcard_line_play_seven = wildcard_context("7"),
    wildcard_line_play_eight = wildcard_context("8")}    

return extensions
