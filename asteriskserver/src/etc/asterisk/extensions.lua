package.path = package.path .. ';/opt/asterisk/etc/asterisk/?.lua'
require("util")
require("extensions_peopleshomes")
require("extensions_missedconnections")

extensions = {
    default = {
        include = {};
    };
}

for k,v in pairs(extensions_peopleshomes) do extensions[k] = v end
for k,v in pairs(extensions_missedconnections) do extensions[k] = v end
