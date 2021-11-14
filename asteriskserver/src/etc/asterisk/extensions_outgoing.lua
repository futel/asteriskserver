conf = require("conf")
util = require("util")

function outgoing_pre_menu(context_name)
    -- Note that this is the first interaction on handset pickup, so
    -- friction should not be configured to block or ignore possible
    -- 911 digits.
    app.AGI("friction.agi", context_name)
    util.play_random_background(
        conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/williams-short")
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

local extensions = {
    outgoing_portland = util.context(
        {pre_callable=outgoing_portland_pre_bounce,
         intro_statements={"para-espanol", "oprima-estrella"},
         menu_entries={ 
             [1]={"to-make-a-call", "outgoing-dialtone-wrapper"},
             [2]={"for-voicemail", "voicemail_outgoing"},
             [3]={"for-the-directory", "directory_portland"},
             [4]={"for-utilities", "utilities-ivr"},
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-community-services", "community-services-oregon"},
             [7]={"for-the-telecommunications-network", "network-ivr"},
             [8]={"for-a-random-concentration-camp", "directory_random_concentrationcamp"},
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
             [4]={"for-utilities", "utilities-ivr-ypsi"},
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-community-services", "community-services-michigan"},
             [7]={"for-the-telecommunications-network", "network-ivr"},
             [8]={"for-a-random-concentration-camp", "directory_random_concentrationcamp"},
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
             [4]={"for-utilities", "utilities-ivr-ypsi"}, -- note sharing with ypsi
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-community-services", "community-services-michigan"},
             [7]={"for-the-telecommunications-network", "network-ivr"},
             [8]={"for-a-random-concentration-camp", "directory_random_concentrationcamp"},
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
             [4]={"for-utilities", "utilities-ivr-souwester"},
             [5]={"for-the-fewtel-community", "community_outgoing"},
             [6]={"for-the-telecommunications-network", "network-ivr"},
             [7]={"for-a-random-concentration-camp", "directory_random_concentrationcamp"},
             [9]={nil, "call_911_9"},
             [0]={"for-the-operator", "operator"}},
         statement_dir="outgoing"}),
    community_outgoing = util.context(
        {menu_entries={ 
             [1]={"for-the-fewtel-voice-conference", "futel-conf"},
             [2]={"for-the-wildcard-line", "wildcard_line_outgoing"},
             [3]={"for-the-church-of-robotron", "robotron"},
             [4]={"to-ring-a-fewtel-telephone", "internal-dialtone-wrapper"},
             [5]={"for-hold-the-phone", "hold_the_phone_main"},
             [6]={"for-the-apology-service", "apology-service-ivr"},
             [7]={"for-more-information-about-fewtel", "information_futel"}},
         statement_dir="community"}),
}

return extensions
