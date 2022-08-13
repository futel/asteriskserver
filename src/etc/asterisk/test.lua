-- q&d manual acceptance testing; so far, 'does it interpret'

extensions = {}

-- add extensions from each module
for k,v in pairs(extensions_admin) do extensions[k] = v end
for k,v in pairs(extensions_apology) do extensions[k] = v end
for k,v in pairs(extensions_challenge) do extensions[k] = v end
for k,v in pairs(extensions_directory) do extensions[k] = v end
for k,v in pairs(extensions_holdthephone) do extensions[k] = v end
for k,v in pairs(extensions_incoming) do extensions[k] = v end
for k,v in pairs(extensions_misc) do extensions[k] = v end
for k,v in pairs(extensions_outgoing) do extensions[k] = v end
for k,v in pairs(extensions_robotron) do extensions[k] = v end
for k,v in pairs(extensions_voicemail) do extensions[k] = v end
for k,v in pairs(extensions_wildcard_line) do extensions[k] = v end
for k,v in pairs(extensions_911) do extensions[k] = v end

print(extensions)
--print(extensions.extensions_admin.statements)
-- for k, v in pairs(extensions) do print(k) end
--for k, v in pairs(extensions.apology_intro) do print(k) end
