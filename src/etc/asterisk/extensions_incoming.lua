util = require("util")

saratoga_extension = 405
central_extension = 410
breckenridge_extension = 415
cesarchavez_extension = 420
microcosm_extension = 445
robotron_extension = 615
souwester_extension = 620
ypsi_extension = 630
alley27_extension = 640
taylor_extension = 655
r2d2_extension = 670
ainsworth_extension = 680
detroitbusco_extension = 690
eighth_extension = 695

twilio_r2d2_incoming = "+15033828838"
twilio_taylor_incoming = "+15039266271"
twilio_ainsworth_incoming = "+15034449412"
twilio_ypsi_incoming = "+17345476651"
twilio_alley27_incoming = "+15039288465"
twilio_robotron_incoming = "+15039266341"
twilio_souwester_incoming = "+13602282259"
twilio_eighth_incoming = "+15039266188"
twilio_breckenridge_incoming = "+13132469283"
twilio_detroitbusco_incoming = "+13133327495"
twilio_central_incoming = "+15034836584"
twilio_saratoga_incoming = "+15033889637"
twilio_cesarchavez_incoming = "+15039465227"
-- twilio_sjac_incoming = "+15032126899"
twilio_microcosm_incoming = "+15032945966"
twilio_test_incoming = "+19713512383"

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
function ring_context(extension, identifier, context)
    util.metric(context)
    dialstring = util.get_dialstring(extension, nil)
    app.Dial(dialstring)
    dialstatus = channel.DIALSTATUS:get()
    metric("incoming-dialstatus-" .. dialstatus .. "-" .. identifier)
end

function ring_ainsworth(context, exten)
    return ring_context(
        ainsworth_extension,
        "ainsworth",
        context)
end

function ring_detroitbusco(context) 
    return ring_context(
        detroitbusco_extension,
        "detroitbusco",
        context)
end

function ring_taylor(context) 
    return ring_context(
        taylor_extension,
        "taylor",
        context)
end

function ring_ypsi(context) 
    return ring_context(
        ypsi_extension,
        "ypsi",
        context)
end

function ring_alley27(context) 
    return ring_context(
        alley27_extension,
        "alley27",
        context)
end

function ring_robotron(context) 
    return ring_context(
        robotron_extension,
        "robotron",
        context)
end

function ring_souwester(context) 
    return ring_context(
        souwester_extension,
        "souwester",
        context)
end

function ring_eighth(context) 
    return ring_context(
        eighth_extension,
        "eighth",
        context)
end

function ring_r2d2(context) 
    return ring_context(
        r2d2_extension,
        "r2d2",
        context)
end

function ring_central(context) 
    return ring_context(
        central_extension,
        "central",
        context)
end

function ring_breckenridge(context) 
    return ring_context(
        breckenridge_extension,
        "breckenridge",
        context)
end

function ring_saratoga(context) 
    return ring_context(
        saratoga_extension,
        "saratoga",
        context)
end

function ring_cesarchavez(context) 
    return ring_context(
        cesarchavez_extension,
        "cesarchavez",
        context)
end

function ring_microcosm(context) 
    return ring_context(
        microcosm_extension,
        "microcosm",
        context)
end

-- Extension to start a call from a Twilio SIP connection. These
-- extensions aren't entered from the keypad, they come from a SIP
-- URI.
-- In practice this is a Twilio Elastic SIP connection, used by
-- incoming calls from a Twilio phone number or a SIP Dial verb
-- from a Twilio service.
context_array_incoming_twilio = {
    -- Calls received by a Twilio phone number and directd to the Twilio
    -- Elastic SIP Trunk are addressed to the E.164 phone number.
    [twilio_r2d2_incoming]=function(context, exten)
        ring_r2d2(context) end,
    [twilio_test_incoming]=function(context, exten)
        ring_microcosm(context) end,
    [twilio_taylor_incoming]=function(context, exten)
        ring_taylor(context) end,
    [twilio_ainsworth_incoming]=function(context, exten)
        ring_ainsworth(context) end,
    [twilio_ypsi_incoming]=function(context, exten)
        ring_ypsi(context) end,
    [twilio_robotron_incoming]=function(context, exten)
        ring_robotron(context) end,
    [twilio_souwester_incoming]=function(context, exten)
        ring_souwester(context) end,
    [twilio_eighth_incoming]=function(context, exten)
        ring_eighth(context) end,
    [twilio_breckenridge_incoming]=function(context, exten)
        ring_breckenridge(context) end,
    [twilio_detroitbusco_incoming]=function(context, exten)
        ring_detroitbusco(context) end,
    [twilio_central_incoming]=function(context, exten)
        ring_central(context) end,
    [twilio_saratoga_incoming]=function(context, exten)
        ring_saratoga(context) end,
    [twilio_cesarchavez_incoming]=function(context, exten)
        ring_cesarchavez(context) end,
    [twilio_microcosm_incoming]=function(context, exten)
        ring_microcosm(context) end,
    -- Calls from our Twilio Service are addressed to named contexts.
    -- We don't verify that the extension is calling the context we set
    -- it up for, and someone who gets the creds from a device or
    -- whatever could call any of them here. This should be OK because
    -- having a Futel phone lets you do most anything anyway.
    -- XXX set everything normally set in pjsip endpoints
    ["outgoing_portland"] = function(context, exten)
        app.Goto("outgoing_portland", "s", 1) end,
    ["outgoing_safe"] = function(context, exten)
        app.Goto("outgoing_safe", "s", 1) end,
}

local extensions = {
    incoming_twilio = context_array_incoming_twilio,
    incoming_leet = util.context(
        {pre_callable=util.bounce,
         intro_statements={
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
    ring_microcosm = util.destination_context(ring_microcosm),    
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
