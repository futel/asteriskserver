util = require("util")

function operator(context, exten)
    util.metric(context)    
    app.UserEvent("OperatorAttempt")
    util.say("please-hold")
    util.say("for-the-next-available-operator")
    app.FollowMe("operator", "d")
    -- if we got here, no operator accepted
    util.metric("operator-nopickup")
    app.UserEvent("OperatorNoPickup")
    app.VoiceMail(1337, "u")
end

-- Filter and friction, if we pass, dial exten with timeout.
function filterdial(context, exten)
    metric(context)
    -- filter or die
    app.AGI("filter_outgoing.agi", exten)
    -- friction, which may or may not die
    app.AGI("friction.agi", context)
    -- we passed, find timeout, if any, and dial
    app.AGI("call_timeout.agi")
    internaldial(exten, channel.agi_out:get())
end

-- Dial exten.
function dial(context, exten)
    metric(context)
    internaldial(exten, "")
end

function get_dialstring(number, outgoingchannel)
    return "SIP/" .. number .. "@" .. outgoingchannel
end

function get_timeoutstring(timeout)
    return "g" .. timeout
end

-- Dial number with timeout in dial command syntax (which can be empty).
function internaldial(number, timeout)
    metric("internaldial")
    -- wait for ratelimiter
    app.AGI("call_ratelimit.agi")
    dialstring = get_dialstring(number, channel.outgoingchannel:get())
    timeoutstring = get_timeoutstring(timeout)
    -- start trying to dial
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
    operator = util.destination_context(operator),
    filterdial = util.dial_context(filterdial),
    information_futel = util.context(
        {intro_statements={
             "fewtel-is-portlands-most-exclusive-telephone-network",
             "fewtel-provides-telephony-and-voicemail-and-human-and-machine-interaction",
             "all-services-are-free-from-any-fewtel-phone",
             "for-more-information-contact-the-operator-from-any-fewtel-phone-or-visit-our-website-at-fewtel-dot-net"},
         menu_entries={},         
         statement_dir="information"})}

return extensions
