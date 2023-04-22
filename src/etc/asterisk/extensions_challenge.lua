sets = require("sets")
util = require("util")

mailbox_directory = "/var/spool/asterisk/voicemail/default/"
mailbox_filename = "/greet.wav"

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

function menu_challenge_admin(context, extension)
    mailboxes = mailboxes()
    if #mailboxes > 0 then
        util.say("at-the-tone")
        util.say("to-approve")
        util.say("press-one")
        util.say("to-reject")    
        util.say("press-two")
        util.say("to-skip")
        util.say("press-any-key")
        util.say("begin")
        for mailbox in util.iter(mailboxes) do
            approved = gather_mailbox(mailbox)
            if approved == true then
                approve_mailbox(mailbox)
            elseif approved == false then
                deny_mailbox(mailbox)
            end
        end
    end
    util.say("goodbye")    
end

-- Return table of all keys with achievment.
function challenge_keys_with_value(achievement)
    app.AGI("challenge_keys_with_value.agi", achievement)
    local agi_out = channel.agi_out:get()
    return util.split(agi_out, ',')
end

-- Return sequence of mailboxes with the achievement-mailbox achievement and not the
-- achievement-mailbox-approved or achievement-mailbox-denied achievement.
function mailboxes()
    local out = challenge_keys_with_value("achievement-mailbox")
    out = sets.from_table(out)
    local to_filter = challenge_keys_with_value("achievement-mailbox-approved")
    to_filter = sets.from_table(to_filter)
    sets.subtract(out, to_filter)
    to_filter = challenge_keys_with_value("achievement-mailbox-denied")
    to_filter = sets.from_table(to_filter)
    sets.subtract(out, to_filter)
    out = sets.to_table(out)
    return out
end

-- Play sound file for mailbox, gather one key, and return true if key was 1,
-- false if key was 2, and nil otherwise.
function gather_mailbox(mailbox)
    -- Get the mangled path for the mailbox greeting and play it.
    path = mailbox_directory .. mailbox .. mailbox_filename
    app.Playback(util.path_for_playback(path))
    -- Play beep and wait for one keypress, put it in the choice channel variable.
    app.Read("choice", "beep", 1)    
    choice = channel.choice:get()
    if choice == "1" then
        return true
    elseif choice == "2" then
        return false
    end
    return nil
end

-- Add the achievement-mailbox-approved achievement to mailbox.
function approve_mailbox(mailbox)
    app.AGI("challenge_write.agi", mailbox, "achievement-mailbox-approved")    
end

-- Add the achievement-mailbox-denied achievement to mailbox.
function deny_mailbox(mailbox)
    app.AGI("challenge_write.agi", mailbox, "achievement-mailbox-denied")
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
    path = mailbox_directory .. mailbox .. mailbox_filename
    if not io.open(path, "r") then
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

function challenge_incoming(mailbox)
    from_incoming = channel.from_incoming:get()
    if from_incoming ~= "True" then
        for i=1,10 do
            util.say("visit-this-destination-via-the-incoming-number-for-access",
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

-- function challenge_conference(mailbox)
--     app.AGI("vmb_oracle.agi", mailbox)
--     -- if we get here we won
-- end

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

function menu_challenge_incoming(context, extension)
    do_challenge("achievement-mailbox", "achievement-incoming", challenge_incoming)
end

function menu_challenge_hold(context, extension)
    do_challenge(
        "achievement-mailbox",
        "achievement-hold",
        challenge_hold)
end

-- function menu_challenge_conference(context, extension)
--     do_challenge(
--         "achievement-mailbox",
--         "achievement-conference",
--         challenge_conference)
-- end

function menu_challenge_incoming_main(context, extension)
    channel.from_incoming = "True"
    return goto_main()
end

function menu_authenticate(context, extension)
    mailbox = vmauthenticate()
    app.AGI("challenge_leaderboard_position.agi", mailbox)
    app.AGI("challenge_leaderboard_score.agi", mailbox)    
    return app.Goto("challenge_list", "s", 1)
end

function menu_challenge_leaderboard(context, extension)
    app.AGI("challenge_leaderboard_lines.agi")
    return goto_main()
end

extensions = {
    challenge_main = util.context(
        {intro_statements={},
         menu_entries={
             {"to-perform-the-challenges", "challenge_authenticate"},
             {"for-instructions", "challenge_admin"}, -- XXX
             {"for-the-leaderboard", "challenge_leaderboard"},
             {"for-more-information-about-the-fewtel-remote-testing-facility",
              "challenge_info"}},
         statement_dir="challenge"}),
    challenge_toorcamp_main = util.context(
        {intro_statements={},
         menu_entries={
             {"to-perform-the-challenges", "challenge_authenticate"},
             {"for-voicemail", "voicemail_outgoing"},
             {"for-the-fewtel-voice-conference", "futel-conf"},
             {"for-instructions", "challenge_instructions"},
             {"for-the-leaderboard", "challenge_leaderboard"},
             {"for-the-fewtel-community", "community_outgoing"},
             {"for-more-information-about-the-fewtel-remote-testing-facility",
              "challenge_info"}},
         statement_dir="challenge"}),
    challenge_incoming_main = util.context_array(
        menu_challenge_incoming_main, {}),
    challenge_admin = util.context_array(menu_challenge_admin, {}),
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
    challenge_authenticate = util.context_array(menu_authenticate, {}),
    challenge_list = util.context(
        {intro_statements={},
         menu_entries={
             {"for-challenge-mailbox", "challenge_mailbox"},
             {"for-challenge-progged", "challenge_progged"},
             {"for-challenge-hunt-the-wumpus", "challenge_wumpus"},
             {"for-challenge-konami", "challenge_konami"},
             {"for-challenge-sequence", "challenge_sequence_list"},
             {"for-challenge-incoming", "challenge_incoming"},
             {"for-challenge-hold", "challenge_hold"}
             -- {"for-challenge-oracle", "challenge_conference"},
         },
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
    challenge_incoming = util.context_array(
        menu_challenge_incoming, {}),
    challenge_hold = util.context_array(
        menu_challenge_hold, {}),        
    -- challenge_conference = util.context_array(
    --     menu_challenge_conference, {})
}

return extensions
