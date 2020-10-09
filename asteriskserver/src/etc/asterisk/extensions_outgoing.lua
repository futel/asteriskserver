util = require("util")

function outgoing_pre_menu(context_name)
    util.play_random_foreground(
        "/opt/asterisk/var/lib/asterisk/sounds/futel/williams-short")
    app.AGI("friction.agi", context_name)
    
end

function outgoing_portland_pre_bounce(context, exten)
    return util.bounce_context(
        function() return outgoing_pre_menu("outgoing_portland_menu") end,
        "outgoing_portland_menu")
end

function outgoing_ypsi_pre_bounce(context, exten)
    return util.bounce_context(
        function() return outgoing_pre_menu("outgoing_ypsi_menu") end,
        "outgoing_ypsi_menu")
end

function outgoing_detroit_pre_bounce(context, exten)
    return util.bounce_context(
        function() return outgoing_pre_menu("outgoing_detroit_menu") end,
        "outgoing_detroit_menu")
end

function outgoing_souwester_pre_bounce(context, exten)
    return util.bounce_context(
        function() return outgoing_pre_menu("outgoing_souwester_menu") end,
        "outgoing_souwester_menu")
end

local extensions = {
    outgoing_portland = util.context_array(outgoing_portland_pre_bounce, {}),
    outgoing_portland_menu = util.context(
        {intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "outgoing-voicemail"},
             [3]={"for-the-directory", "directory-ivr"},
             [4]={"for-utilities", "utilities-ivr"},
             [5]={"for-the-fewtel-community", "community-outgoing"},
             [6]={"for-community-services", "community-services-oregon"},
             [7]={"for-the-telecommunications-network", "network-ivr"},
             [8]={"for-hold-the-phone", "hold_the_phone_main"},
             [9]={nil, "911-9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    outgoing_ypsi = util.context_array(outgoing_ypsi_pre_bounce, {}),
    outgoing_ypsi_menu = util.context(
        {intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "outgoing-voicemail"},
             [3]={"for-the-directory", "directory-ivr-ypsi"},
             [4]={"for-utilities", "utilities-ivr-ypsi"},
             [5]={"for-the-fewtel-community", "community-outgoing"},
             [6]={"for-community-services", "community-services-michigan"},
             [7]={"for-the-telecommunications-network", "network-ivr"},
             [8]={"for-a-random-concentration-camp", "random-concentrationcamp"},
             [9]={nil, "911-9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    outgoing_detroit = util.context_array(outgoing_detroit_pre_bounce, {}),
    outgoing_detroit_menu = util.context(
        {intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "outgoing-voicemail"},
             [3]={"for-the-directory", "directory-ivr-detroit"},
             [4]={"for-utilities", "utilities-ivr-ypsi"}, -- note sharing with ypsi
             [5]={"for-the-fewtel-community", "community-outgoing"},
             [6]={"for-community-services", "community-services-michigan"},
             [7]={"for-the-telecommunications-network", "network-ivr"},
             [8]={"for-a-random-concentration-camp", "random-concentrationcamp"},
             [9]={nil, "911-9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    outgoing_souwester = util.context_array(outgoing_souwester_pre_bounce, {}),
    outgoing_souwester_menu = util.context(
        {intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "outgoing-voicemail"},
             [3]={"for-the-directory", "directory-ivr-souwester"},
             [4]={"for-utilities", "utilities-ivr-souwester"},
             [5]={"for-the-fewtel-community", "community-outgoing"},
             [6]={"for-the-telecommunications-network", "network-ivr"},
             [7]={"for-a-random-concentration-camp", "random-concentrationcamp"},
             [9]={nil, "911-9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"})
}

return extensions
