package.path = package.path .. ';/opt/asterisk/etc/asterisk/?.lua'

extensions_admin = require("extensions_admin")
extensions_challenge = require("extensions_challenge")
extensions_holdthephone = require("extensions_holdthephone")
extensions_outgoing = require("extensions_outgoing")
extensions_wildcard_line = require("extensions_wildcard_line")

-- create the base dialplan data structure which asterisk wants
extensions = {
    default = {
        include = {};
    };
}

-- add extensions from each module to the dialplan data structure
for k,v in pairs(extensions_admin) do extensions[k] = v end
for k,v in pairs(extensions_challenge) do extensions[k] = v end
for k,v in pairs(extensions_holdthephone) do extensions[k] = v end
for k,v in pairs(extensions_outgoing) do extensions[k] = v end
for k,v in pairs(extensions_wildcard_line) do extensions[k] = v end
