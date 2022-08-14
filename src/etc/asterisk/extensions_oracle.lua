util = require("util")

function oracle_dead_intro_pre()
    util.play_random_background(
        "/var/lib/asterisk/sounds/futel/oracle-dead-interstitial-long")
    util.say("oracle-dead-intro-hello", oracle-dead)
    util.say("oracle-dead-intro-to-skip-instructions", oracle-dead)
    util.say("oracle-dead-intro-motivation", oracle-dead)
    util.say("oracle-dead-intro-no-guarantee-content", oracle-dead)
    util.say("press-any-key-to-continue", oracle-dead)
end

function oracle_dead_instructions_pre()
    util.say("oracle-dead-instructions-enter-numbers", oracle-dead)
    util.say("oracle-dead-instructions-enter-numbers-details", oracle-dead)
    util.say("oracle-dead-instructions-enter-numbers-examples", oracle-dead)
    util.say("oracle-dead-instructions-enter-numbers-many", oracle-dead)
    util.say("press-any-key-to-continue", oracle-dead)
end

function oracle_dead_setup_pre()
    util.say("oracle-dead-instructions-when-ready", oracle-dead)
end

function oracle_dead_sound_intro_pre()
    util.play_random_background(
        "/var/lib/asterisk/sounds/futel/oracle-dead-interstitial-long")
    util.say("oracle-dead-setup-attempting", oracle-dead)
    util.say("oracle-dead-intro-no-guarantee-content", oracle-dead)
    util.say("oracle-dead-intro-no-guarantee-content", oracle-dead)    
    util.say("oracle-dead-setup-to-relinquish", oracle-dead)
end

function oracle_dead_sound_pre()
    util.play_random_background(
        "/var/lib/asterisk/sounds/futel/oracle-dead-oracle")
end

-- [oracle-dead-entry]
-- exten => s,1,NoOp
-- same => n,Macro(setup-iteration)
-- same => n,Set(numbers=0)
-- same => n(postsetup),NoOp
-- same => n,Macro(say,oracle-dead-instructions-enter-number,oracle-dead)
-- same => n,Macro(iterate-guard)
-- same => n(digit),WaitExten(10)
-- same => n,Goto(s,postsetup) ; on timeout, prompt from the start again
-- ; on any digit except * or #, collect another digit
-- exten => i,1,NoOp
-- same => n,Goto(s,digit)  ; collect another digit
-- exten => #,1,NoOp
-- same => n,Set(numbers=$[${numbers} + 1])
-- same => n,AGI(random_file_strip.agi,/var/lib/asterisk/sounds/futel/oracle-dead-interstitial-short)
-- same => n,Background(${agi_out})
-- same => n,Macro(say,thank-you,oracle-dead)
-- same => n,Macro(say,oracle-dead-instructions-enter-number-again,oracle-dead)
-- same => n,Goto(s,digit)         ; collect another
-- exten => *,1,NoOp
-- ; if 3 or more entered, done, else nag
-- same => n,gotoIf($[${numbers} > 2]?done)
-- same => n,Macro(say,oracle-dead-instructions-enter-numbers-more,oracle-dead)
-- same => n,Macro(say,oracle-dead-instructions-enter-numbers-why,oracle-dead)
-- same => n,Macro(say,oracle-dead-instructions-enter-number,oracle-dead)
-- same => n,Goto(s,digit)
-- same => n(done),NoOp
-- same => n,Macro(say,oracle-dead-thank-you-for-using-fewtel,oracle-dead)
-- same => n,Return

-- [oracle-dead-debrief]
-- exten => s,1,NoOp
-- same => n,Macro(say,oracle-dead-thank-you-for-using-fewtel,oracle-dead)
-- same => n,Macro(say,oracle-dead-debrief-to-share,oracle-dead)
-- same => n,Macro(say,oracle-dead-debrief-otherwise,oracle-dead)
-- same => n,WaitExten(30)
-- same => n,Return
-- ;exten => #,1,Macro(say,oracle-dead-debrief-record,oracle-dead)
-- exten => #,1,VoiceMail(1340,u)
-- same => n,Return
-- exten => i,1,Return

-- oracle-dead-intro,s,1)
-- oracle-dead-instructions,s,1)
-- oracle-dead-entry,s,1)
-- oracle-dead-setup,s,1)
-- oracle-dead-sound-intro,s,1)
-- oracle-dead-sound,s,1)
-- oracle-dead-debrief,s,1)
-- oracle-dead-thank-you-for-using-fewtel

local extensions = {    
    oracle_dead = util.context()}

return extensions
