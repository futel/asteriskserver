util = require("util")

function operator_incoming(context, exten)
    util.metric(context)
    app.VoiceMail(1337, "u")
end

function fake_admin_auth(context, exten)
    util.metric(context)
    app.Authenticate(592751)
end

function admin_auth(context, exten)
    util.metric(context)
    app.AGI("incoming_ratelimit.agi")
    app.Authenticate(channel.admin_password:get())
    app.Wait(0.25)             -- avoid digits leaking into next menu
    app.Goto("admin_main", "s", 1)
end

function member_auth(context, exten)
    util.metric(context)
    app.AGI("incoming_ratelimit.agi")
    app.Authenticate(channel.member_password:get())
    app.Wait(0.25)             -- avoid digits leaking into next menu
    app.Goto("member_main", "s", 1)
end

local extensions = {
    incoming_leet = util.context(
        {intro_statements={
             "welcome-to-fewtel", "para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"for-voicemail", "voicemail_incoming"},
             [2]={"for-the-fewtel-community", "community_incoming"},
             [7]={nil, "member_auth"},
             [8]={nil, "admin_auth"},
             [9]={nil, "fake_admin_auth"},
             [0]={"to-speak-to-an-operator", "operator_incoming"}},
         statement_dir="incoming"}),
    operator_incoming = util.destination_context(operator_incoming),
    member_auth = util.destination_context(member_auth),
    admin_auth = util.destination_context(admin_auth),        
    fake_admin_auth = util.destination_context(fake_admin_auth),    
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
