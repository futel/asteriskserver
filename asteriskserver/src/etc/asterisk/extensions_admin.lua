util = require("util")

extensions_admin = {
    admin_main = util.context(
        {intro_statements={"fewtel"},
         loop_statements={
             [1]="for-the-fewtel-voice-conference",
             [2]={"for",
                  "the",
                  "outgoing",
                  "menus"},
             [3]="for-an-internal-dialtone",
             [4]="to-record-a-menu",
             [0]="for-the-operator"},
         statement_dir="",
         destinations={
             [1]="futel-conf",
             [2]="outgoing-chooser",
             [3]="internal-dialtone-wrapper",
             [4]="record",
             [0]="operator"}}),
    member_main = util.context(
        {intro_statements={"fewtel"},
         loop_statements={
             [1]="for-the-fewtel-voice-conference",
             [2]="for-an-internal-dialtone",
             [3]="to-record-a-menu",
             [4]="for-the-wildcard-line",
             [0]="for-the-operator"},
         statement_dir="",        
         destinations={
             [1]="futel-conf",             
             [2]="internal-dialtone-wrapper",
             [3]="record",
             [4]="wildcard-line-outgoing",
             [0]="operator"}})}
