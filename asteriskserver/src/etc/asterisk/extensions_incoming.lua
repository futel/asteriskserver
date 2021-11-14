util = require("util")

function operator_incoming(context, exten)
    app.AGI("metric.agi", context)
    app.VoiceMail(1337, "u")
end

local extensions = {
    incoming_leet = util.context(
        {intro_statements={
             "welcome-to-fewtel", "para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"for-voicemail", "voicemail_incoming"},
             [2]={"for-the-fewtel-community", "community-incoming"},
             [7]={nil, "member-auth"},
             [8]={nil, "admin-auth"},
             [9]={nil, "incoming-fake-admin-auth"},
             [0]={"to-speak-to-an-operator", "operator_incoming"}},
         statement_dir="incoming"}),
    operator_incoming = util.destination_context(operator_incoming)}

return extensions
