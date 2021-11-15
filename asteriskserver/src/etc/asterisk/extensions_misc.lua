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

local extensions = {
    operator = util.destination_context(operator),
    information_futel = util.context(
        {intro_statements={
             "fewtel-is-portlands-most-exclusive-telephone-network",
             "fewtel-provides-telephony-and-voicemail-and-human-and-machine-interaction",
             "all-services-are-free-from-any-fewtel-phone",
             "for-more-information-contact-the-operator-from-any-fewtel-phone-or-visit-our-website-at-fewtel-dot-net"},
         menu_entries={},         
         statement_dir="information"})}

return extensions
