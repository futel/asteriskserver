util = require("util")

local extensions = {
    admin_main = util.context(
        {intro_statements={"fewtel"},
         menu_entries={
             [1]={"for-the-fewtel-voice-conference", "futel-conf-admin"},
             [2]={{"for", "the", "outgoing", "menus"},
                 "outgoing_chooser"},
             [3]={"for-an-internal-dialtone",
                  "internal-dialtone-wrapper"},
             [0]={"for-the-operator", "operator"}},
         statement_dir=""}),
    member_main = util.context(
        {intro_statements={"fewtel"},
         menu_entries={
             [1]={"for-the-fewtel-voice-conference", "futel-conf-admin"},
             [2]={"for-an-internal-dialtone", "internal-dialtone-wrapper"},
             [3]={"for-the-wildcard-line", "wildcard_line_outgoing"},
             [0]={"for-the-operator", "operator"}},
         statement_dir=""}),
    outgoing_chooser = util.context(
        {menu_entries={
             [1]={
                 {"for", "the", "portland", "menu"}, "outgoing_portland"},
             [2]={{
                     "for", "the", "ipsilanty", "menu"}, "outgoing_ypsi"},
             [3]={{"for", "the", "souwester", "menu"},
                 "outgoing_souwester"}},
         statement_dir=""})}

return extensions
