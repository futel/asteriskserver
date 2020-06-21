function vmauthenticate()
    if channel.AUTH_MAILBOX:get() then
        return channel.AUTH_MAILBOX:get()
    end
    say("authenticate-with-your-voice-mail-box-to-continue")
    app.VMAuthenticate()
    return channel.AUTH_MAILBOX:get()
end

function challenge_has_value(mailbox, value)
    app.AGI("challenge_has_value.agi", mailbox, value)
    out = channel.agi_out:get()
    return out == "True"
end

-- hangup if requirement is not met, notify if achievment is met
function check_access(mailbox, requirement, achievement)
    if not mailbox then
        -- cheap way to get around user skipping authentication
        say("access-denied")            
        return goto_main()
    end
    if requirement ~= nil then
        if not challenge_has_value(mailbox, requirement) then
            say("access-denied")
            return goto_main()
        end
    end
    if challenge_has_value(mailbox, achievement) then
        say("warning-access-already-granted")
    end
end

function challenge_mailbox(mailbox)
    filename = "/opt/asterisk/var/spool/asterisk/voicemail/default/" .. mailbox .. "/greet.wav"
    if not io.open(filename, "r") then
        for i=1,10 do
            say("record-your-name-in-your-voicemail-account-for-access")
        end
        app.Hangup() 
    end    
end

function challenge_progged(mailbox)
    app.AGI("progged.agi")
    -- if we get here we won
end

function challenge_wumpus(mailbox)
    app.AGI("wumpus.agi")
    -- if we get here we won
end

function challenge_konami(mailbox)
    app.AGI("konami.agi")
    -- if we get here we won
end

function challenge_sequence_one(mailbox)
    app.AGI("sequence_one.agi")
    -- if we get here we won
end

function challenge_sequence_two(mailbox)
    app.AGI("sequence_two.agi")
    -- if we get here we won
end

function challenge_sequence_three(mailbox)
    app.AGI("sequence_three.agi")
    -- if we get here we won
end

function challenge_sequence_four(mailbox)
    app.AGI("sequence_four.agi")
    -- if we get here we won
end

function goto_main()
    return app.Goto("challenge_main", "s", 1)
end

-- perform pre and post actions for challenge
function do_challenge(requirement, achievement, challenge_call)
    mailbox = channel.AUTH_MAILBOX:get()
    check_access(mailbox, requirement, achievement)
    challenge_call(mailbox)
    app.AGI("challenge_write.agi", mailbox, achievement)    
    say("access-granted")
    return goto_main()
end

function menu_challenge_mailbox(context, extension)
    do_challenge(nil, "achievement-mailbox", challenge_mailbox)
end

function menu_challenge_progged(context, extension)
    do_challenge("achievement-mailbox", "achievement-progged", challenge_progged)
end

function menu_challenge_wumpus(context, extension)
    do_challenge("achievement-mailbox", "achievement-wumpus", challenge_wumpus)
end

function menu_challenge_konami(context, extension)
    do_challenge("achievement-mailbox", "achievement-konami", challenge_konami)
end

function menu_challenge_sequence_one(context, extension)
    do_challenge(
        "achievement-mailbox-xxx-dummy",
        "achievement-sequence-one",
        challenge_sequence_one)
end

function menu_challenge_sequence_two(context, extension)
    do_challenge(
        "achievement-sequence-one",
        "achievement-sequence-two",
        challenge_sequence_two)
end

function menu_challenge_sequence_three(context, extension)
    do_challenge(
        "achievement-sequence-two",
        "achievement-sequence-three",
        challenge_sequence_three)
end

function menu_challenge_sequence_four(context, extension)
    do_challenge(
        "achievement-sequence-three",
        "achievement-sequence-four",
        challenge_sequence_four)
end

function menu_challenge_main(context, extension)
    return menu(
        {"to-perform-the-challenges",
         "press-one",
         "for-voicemail",
         "press-two",
         "for-the-fewtel-voice-conference",
         "press-three",
         "for-instructions",
         "press-four",         
         "for-the-leaderboard",
         "press-five",
         "for-the-fewtel-community",
         "press-six"},
        "challenge",
        context,
        extension)
end

function menu_challenge_list(context, extension)
    mailbox = vmauthenticate()
    -- XXX hide items when requirements not met
    return menu(
        {"for-challenge-mailbox",
	"press-one",
	"for-challenge-progged",
	"press-two",
	"for-challenge-hunt-the-wumpus",
	"press-three",
	"for-challenge-konami",
	"press-four",
        "for-challenge-sequence-one",
        "press-five",
        "for-challenge-sequence-two",
        "press-six",
        "for-challenge-sequence-three",
        "press-seven",
        "for-challenge-sequence-four",
        "press-eight"},
        "challenge",
        context,
        extension)
end

function menu_challenge_information(context, extension)
    return menu(
        {"welcome-to-the-fewtel-remote-testing-facility",
         "access-is-granted-as-challenges-are-successfully-completed",
         "complete-all-challenges-to-qualify",
         "for-more-information-contact-the-operator-from-any-fewtel-phone-or-visit-our-website-at-fewtel-dot-net",
         "good-luck",
         "all-must-be-tested",         
         "all-must-be-tested",
         "all-must-be-tested"},
        "challenge",
        context,
        extension)
end

function menu_challenge_leaderboard(context, extension)
        say("access-denied")
        say("access-denied")
        say("access-denied")
        say("access-denied")
        say("access-denied")
        return goto_main()
end

extensions_challenge = {
    challenge_main = context(
        menu_challenge_main,
        "challenge_main",
        {"challenge_list",
         "outgoing-voicemail",  -- extensions.conf
         "futel-conf",  -- extensions.conf         
         "challenge_information",
         "challenge_leaderboard",
         "community-outgoing", -- extensions.conf
         });
    challenge_information = context(
        menu_challenge_information, "challenge_main", {});
    challenge_leaderboard = context(
        menu_challenge_leaderboard, "challenge_main", {});
    challenge_list = context(
        menu_challenge_list,
        "challenge_main",
        {"challenge_mailbox",
         "challenge_progged",
         "challenge_wumpus",
         "challenge_konami",
         "challenge_sequence_one",
         "challenge_sequence_two",
         "challenge_sequence_three",
         "challenge_sequence_four"});
    challenge_mailbox = context(menu_challenge_mailbox, "challenge_main", {});
    challenge_progged = context(menu_challenge_progged, "challenge_main", {});
    challenge_wumpus = context(menu_challenge_wumpus, "challenge_main", {});
    challenge_konami = context(menu_challenge_konami, "challenge_main", {});
    challenge_sequence_one = context(
        menu_challenge_sequence_one, "challenge_main", {});    
    challenge_sequence_two = context(
        menu_challenge_sequence_two, "challenge_main", {});    
    challenge_sequence_three = context(
        menu_challenge_sequence_three, "challenge_main", {});    
    challenge_sequence_four = context(
        menu_challenge_sequence_four, "challenge_main", {});    
}
