util = require("util")

saratoga_extension = 405
central_extension = 410
breckenridge_extension = 415
cesarchavez_extension = 420
sjac_extension = 435
hedron_extension = 440
robotron_extension = 615
souwester_extension = 620
ypsi_extension = 630
alley27_extension = 640
taylor_extension = 655
r2d2_extension = 670
ainsworth_extension = 680
detroitbusco_extension = 690
eighth_extension = 695


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

-- ring phone at extension with termination, then metric with identifier
function ring_context(extension, termination, identifier, context)
    util.metric(context)
    dialstring = util.get_dialstring(extension, termination)
    app.Dial(dialstring)
    dialstatus = channel.DIALSTATUS:get()
    metric("incoming-dialstatus-" .. dialstatus .. "-" .. identifier)
end

function ring_ainsworth(context, exten)
    return ring_context(
        ainsworth_extension,
        nil,
        "ainsworth",
        context)
end

function ring_detroitbusco(context) 
    return ring_context(
        detroitbusco_extension,
        nil,
        "detroitbusco",
        context)
end

function ring_taylor(context) 
    return ring_context(
        taylor_extension,
        nil,
        "taylor",
        context)
end

function ring_ypsi(context) 
    return ring_context(
        ypsi_extension,
        nil,
        "ypsi",
        context)
end

function ring_alley27(context) 
    return ring_context(
        alley27_extension,
        nil,
        "alley27",
        context)
end

function ring_robotron(context) 
    return ring_context(
        robotron_extension,
        nil,
        "robotron",
        context)
end

function ring_souwester(context) 
    return ring_context(
        souwester_extension,
        nil,
        "souwester",
        context)
end

function ring_eighth(context) 
    return ring_context(
        eighth_extension,
        nil,
        "eighth",
        context)
end

function ring_r2d2(context) 
    return ring_context(
        r2d2_extension,
        nil,
        "r2d2",
        context)
end

function ring_central(context) 
    return ring_context(
        central_extension,
        "twilio",
        "central",
        context)
end

function ring_breckenridge(context) 
    return ring_context(
        breckenridge_extension,
        "twilio",
        "breckenridge",
        context)
end

function ring_saratoga(context) 
    return ring_context(
        saratoga_extension,
        "twilio",
        "saratoga",
        context)
end

function ring_cesarchavez(context) 
    return ring_context(
        cesarchavez_extension,
        "twilio",
        "cesarchavez",
        context)
end

function ring_hedron(context) 
    return ring_context(
        hedron_extension,
        nil,
        "hedron",
        context)
end

function ring_sjac(context) 
    return ring_context(
        sjac_extension,
        nil,
        "sjac",
        context)
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
    ring_ainsworth = util.destination_context(ring_ainsworth),
    ring_detroitbusco = util.destination_context(ring_detroitbusco),
    ring_taylor = util.destination_context(ring_taylor),
    ring_ypsi = util.destination_context(ring_ypsi),
    ring_alley27 = util.destination_context(ring_alley27),
    ring_robotron = util.destination_context(ring_robotron),
    ring_souwester = util.destination_context(ring_souwester),
    ring_eighth = util.destination_context(ring_eighth),
    ring_r2d2 = util.destination_context(ring_r2d2),
    ring_central = util.destination_context(ring_central),
    ring_breckenridge = util.destination_context(ring_breckenridge),
    ring_saratoga = util.destination_context(ring_saratoga),
    ring_cesarchavez = util.destination_context(ring_cesarchavez),
    ring_hedron = util.destination_context(ring_hedron),
    ring_sjac = util.destination_context(ring_sjac),
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
