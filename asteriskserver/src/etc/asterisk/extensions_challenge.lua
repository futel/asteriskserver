util = require("util")

function vmauthenticate()
    if channel.AUTH_MAILBOX:get() then
        return channel.AUTH_MAILBOX:get()
    end
    util.say("authenticate-with-your-voice-mail-box-to-continue", "challenge")
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
        util.say("access-denied", "challenge")            
        return goto_main()
    end
    if requirement ~= nil then
        if not challenge_has_value(mailbox, requirement) then
            util.say("access-denied", "challenge")
            return goto_main()
        end
    end
    if challenge_has_value(mailbox, achievement) then
        util.say("warning-access-already-granted", "challenge")
    end
end

function challenge_mailbox(mailbox)
    filename = "/opt/asterisk/var/spool/asterisk/voicemail/default/" .. mailbox .. "/greet.wav"
    if not io.open(filename, "r") then
        for i=1,10 do
            util.say("record-your-name-in-your-voicemail-account-for-access",
                "challenge")
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

function challenge_shadytel(mailbox)
    from_shadytel = channel.from_shadytel:get()
    if from_shadytel ~= "True" then
        for i=1,10 do
            util.say("visit-this-destination-via-shadytel-extension-3003-for-access",
                "challenge")
        end
        app.Hangup()
    end
    -- if we get here we won
end

function challenge_hold(mailbox)
    app.AGI("waiting_game.agi")
    -- if we get here we won
end

function challenge_conference(mailbox)
    app.AGI("vmb_oracle.agi", mailbox)
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
    util.say("access-granted", "challenge")
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
        "achievement-mailbox",
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

function menu_challenge_shadytel(context, extension)
    do_challenge("achievement-mailbox", "achievement-shadytel", challenge_shadytel)
end

function menu_challenge_hold(context, extension)
    do_challenge(
        "achievement-mailbox",
        "achievement-hold",
        challenge_hold)
end

function menu_challenge_conference(context, extension)
    do_challenge(
        "achievement-mailbox",
        "achievement-conference",
        challenge_conference)
end

function menu_challenge_shadytel_main(context, extension)
    channel.from_shadytel = "True"
    return goto_main()
end

function menu_authenticate(context, extension)
    mailbox = vmauthenticate()
    app.AGI("challenge_leaderboard_position.agi", mailbox)
    return app.Goto("challenge_list", "s", 1)
end

function menu_challenge_leaderboard(context, extension)
        util.say("access-denied", "challenge")
        util.say("access-denied", "challenge")
        util.say("access-denied", "challenge")
        util.say("access-denied", "challenge")
        util.say("access-denied", "challenge")
        return goto_main()
end

extensions = {
    challenge_main = util.context(
        {intro_statements={},
         menu_entries={
             {"to-perform-the-challenges", "challenge_authenticate"},
             {"for-voicemail", "outgoing-voicemail"},
             {"for-the-fewtel-voice-conference", "futel-conf"},
             {"for-instructions", "challenge_instructions"},
             {"for-the-leaderboard", "challenge_leaderboard"},
             {"for-the-fewtel-community", "community-outgoing"},
             {"for-more-information-about-the-fewtel-remote-testing-facility",
              "challenge_info"}},
         statement_dir="challenge"}),
    challenge_shadytel_main = util.context_array(
        menu_challenge_shadytel_main, {}),
    challenge_instructions = util.context(
        {intro_statements={
             "welcome-to-the-fewtel-remote-testing-facility",
             "access-is-granted-as-challenges-are-successfully-completed",
             "complete-all-challenges-to-qualify",
             "for-more-information-contact-the-operator-from-any-fewtel-phone-or-visit-our-website-at-fewtel-dot-net",
             "good-luck",
             "all-must-be-tested",         
             "all-must-be-tested",
             "all-must-be-tested"},
         menu_entries={},
         statement_dir="challenge"}),
    challenge_leaderboard = util.context_array(
        menu_challenge_leaderboard, {}),
    challenge_info = util.context(
        {intro_statements={
             "the-fewtel-remote-testing-facility",
             "a-facility-for-the-remote-testing-of-users-of-fewtel",
             "with-contributions-from",
             "anzee",
             "breed-x",
             "bizzt-bomb",
             "ear-feast",
             "jay-mej",
             "oscule",
             "tishbite",
             "x-nor",
             "thanks-to-our-volunteers-sponsors-and-toorcamp",
             "all-must-be-tested",
             "all-must-be-tested",
             "all-must-be-tested"},
         menu_entries={},
         statement_dir="challenge"}),
    challenge_list = util.context(
        {intro_statements={},
         menu_entries={
             {"for-challenge-mailbox", "challenge_mailbox"},
             {"for-challenge-progged", "challenge_progged"},
             {"for-challenge-hunt-the-wumpus", "challenge_wumpus"},
             {"for-challenge-konami", "challenge_konami"},
             {"for-challenge-sequence", "challenge_sequence_list"},
             {"for-challenge-shadytel", "challenge_shadytel"},
             {"for-challenge-hold", "challenge_hold"},
             {"for-challenge-oracle", "challenge_conference"},},
         statement_dir="challenge"}),
    challenge_sequence_list = util.context(
        {intro_statements={},
         menu_entries={
             {"for-challenge-sequence-one", "challenge_sequence_one"},
             {"for-challenge-sequence-two", "challenge_sequence_two"},
             {"for-challenge-sequence-three", "challenge_sequence_three"},
             {"for-challenge-sequence-four", "challenge_sequence_four"}},
         statement_dir="challenge"}),
    challenge_mailbox = util.context_array(menu_challenge_mailbox, {}),
    challenge_progged = util.context_array(menu_challenge_progged, {}),
    challenge_wumpus = util.context_array(menu_challenge_wumpus, {}),
    challenge_konami = util.context_array(menu_challenge_konami, {}),
    challenge_sequence_one = util.context_array(
        menu_challenge_sequence_one, {}),    
    challenge_sequence_two = util.context_array(
        menu_challenge_sequence_two, {}),    
    challenge_sequence_three = util.context_array(
        menu_challenge_sequence_three, {}),    
    challenge_sequence_four = util.context_array(
        menu_challenge_sequence_four, {}),
    challenge_shadytel = util.context_array(
        menu_challenge_shadytel, {}),
    challenge_hold = util.context_array(
        menu_challenge_hold, {}),        
    challenge_conference = util.context_array(
        menu_challenge_conference, {})
}

return extensions
