util = require("util")

saratoga_extension = 405
central_extension = 410
breckenridge_extension = 415
microcosm_extension = 445
robotron_extension = 615
souwester_extension = 620
ypsi_extension = 630
alley27_extension = 640
taylor_extension = 655
ainsworth_extension = 680
detroitbusco_extension = 690
eighth_extension = 695

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
    util.metric("incoming-dialstatus-" .. dialstatus .. "-" .. identifier)
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

function ring_microcosm(context) 
    return ring_context(
        microcosm_extension,
        "microcosm",
        context)
end

-- Set up attributes for an incoming call coming from our
-- Twilio Programmable Voice SIP server, and go to the given context.
local function outgoing_twilio_pv(outgoing_context)
    -- Twilio service puts caller ID on x-callerid SIP header.
    caller_id = channel.PJSIP_HEADER("read", "x-callerid"):get()
    channel.CALLERID("number"):set(caller_id)    

    enable_emergency = channel.PJSIP_HEADER(
        "read", "x-enableemergency"):get()
    if enable_emergency == "true" then
        disable_911 = "no"
    else
        disable_911 = "yes"
    end
    channel.disable_911:set(disable_911)
    
    app.Goto(outgoing_context, "s", 1)
end


-- Extension to start a call from a Twilio SIP connection. These
-- extensions aren't entered from the keypad, they come from a SIP
-- URI.
-- In practice this is a Twilio Elastic SIP connection, used by
-- incoming calls from a Twilio phone number, or a SIP call from a
-- Twilio Programmable Voice SIP server.
context_array_incoming_twilio = {
    -- Calls received by a Twilio phone number and directd to the Twilio
    -- Elastic SIP Trunk are addressed to the E.164 phone number.
    [twilio_test_incoming]=function(context, exten)
        ring_microcosm(context) end,
    [twilio_taylor_incoming]=function(context, exten)
        ring_taylor(context) end,
    [twilio_ainsworth_incoming]=function(context, exten)
        ring_ainsworth(context) end,
    [twilio_ypsi_incoming]=function(context, exten)
        ring_ypsi(context) end,
    [twilio_alley27_incoming]=function(context, exten)
        ring_alley27(context) end,
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
    [twilio_microcosm_incoming]=function(context, exten)
        ring_microcosm(context) end,
    -- Calls from our Twilio SIP server are addressed to named contexts.
    -- We don't verify that the extension is calling the context we set
    -- it up for, and someone who gets the creds from a device or
    -- whatever could call any of them here. This should be OK because
    -- having a Futel phone lets you do most anything anyway.
    -- XXX set everything normally set in pjsip endpoints
    -- XXX 'outgoing' is obsolete?
    ["apology_intro"] = function(context, exten)
        outgoing_twilio_pv("apology_intro") end,
    ["community_outgoing"] = function(context, exten)
        outgoing_twilio_pv("community_outgoing") end,
    ["community_services_michigan"] = function(context, exten)
        outgoing_twilio_pv("community_services_michigan") end,
    ["community_services_oregon"] = function(context, exten)
        outgoing_twilio_pv("community_services_oregon") end,
    ["current-time"] = function(context, exten)
        outgoing_twilio_pv("current-time") end,
    ["current-time-ypsi"] = function(context, exten)
        outgoing_twilio_pv("current-time-ypsi") end,
    ["directory_detroit"] = function(context, exten)
        outgoing_twilio_pv("directory_detroit") end,
    ["directory_portland"] = function(context, exten)
        outgoing_twilio_pv("directory_portland") end,
    ["directory_safe"] = function(context, exten)
        outgoing_twilio_pv("directory_safe") end,
    ["directory_souwester"] = function(context, exten)
        outgoing_twilio_pv("directory_souwester") end,
    ["directory_ypsi"] = function(context, exten)
        outgoing_twilio_pv("directory_ypsi") end,
    ["futel-conf"] = function(context, exten)
        outgoing_twilio_pv("futel-conf") end,
    ["hold_the_phone_main"] = function(context, exten)
        outgoing_twilio_pv("hold_the_phone_main") end,
    ["information_futel"] = function(context, exten)
        outgoing_twilio_pv("information_futel") end,
    ["internal-dialtone-wrapper"] = function(context, exten)
        outgoing_twilio_pv("internal-dialtone-wrapper") end,
    ["network"] = function(context, exten)
        outgoing_twilio_pv("network") end,
    ["outgoing"] = function(context, exten)
        outgoing_twilio_pv("outgoing") end,
    ["outgoing-dialtone-wrapper"] = function(context, exten)
        outgoing_twilio_pv("outgoing-dialtone-wrapper") end,
    ["outgoing_portland"] = function(context, exten)
        outgoing_twilio_pv("outgoing_portland") end,
    ["outgoing_safe"] = function(context, exten)
        outgoing_twilio_pv("outgoing_safe") end,
    ["outgoing_ypsi"] = function(context, exten)
        outgoing_twilio_pv("outgoing_ypsi") end,        
    ["operator"] = function(context, exten)
        outgoing_twilio_pv("operator") end,
    ["random_number"] = function(context, exten)
        outgoing_twilio_pv("random_number") end,
    ["robotron"] = function(context, exten)
        outgoing_twilio_pv("robotron") end,
    ["trimet-transit-tracker"] = function(context, exten)
        outgoing_twilio_pv("trimet-transit-tracker") end,
    ["utilities_generic"] = function(context, exten)
        outgoing_twilio_pv("utilities_generic") end,
    ["voicemail_outgoing"] = function(context, exten)
        outgoing_twilio_pv("voicemail_outgoing") end,
    ["wildcard_line_outgoing"] = function(context, exten)
        outgoing_twilio_pv("wildcard_line_outgoing") end
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
    ring_central = util.destination_context(ring_central),
    ring_breckenridge = util.destination_context(ring_breckenridge),
    ring_saratoga = util.destination_context(ring_saratoga),
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
