conf = require("conf")
util = require("util")

function bounce()
    if util.lockfile_exists() then
        app.Goto("voicemail_bounce", "s", 1)
    end
end

function voicemail_check(context, exten)
    bounce()
    app.AGI("metric.agi", context)
    app.VoiceMailMain()
end

function voicemail_create(context, exten)
    bounce()
    app.AGI("metric.agi", context)    
    util.say(
        "voicemail-can-be-accessed-from-any-fewtel-phone-or-from-the-fewtel-incoming-line",
        "voicemail")
    app.AGI("next_vm.agi")
    vmbox = channel.vmbox:get()
    -- XXX
    app.system(conf.asterisk_root .. "/sbin/asterisk -x 'voicemail reload'")
    app.VoiceMailMain(vmbox)
end

function voicemail_leave(context, exten)
    bounce()
    app.AGI("metric.agi", context)
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
    voicemail_information = util.context(
        {intro_statements={
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
         menu_entries={},
         statement_dir="voicemail"}),
    voicemail_bounce = util.context(
        {intro_statements={
             "this-system-is-temporarily-down-for-maintenance",
             "try-again-later"},
         menu_entries={},
         statement_dir="voicemail"}),
    voicemail_check = util.destination_context(voicemail_check),
    voicemail_create = util.destination_context(voicemail_create),
    voicemail_leave = util.destination_context(voicemail_leave)}

return extensions
