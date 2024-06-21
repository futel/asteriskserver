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

-- call extension at shadytel endpoint, then metric with identifier
function toorcamp_dial_outgoing(_context, exten)
    dialstring = util.get_dialstring(exten, 'shadytel-tcp')
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

-- ring phone at extension, then metric with identifier
function toorcamp_dial_incoming(context, extension)
    util.metric(context)
    dialstring = util.get_dialstring(extension, nil)
    -- Begin monitoring call.
    app.AGI("get_filename.agi")
    filename = "incoming-" .. channel.agi_out:get() .. ".wav"
    app.MixMonitor(filename, "b")
    -- No timeout, will this DOS us or our upstream? But we want people
    -- to be able to leave an extension on speaker.
    app.Dial(dialstring)
    dialstatus = channel.DIALSTATUS:get()
    util.metric("incoming-dialstatus-" .. dialstatus .. "-" .. extension)
    if (dialstatus == "CHANUNAVAIL") or (dialstatus == "CONGESTION") then
        app.Playtones("congestion")
        app.Congestion()
    end
end

local extensions = {
    toorcamp_dialtone_outgoing = util.destination_context(
        toorcamp_dialtone_outgoing),
    -- probably only for testing
    toorcamp_dialtone_incoming = util.destination_context(
        toorcamp_dialtone_incoming),    
    toorcamp_dial_outgoing = toorcamp_dial_context(toorcamp_dial_outgoing),
    toorcamp_dial_incoming = toorcamp_dial_context(toorcamp_dial_incoming)
}

return extensions
