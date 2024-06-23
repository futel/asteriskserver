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
    if (dialstatus == "CHANUNAVAIL") or (dialstatus == "CONGESTION") then
        app.Playtones("congestion")
        app.Congestion()
    end
end    

-- Continue with a random destination. Intended to be used by a call file.
-- XXX Coming from a call file breaks the endpoint field of the metrics,
--     util.py probably needs to be able to handle that.
-- XXX Coming from a call file breaks callerid.
-- XXX Can we wait for bridge to start? Will need that for conf?
-- XXX Dial timeout?
function toorcamp_dial_random(context, exten)
    util.metric(context)    
    parties = channel.CONFBRIDGE_INFO("parties", "666"):get()
    if parties ~= "0" then
        -- Conf is populated, send caller there.
        return app.ConfBridge(
            666, "futel_conf", "futel_conf_user", "futel_conf_menu")
    else
        -- Send caller to a random destination.
        -- XXX The extension space is probably sparse.
        --     We want to have a list of interesting numbers to prioritize:
        --     previous incoming callers, previous recipients, just interesting.
        rext = tostring(math.random(1000, 9999))
        return toorcamp_dial_outgoing(context, rext)
    end
end

function toorcamp_dial_outgoing(context, exten)
    util.metric(context)
    return toorcamp_dial(context, exten, "shadytel-tcp")
end

function toorcamp_dial_incoming(context, exten)
    util.metric(context)
    util.metric("incoming_extension_" .. exten)
    if exten == "3885" then     -- FUTL
        fn = challenge_toorcamp_incoming
    elseif exten == "2084" then
        fn = toorcamp_dial_random
    elseif exten == "4639" then -- HNDY
        fn = toorcamp_dial_random
    -- elseif exten == "5225" then -- JACK
    --    fn = toorcamp_dial        
    else    
        fn = toorcamp_dial
    end
    return fn(context, exten, nil)
end

local extensions = {
    toorcamp_dialtone_outgoing = util.destination_context(
        toorcamp_dialtone_outgoing),

    toorcamp_dialtone_incoming = util.destination_context(
        toorcamp_dialtone_incoming),
    toorcamp_dial_incoming = toorcamp_dial_context(toorcamp_dial_incoming),
    toorcamp_dial_outgoing = toorcamp_dial_context(toorcamp_dial_outgoing),
    toorcamp_dial_random = util.destination_context(
        toorcamp_dial_random),
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
             {"for-administration", "challenge_admin"}
--             {nil, "toorcamp_dialtone_incoming"}, -- testing
         },
         statement_dir="challenge"}),
    challenge_toorcamp_incoming = util.context(
        {menu_entries={
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
