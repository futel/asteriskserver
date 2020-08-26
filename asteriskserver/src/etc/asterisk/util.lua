max_iterations = 10

-- return iterator over table
function iter(t)
    local i = 0
    local n = #t
    return function ()
        i = i + 1
        if i <= n then return t[i] end
    end
end

-- execuate background statement using sound_path
function say(filename, context, preferred_subdirs)
    app.AGI("sound_path.agi", filename, context, preferred_subdirs)
    app.Background(channel.agi_out:get())
end

-- execute menu of statements
function menu(intro_statements, loop_statements, statement_dir, context, exten)
    app.AGI("metric.agi", context)
    for statement in iter(intro_statements) do
        say(statement, statement_dir)
    end
    -- XXX don't loop if empty
    for i = 1,max_iterations do
        for statement in iter(loop_statements) do
            say(statement, statement_dir)
        end
        app.Background("silence/1")
    end
    say("goodbye")
    app.Hangup()
end

-- play statement, then record and store file in directory
function record(statement, directory)
    say(statement)
    app.AGI("record.agi", directory)
    say("thank-you")
    app.Hangup()
end

-- execute goto to destination_context
function goto_context(destination_context, context, exten)
    push_parent_context(context)
    return app.Goto(destination_context, "s", 1)
end

-- Push parent context stored in channel variable.
function push_parent_context(context)
    -- Push parent context. Our stack is limited to one value!
    channel.parent_context = context
end

-- Pop and return parent context stored in channel variable.
function pop_parent_context()
    -- Pop parent context. Our stack is limited to one value!
    ret = channel.parent_context:get()
    channel.parent_context = ""  -- can't set to nil
    return ret
end

-- Pop parent context and goto it. We do this becuase we can't gosub in lua.
function goto_parent_context(menu_function, context, exten)
    parent_context = pop_parent_context()
    if parent_context then
      return app.Goto(parent_context, "s", 1)
    else
      -- no parent_context, replay menu_function.
      return menu_function(context, extension)
    end
end

-- Call the language macro and replay the menu.
-- the only way this seems workable from lua is to call a conf macro
-- exten => s,1,Set(CHANNEL(language)=es)
-- channel.LANGUAGE = "es"
-- channel.LANGUAGE:set("es")
-- channel.LANGUAGE():set("es")
function set_language_es(menu_function, context, extension)
    app.Macro("languagees")     -- extensions.conf
    return menu_function(context, extension)    
end

-- return context array with standard keys added
-- keys: selections values: destinations
function context(menu_function, destinations)
    context_array = {}
    context_array.s = menu_function
    context_array.i = menu_function
    context_array["#"] = function(context, exten)
        goto_parent_context(menu_function, context, exten)
    end
    context_array["*"] = function(context, exten)
        set_language_es(menu_function, context, exten)
    end
    for key, value in ipairs(destinations) do
        context_array[key] = function(context, exten)
            goto_context(value, context, exten)
        end
    end
    return context_array
end

local util = {
    iter = iter,
    say = say,
    menu = menu,
    record = record,
    goto_context = goto_context,
    context = context,
    }

return util
