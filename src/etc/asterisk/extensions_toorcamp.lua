util = require("util")

function toorcamp_dialtone_outgoing(context, exten)
    app.DISA("no-password", "toorcamp_dial_outgoing")
end

function toorcamp_dialtone_incoming(context, exten)
    app.DISA("no-password", "toorcamp_dial_incoming")
end

-- Return context array which immediately starts destination_function
-- when called with a possibly dialable extension. Dialable extensions
-- are four digits.
function toorcamp_dial_context(destination_function)
    local context_array = {}
    context_array["_XXXX"] = destination_function
    return context_array
end

function toorcamp_dial(context, exten, outgoing_channel)
    util.metric(context)    
    dialstring = util.get_dialstring(exten, outgoing_channel)
    timeoutstring = util.get_timeoutstring(30) -- minutes
    -- Begin monitoring call.
    app.AGI("get_filename.agi")
    filename = "outgoing-" .. channel.agi_out:get() .. ".wav"
    app.MixMonitor(filename, "b")
    app.Dial(dialstring, nil, timeoutstring)
    dialstatus = channel.DIALSTATUS:get()
    -- we have completed the call, metric and react to the outcome    
    -- note that we don't get here if the caller hung up first
    metric("outgoing-dialstatus-" .. dialstatus)
    if (dialstatus == "CHANUNAVAIL") or (dialstatus == "CONGESTION") then
        app.Playtones("congestion")
        app.Congestion()
    end
end    

-- Dial a random extension on the outgoing channel. Intended to be used
-- by a call file.
-- XXX Coming from a call file breaks the endpoint field of the metrics,
--     util.py probably needs to be able to handle that.
function toorcamp_dial_random_outgoing(context, exten)
    ext = "6000"                -- XXX testing
    return toorcamp_dial(context, ext, nil) -- XXX "shadytel-tcp"
end

function toorcamp_dial_outgoing(context, exten)
    return toorcamp_dial(context, exten, "shadytel-tcp")
end

function toorcamp_dial_incoming(context, extension)
    return toorcamp_dial(context, exten, nil)
end

local extensions = {
    toorcamp_dialtone_outgoing = util.destination_context(
        toorcamp_dialtone_outgoing),

    toorcamp_dialtone_incoming = util.destination_context(
        toorcamp_dialtone_incoming),
    toorcamp_dial_incoming = toorcamp_dial_context(toorcamp_dial_incoming),
    toorcamp_dial_outgoing = toorcamp_dial_context(toorcamp_dial_outgoing),
    toorcamp_dial_random_outgoing = util.destination_context(
        toorcamp_dial_random_outgoing),
    challenge_toorcamp_outgoing = util.context(
        {intro_statements={},
         menu_entries={
             {"to-make-a-call", "toorcamp_dialtone_outgoing"},             
             {"to-perform-the-challenges", "challenge_authenticate"},
             {"for-voicemail", "voicemail_outgoing"},
             {"for-the-fewtel-voice-conference", "futel-conf"},
             {"for-instructions", "challenge_instructions"},
             {"for-the-leaderboard", "challenge_leaderboard"},
             {"for-the-fewtel-community", "community_outgoing"},

             {"for-more-information-about-the-fewtel-remote-testing-facility",
              "challenge_info"},
             {"for-administration", "challenge_admin"}
--             {nil, "toorcamp_dialtone_incoming"}, -- testing
         },
         statement_dir="challenge"}),
    challenge_toorcamp_incoming = util.context(
        {intro_statements={},
         menu_entries={
             {"to-perform-the-challenges", "challenge_authenticate"},
             {"for-voicemail", "voicemail_outgoing"},
             {"for-the-fewtel-voice-conference", "futel-conf"},
             {"for-instructions", "challenge_instructions"},
             {"for-the-leaderboard", "challenge_leaderboard"},
             {"for-the-fewtel-community", "community_outgoing"},
             -- {"for-the-telecommunications-network", "network"},
             {"for-more-information-about-the-fewtel-remote-testing-facility",
              "challenge_info"}
         },
         statement_dir="challenge"})    
}

return extensions
