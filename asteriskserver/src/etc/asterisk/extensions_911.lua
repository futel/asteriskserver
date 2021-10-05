util = require("util")

voipms_leet_incoming = "+15034681337"

-- return true if the calling extension should be allowed to call 911
function is_911_enabled()
    callerid = channel.callerid:get()
    if callerid == voipms_leet_incoming then
        return false
    end
    -- assume our callerid is a valid outgoing number
    -- assume any valid outgoing number has 911 provisioned
    return true
end

function call_911(context, extension)
    app.AGI("metric.agi", context)
    if is_911_enabled() then
        util.say("dialing-nine-one-one")
        app.Macro("dial", "911")
    else
        app.Busy()
    end
end

-- busy on anything but next 911 digit
context_array_9 = {
    ["s"]=function(context, exten) app.WaitExten(5) end,
    ["i"]=function(context, exten) app.Busy() end,
    ["t"]=function(context, exten) app.Busy() end,
    [1]=function(context, exten)
        goto_context('call_911_91', context, exten) end
}

-- busy on anything but next 911 digit
context_array_91 = {
    ["s"]=function(context, exten) app.WaitExten(5) end,
    ["i"]=function(context, exten) app.Busy() end,
    ["t"]=function(context, exten) app.Busy() end,
    [1]=function(context, exten)
        goto_context('call_911_911', context, exten) end
}

local extensions = {
    call_911_9 = context_array_9,
    call_911_91 = context_array_91,
    call_911_911 = util.context_array(call_911, {})
}

return extensions
