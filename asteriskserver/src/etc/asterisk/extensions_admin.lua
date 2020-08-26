util = require("util")

function menu_admin_main(context, extension)
    return util.menu(
        {"fewtel"},
        {"for-the-fewtel-voice-conference",
         {"for",
          "the",
          "outgoing",
          "menus"},
         "for-an-internal-dialtone",
         "to-record-a-menu",
         "for-the-operator"}, -- XXX zero
        "",
        context,
        extension)
end

function menu_member_main(context, extension)
    return util.menu(
        {"fewtel"},
        {"for-the-fewtel-voice-conference",
         "for-an-internal-dialtone",
         "to-record-a-menu",
         "for-the-wildcard-line",
         "for-the-operator"},
    "",
    context,
    extension)
end

extensions_admin = {
    admin_main = util.context(
        menu_admin_main,
        {"futel-conf",
         "outgoing-chooser",
         "internal-dialtone-wrapper",
         "record",
         "operator"});
    member_main = util.context(
        menu_member_main,
        {"futel-conf",
         "internal-dialtone-wrapper",
         "record",
         "wildcard-line-outgoing",
         "operator"});
         
}
