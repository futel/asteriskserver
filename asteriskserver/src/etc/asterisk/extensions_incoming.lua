util = require("util")

function operator_incoming(context, exten)
    util.metric(context)
    app.VoiceMail(1337, "u")
end

local extensions = {
    incoming_leet = util.context(
        {intro_statements={
             "welcome-to-fewtel", "para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"for-voicemail", "voicemail_incoming"},
             [2]={"for-the-fewtel-community", "community_incoming"},
             [7]={nil, "member-auth"},
             [8]={nil, "admin-auth"},
             [9]={nil, "incoming-fake-admin-auth"},
             [0]={"to-speak-to-an-operator", "operator_incoming"}},
         statement_dir="incoming"}),
    operator_incoming = util.destination_context(operator_incoming),
    community_incoming = util.context(
        {menu_entries={ 
             [1]={"for-the-fewtel-voice-conference", "futel-conf"},
             [2]={"for-the-wildcard-line", "wildcard_line_incoming"},
             [3]={"for-the-church-of-robotron", "robotron"},
             [4]={"to-ring-a-fewtel-telephone", "internal-dialtone-wrapper"},
             [5]={"for-hold-the-phone", "hold_the_phone_main"},
             [6]={"for-the-apology-service", "apology_intro"},
             [7]={"for-more-information-about-fewtel", "information_futel"}},
         statement_dir="community"})}

return extensions
