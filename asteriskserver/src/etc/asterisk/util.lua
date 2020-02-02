max_iterations = 10

-- execuate background statement using sound_path
function say(filename, context, preferred_subdirs)
    app.AGI("sound_path.agi", filename, context, preferred_subdirs)
    app.Background(channel.agi_out:get())
end

-- execute menu of statements
function menu(statements, statement_dir, context, exten)
    app.AGI("metric.agi", context)
    for i = 1,max_iterations do
        for _, statement in ipairs(statements) do
            say(statement, statement_dir)
        end
        app.Background("silence/1")
    end
    say("goodbye")
    app.Hangup()
end

-- execute background playing of content
function play(contents, context, exten)
    app.AGI("metric.agi", context)
    for i = 1,max_iterations do
        for _, content in ipairs(contents) do
            app.Background(content)
        end
        app.Background("silence/1")
    end
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
    return app.Goto(destination_context, "s", 1)
end

-- return context structure
function context(menu_function, parent_context, destinations)
    context_array = {}
    context_array.s = menu_function
    context_array.i = menu_function
    context_array["#"] = function(context, exten)
        goto_context(parent_context, context, exten)
    end
    for key, value in ipairs(destinations) do
        context_array[key] = function(context, exten)
            goto_context(value, context, exten)
        end
    end
    return context_array
end
