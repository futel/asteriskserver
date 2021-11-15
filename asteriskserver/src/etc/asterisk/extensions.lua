package.path = package.path .. ';/etc/asterisk/?.lua'

extensions_admin = require("extensions_admin")
extensions_apology = require("extensions_apology")
extensions_challenge = require("extensions_challenge")
extensions_directory = require("extensions_directory")
extensions_holdthephone = require("extensions_holdthephone")
extensions_incoming = require("extensions_incoming")
extensions_misc = require("extensions_misc")
extensions_outgoing = require("extensions_outgoing")
extensions_voicemail = require("extensions_voicemail")
extensions_wildcard_line = require("extensions_wildcard_line")
extensions_911 = require("extensions_911")

-- create the base dialplan data structure which asterisk wants
extensions = {
    default = {
        include = {};
    };
}

-- add extensions from each module to the dialplan data structure
for k,v in pairs(extensions_admin) do extensions[k] = v end
for k,v in pairs(extensions_apology) do extensions[k] = v end
for k,v in pairs(extensions_challenge) do extensions[k] = v end
for k,v in pairs(extensions_directory) do extensions[k] = v end
for k,v in pairs(extensions_holdthephone) do extensions[k] = v end
for k,v in pairs(extensions_incoming) do extensions[k] = v end
for k,v in pairs(extensions_misc) do extensions[k] = v end
for k,v in pairs(extensions_outgoing) do extensions[k] = v end
for k,v in pairs(extensions_voicemail) do extensions[k] = v end
for k,v in pairs(extensions_wildcard_line) do extensions[k] = v end
for k,v in pairs(extensions_911) do extensions[k] = v end
