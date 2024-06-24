util = require("util")
math = require("math")
math.randomseed(os.clock()*100000000000)

function toorcamp_dialtone_outgoing(context, exten)
    util.metric(context)
    app.DISA("no-password", "toorcamp_dial_outgoing")
end

function toorcamp_dialtone_incoming(context, exten)
    util.metric(context)    
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

-- Dial exten on outgoing_channel, metric.
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
    metric(
        "toorcamp-outgoing-dialstatus-" .. tostring(outgoing_channel) .. "-" .. dialstatus)
    if (dialstatus == "CHANUNAVAIL") or (dialstatus == "CONGESTION") then
        app.Playtones("congestion")
        app.Congestion()
    end
end    

-- Send caller to a random outgoing destination.
-- XXX Coming from a call file breaks callerid.
-- XXX Can we wait for bridge to start? Will need that for conf?
-- XXX Dial timeout?
function toorcamp_dial_random(context, exten)
    util.metric(context)    
    -- XXX The extension space is probably sparse.
    --     We want to have a list of interesting numbers to prioritize:
    --     previous incoming callers, previous recipients, just interesting.
    rext = tostring(math.random(1000, 9999))
    return toorcamp_dial_outgoing(context, rext)
end

-- Continue with a random destination. Intended to be used by a call file.
-- XXX Coming from a call file breaks the endpoint field of the metrics,
--     util.py probably needs to be able to handle that.
-- XXX add some content maybe, also for dedicated lines
function toorcamp_random_destination(context, exten)
    util.metric(context)    
    parties = channel.CONFBRIDGE_INFO("parties", "666"):get()
    if parties ~= "0" then
        -- Conf is populated, send caller there.
        return app.ConfBridge(
            "666", "futel_conf", "futel_conf_user", "futel_conf_menu")
    else
        return toorcamp_dial_random(context, exten)
    end
end

function toorcamp_dial_outgoing(context, exten)
    util.metric(context)
    return toorcamp_dial(context, exten, "shadytel-tcp")
end

-- Should just use the context/extension map for these.
function toorcamp_dial_incoming(context, exten)
    util.metric(context)
    util.metric("incoming_extension_" .. exten)
    if exten == "3885" then     -- FUTL
        util.goto_context(
            'challenge_toorcamp_incoming', context, exten)
    elseif exten == "2084" then
        toorcamp_random_destination(context, exten)
    elseif exten == "4639" then -- HNDY
        toorcamp_random_destination(context, exten)
    end
    -- also elseif exten == "5225" then -- JACK
    -- Call local extension.
    toorcamp_dial(context, exten, nil)
end

local extensions = {
    challenge_toorcamp_incoming = util.context(
        {menu_entries={
             {"to-perform-the-challenges", "challenge_authenticate"},
             {"for-voicemail", "voicemail_outgoing"},
             {"for-the-fewtel-voice-conference", "futel-conf"},
             {"for-instructions", "challenge_instructions"},
             {"for-the-leaderboard", "challenge_leaderboard"},
             {"for-the-fewtel-community", "community_outgoing"},
             {"for-more-information-about-the-fewtel-remote-testing-facility",
              "challenge_info"}},
         statement_dir="challenge"}),
    challenge_toorcamp_outgoing = util.context(
        {menu_entries={
             {"to-make-a-call", "toorcamp_dialtone_outgoing"},             
             {"to-perform-the-challenges", "challenge_authenticate"},
             {"for-voicemail", "voicemail_outgoing"},
             {"for-the-fewtel-voice-conference", "futel-conf"},
             {"for-instructions", "challenge_instructions"},
             {"for-the-leaderboard", "challenge_leaderboard"},
             {"for-the-fewtel-community", "community_outgoing"},
             {"for-more-information-about-the-fewtel-remote-testing-facility",
              "challenge_info"},
             -- {"for-the-telecommunications-network", "network"},
             {"for-administration", "toorcamp_admin"}},
         statement_dir="challenge"}),
    toorcamp_admin = util.context(
        {menu_entries={
             {"for-administration", "challenge_admin"},
             {"for-an-internal-dialtone", "toorcamp_dialtone_incoming"},
             {"for-voicemail", "voicemail_outgoing"}},
         statement_dir="challenge"}),
    toorcamp_dial_random = util.destination_context(toorcamp_dial_random),
    toorcamp_dialtone_outgoing = util.destination_context(
        toorcamp_dialtone_outgoing),
    toorcamp_dialtone_incoming = util.destination_context(
        toorcamp_dialtone_incoming),
    toorcamp_dial_incoming = toorcamp_dial_context(toorcamp_dial_incoming),
    toorcamp_dial_outgoing = toorcamp_dial_context(toorcamp_dial_outgoing),
    toorcamp_random_destination = util.destination_context(
        toorcamp_random_destination)
}

return extensions
