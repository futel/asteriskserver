util = require("util")

function bounce()
    if util.lockfile_exists() then
        app.Goto("voicemail_bounce", "s", 1)
    end
end

function voicemail_check(context, exten)
    bounce()
    util.metric(context)
    app.VoiceMailMain()
end

function voicemail_create(context, exten)
    bounce()
    util.metric(context)    
    util.say(
        "voicemail-can-be-accessed-from-any-fewtel-phone-or-from-the-fewtel-incoming-line",
        "voicemail")
    app.AGI("next_vm.agi")
    vmbox = channel.vmbox:get()
    -- XXX
    app.system("/sbin/asterisk -x 'voicemail reload'")
    app.VoiceMailMain(vmbox)
end

function voicemail_leave(context, exten)
    bounce()
    util.metric(context)
    app.VoiceMail()
end

local extensions = {
    voicemail_outgoing = util.context(
        {menu_entries={
             [1]={"to-check-your-voicemail", "voicemail_check"},
             [2]={"to-create-a-new-voicemail-box", "voicemail_create"},
             [3]={"to-leave-a-voicemail", "voicemail_leave"},
             [4]={"for-more-information-about-the-fewtel-voicemail-system",
                  "voicemail_information"}},
         statement_dir="voicemail"}),
    voicemail_incoming = util.context(
        {menu_entries={
             [1]={"to-check-your-voicemail", "voicemail_check"},
             [2]={"to-leave-a-voicemail", "voicemail_leave"},
             [3]={"for-more-information-about-the-fewtel-voicemail-system",
                  "voicemail_information"}},
         statement_dir="voicemail"}),
    voicemail_information = util.statement_context(
        {statements={
             "voicemail-boxes-in-the-fewtel-voicemail-system-can-be-created-from-any-fewtel-phone",
             "voicemail-boxes-in-the-fewtel-voicemail-system-can-be-accessed-from-any-fewtel-phone-or-from-the-fewtel-incoming-line",
             "at",
             "five",
             "zero",
             "three",
             "four",
             "six",
             "eight",
             "one",
             "three",
             "three",
             "seven",
             "again",
             "at",
             "five",
             "zero",
             "three",
             "four",
             "six",
             "eight",
             "one",
             "three",
             "three",
             "seven"},
         statement_dir="voicemail"}),
    voicemail_bounce = util.statement_context(
        {statements={
             "this-system-is-temporarily-down-for-maintenance",
             "try-again-later"},
         statement_dir="voicemail"}),
    voicemail_check = util.context_array(voicemail_check, {}),
    voicemail_create = util.context_array(voicemail_create, {}),
    voicemail_leave = util.context_array(voicemail_leave, {})}

return extensions
