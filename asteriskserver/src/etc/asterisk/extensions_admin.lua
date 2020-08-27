util = require("util")

function menu_admin_main(context, extension)
    return util.menu(
        {"fewtel"},
        {[1]="for-the-fewtel-voice-conference",
         [2]={"for",
          "the",
          "outgoing",
          "menus"},
         [3]="for-an-internal-dialtone",
         [4]="to-record-a-menu",
         [0]="for-the-operator"},
        "",
        context,
        extension)
end

function menu_member_main(context, extension)
    return util.menu(
        {"fewtel"},
        {[1]="for-the-fewtel-voice-conference",
         [2]="for-an-internal-dialtone",
         [3]="to-record-a-menu",
         [4]="for-the-wildcard-line",
         [0]="for-the-operator"},
    "",
    context,
    extension)
end

extensions_admin = {
    admin_main = util.context(
        menu_admin_main,
        {[1]="futel-conf",
         [2]="outgoing-chooser",
         [3]="internal-dialtone-wrapper",
         [4]="record",
         [0]="operator"});
    member_main = util.context(
        menu_member_main,
        {[0]="futel-conf",
         [1]="internal-dialtone-wrapper",
         [2]="record",
         [3]="wildcard-line-outgoing",
         [0]="operator"});
         
}
