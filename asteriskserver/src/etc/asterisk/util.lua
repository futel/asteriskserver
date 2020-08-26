max_iterations = 10

position_statements = {}
position_statements[1] = "press-one"
position_statements[2] = "press-two"
position_statements[3] = "press-three"
position_statements[4] = "press-four"
position_statements[5] = "press-five"
position_statements[6] = "press-six"
position_statements[7] = "press-seven"
position_statements[8] = "press-eight"
position_statements[9] = "press-nine"
position_statements[0] = "press-zero"       


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

-- execute menu of statements by saying them
-- intro statements is sequence of strings
-- loop_statements is sequence of strings, sequences, or nils
function menu(intro_statements, loop_statements, statement_dir, context, exten)
    app.AGI("metric.agi", context)
    for statement in iter(intro_statements) do
        say(statement, statement_dir)
    end
    if #loop_statements > 0 then
        for i = 1,max_iterations do
            -- XXX ipairs means can't be sparse or have 0
            for key, statements in ipairs(loop_statements) do
                -- loop_statements can be string or sequences, convert to sequence
                if type(statements) == type("") then
                    statements = {statements}
                end
                -- say the statements and position statement iff we have both
                if statements and #statements > 0 then
                    position_statement = position_statements[key]
                    if position_statement then
                        for statement in iter(statements) do
                            say(statement, statement_dir)
                        end
                        say(position_statement, statement_dir)
                    end
                end
            end
            app.Background("silence/1")
        end
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
