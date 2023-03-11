util = require("util")

function outgoing_pre_menu(context_name)
    util.bounce()
    -- Note that this is the first interaction on handset pickup, so
    -- friction should not be configured to block or ignore possible
    -- 911 digits.
    app.AGI("friction.agi", context_name)
    util.play_random_background(
        "/var/lib/asterisk/sounds/futel/williams-short")
end

function outgoing_portland_pre_bounce()
    outgoing_pre_menu("outgoing_portland_menu")
end

function outgoing_ypsi_pre_bounce()
    outgoing_pre_menu("outgoing_ypsi_menu")
end

function outgoing_detroit_pre_bounce()
    outgoing_pre_menu("outgoing_detroit_menu")
end

function outgoing_souwester_pre_bounce()
    outgoing_pre_menu("outgoing_souwester_menu")
end

function outgoing_safe_pre_bounce()
    outgoing_pre_menu("outgoing_safe_menu")
end

function goto_parent_context_context(context, exten)
    util.goto_parent_context()
end

local extensions = {
    outgoing_portland = util.context(
        {pre_callable=outgoing_portland_pre_bounce,
         intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "voicemail_outgoing"},
             [3]={"for-the-directory", "directory_portland"},
             [4]={"for-utilities", "utilities_portland"},
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-community-services", "community_services_oregon"},
             [7]={"for-the-telecommunications-network", "network"},
             [9]={nil, "call_911_9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    outgoing_ypsi = util.context(
        {pre_callable=outgoing_ypsi_pre_bounce,
         intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "voicemail_outgoing"},
             [3]={"for-the-directory", "directory_ypsi"},
             [4]={"for-utilities", "utilities_generic"},
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-community-services",
                  "community_services_michigan"},
             [7]={"for-the-telecommunications-network", "network"},
             [9]={nil, "call_911_9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    outgoing_detroit = util.context(
        {pre_callable=outgoing_detroit_pre_bounce,
         intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "voicemail_outgoing"},
             [3]={"for-the-directory", "directory_detroit"},
             [4]={"for-utilities", "utilities_generic"},
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-community-services",
                  "community_services_michigan"},
             [7]={"for-the-telecommunications-network", "network"},
             [9]={nil, "call_911_9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    outgoing_souwester = util.context(
        {pre_callable=outgoing_souwester_pre_bounce,
         intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "voicemail_outgoing"},
             [3]={"for-the-directory", "directory_souwester"},
             [4]={"for-utilities", "utilities_generic"},
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-the-telecommunications-network", "network"},
             [9]={nil, "call_911_9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    outgoing_safe = util.context(
        {pre_callable=outgoing_safe_pre_bounce,
         intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "voicemail_outgoing"},
             [3]={"for-the-directory", "directory_safe"},
             [4]={"for-utilities", "utilities_generic"},
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-the-telecommunications-network", "network"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    community_outgoing = util.context(
        {menu_entries={ 
             [1]={"for-the-fewtel-voice-conference", "futel-conf"},
             [2]={"for-the-wildcard-line", "wildcard_line_outgoing"},
             [3]={"for-the-church-of-robotron", "robotron"},
             [4]={"to-ring-a-fewtel-telephone", "internal-dialtone-wrapper"},
             [5]={"for-hold-the-phone", "hold_the_phone_main"},
             [6]={"for-the-apology-service", "apology_intro"},
             [7]={"for-more-information-about-fewtel", "information_futel"}},
         statement_dir="community"}),
    goto_parent_context = util.destination_context(
        goto_parent_context_context)
}

return extensions
