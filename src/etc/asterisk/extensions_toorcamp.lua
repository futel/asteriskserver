util = require("util")

function toorcamp_incoming(context, exten)
    util.metric(context)
    dial_local(context, exten)
end

function toorcamp_dialtone(context, exten)
    app.DISA("no-password", "toorcamp_dial")
end

-- Return context array which immediately starts destination_function
-- when called with a possibly dialable extension. Dialable extensions
-- are four digits.
function toorcamp_dial_context(destination_function)
    local context_array = {}
    context_array["_XXXX"] = destination_function
    return context_array
end

function toorcamp_dial(_context, exten)
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

local extensions = {
    toorcamp_dialtone = util.destination_context(toorcamp_dialtone),
    toorcamp_dial = toorcamp_dial_context(toorcamp_dial),
    toorcamp_incoming = util.destination_context(
        toorcamp_incoming)
}

return extensions
