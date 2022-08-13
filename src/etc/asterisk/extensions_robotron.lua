conf = require("conf")
util = require("util")

function robotron_pre()
    util.play_random_background(
        conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/williams-short")
end

local extensions = {
    robotron_doctrine_of_futility_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/church-of-robotron/Church_of_Robotron_Sermon__Doctrine_of_Futility"},
         menu_entries={},
         statement_dir=nil}),
    robotron_eight_ways_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/church-of-robotron/Church_of_Robotron_Sermon__Eight_Ways"},
         menu_entries={},
         statement_dir=nil}),
    robotron_doctrine_of_error_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/church-of-robotron/Church_of_Robotron_Sermon__Doctrine_of_Error"},
         menu_entries={},
         statement_dir=nil}),
    robotron_ninth_position_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/church-of-robotron/Church_of_Robotron_Sermon__The_Ninth_Position"},
         menu_entries={},
         statement_dir=nil}),
    robotron_what_are_the_robotrons_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/church-of-robotron/Church_of_Robotron_Sermon__What_are_the_Robotrons"},
         menu_entries={},
         statement_dir=nil}),
    robotron_battle_poetry_play = util.context(
        {intro_statements={
             conf.asterisk_root .. "/var/lib/asterisk/sounds/futel/church-of-robotron/waves"},
         menu_entries={},
         statement_dir=nil}),
    robotron = util.context(
        {pre_callable=robotron_pre,
         menu_entries={
             {"for-the-doctrine-of-futility",
              "robotron_doctrine_of_futility_play"},
             {"for-the-eight-ways", "robotron_eight_ways_play"},
             {"for-the-doctrine-of-error",
              "robotron_doctrine_of_error_play"},
             {"for-the-ninth-position", "robotron_ninth_position_play"},
             {"for-what-are-the-robotrons",
              "robotron_what_are_the_robotrons_play"},
             {"for-robotron-battle-poetry",
              "robotron_battle_poetry_play"},},
         statement_dir="robotron"})}

return extensions
