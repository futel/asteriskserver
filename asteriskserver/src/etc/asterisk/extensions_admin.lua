require("util")

function menu_admin_main(context, extension)
    return menu(
        {"fewtel",
        "for-the-fewtel-voice-conference",
        "press-one",
        "for",
        "the",
        "outgoing",
        "menus",
        "press-two",
        "for-an-internal-dialtone",
        "press-three",
        "to-record-a-menu",
        "press-four",
        "for-the-operator",
        "press-zero"},
    "",
    context,
    extension)
end

function menu_member_main(context, extension)
    return menu(
        {"fewtel",
        "for-the-fewtel-voice-conference",
        "press-one",
        "for-an-internal-dialtone",
        "press-two",
        "to-record-a-menu",
        "press-three",
        "for-the-wildcard-line",
        "press-four",
        "for-the-operator",
        "press-zero"},
    "",
    context,
    extension)
end

extensions_admin = {
    admin_main = context(
        menu_admin_main,
        "admin_main",
        {"futel-conf",
         "outgoing-chooser",
         "internal-dialtone-wrapper",
         "record",
         "operator"});
    member_main = context(
        menu_member_main,
        "member_main",
        {"futel-conf",
         "internal-dialtone-wrapper",
         "record",
         "wildcard-line-outgoing",
         "operator"});
         
}
