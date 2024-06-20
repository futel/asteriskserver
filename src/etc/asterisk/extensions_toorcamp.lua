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

function toorcamp_dial_outgoing(_context, exten)
    dialstring = util.get_dialstring(exten, 'shadytel-tcp')
    timeoutstring = util.get_timeoutstring(30) -- minutes
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
    -- XXX No timeout, will this DOS us or our upstream? But we want people
    -- to be able to leave an extension on speaker.
    app.Dial(dialstring)
    dialstatus = channel.DIALSTATUS:get()
    util.metric("incoming-dialstatus-" .. dialstatus .. "-" .. extension)
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
