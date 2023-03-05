util = require("util")

function operator(context, exten)
    util.metric(context)    
    util.say("please-hold")
    util.say("for-the-next-available-operator")
    app.FollowMe("operator", "d")
    -- If we get here, either no operator accepted, or the caller hung
    -- up before an operator could accept. There doesn't seem to be a way
    -- to tell which, so don't try to metric. Not sure what happens to
    -- voicemail in that case, but it's not causing issues.
    -- util.metric("operator-nopickup")
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
    util.internaldial(exten, channel.agi_out:get())
end

-- Dial exten.
function dial(context, exten)
    metric(context)
    util.internaldial(exten, "")
end

local extensions = {
    operator = util.context_array(operator, {}),
    filterdial = util.dial_context(filterdial),
    dial = util.dial_context(dial),    
    information_futel = util.context(
        {intro_statements={
             "fewtel-is-portlands-most-exclusive-telephone-network",
             "fewtel-provides-telephony-and-voicemail-and-human-and-machine-interaction",
             "all-services-are-free-from-any-fewtel-phone",
             "for-more-information-contact-the-operator-from-any-fewtel-phone-or-visit-our-website-at-fewtel-dot-net"},
         menu_entries={},         
         statement_dir="information"})}

return extensions
