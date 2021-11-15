max_iterations = 10

-- statements for positions that can be named in a menu
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

-- positions that can be named in a menu
positions = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0}

lockfile_name = "/opt/futel/var/run/lockfile"

-- create a lockfile or fail, and don't return anything
function lockfile_create()
    -- we only have one lockfile
    local f = io.open(lockfile_name, "w")
    io.close(f)        
end

-- return True if the lockfile exists
function lockfile_exists()
    -- we only have one lockfile    
   local f = io.open(lockfile_name, "r")
   if f ~= nil then
       io.close(f)
       return true
   end
   return false
end

-- return iterator over sequence
function iter(t)
    local i = 0
    local n = #t
    return function ()
        i = i + 1
        if i <= n then return t[i] end
    end
end

-- return table from t with map_function applied to values
function map(t, map_function)
    out = {}
    for k,v in pairs(t) do
        out[k] = map_function(t[k])
    end
    return out
end

-- play sound file from dirname in background
function play_random_background(dirname)
    app.AGI("random_file_strip.agi", dirname)
    app.Background(channel.agi_out:get())
end

-- execuate background statement using sound_path
function say(filename, context, preferred_subdirs)
    app.AGI("sound_path.agi", filename, context, preferred_subdirs)
    app.Background(channel.agi_out:get())
end

-- write a metric line named context
function metric(context)
    app.AGI("metric.agi", context)    
end

-- execute menu of statements by saying them
-- intro statements is sequence of strings
-- menu_statements is sequence of strings, sequences, or nils
function menu(pre_callable, intro_statements, menu_statements, statement_dir, context, exten)
    
    metric(context)

    if pre_callable then
        pre_callable()
    end

    if intro_statements then
        for statement in iter(intro_statements) do
            say(statement, statement_dir)
        end
    end
    
    if #menu_statements > 0 then
        for i = 1,max_iterations do
            -- say statements in menu order by iterating over ordered keys
            for key in iter(positions) do
                local statements = menu_statements[key]
                -- menu_statements can be string or sequences, convert to sequence
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
    local ret = channel.parent_context:get()
    channel.parent_context = ""  -- can't set to nil
    return ret
end

-- Pop parent context and goto it. We do this becuase we can't gosub in lua.
function goto_parent_context(menu_function, context, exten)
    local parent_context = pop_parent_context()
    if parent_context then
      return app.Goto(parent_context, "s", 1)
    else
      -- no parent_context, replay menu_function.
      return menu_function(context, extension)
    end
end

-- Set the language channel thingy and replay the menu.
function set_language_es(menu_function, context, extension)
    -- this is how we are supposed to be able to do it
    --channel.LANGUAGE():set("es")    
    app.exec("Set(CHANNEL(language)=es)")
    return menu_function(context, extension)    
end

-- Return context array which immediately starts destination_function
-- when called with no extension.
function destination_context(destination_function)
    local context_array = {}
    context_array.s = destination_function
    return context_array
end

-- Return context array which immediately starts destination_function
-- when called with a possibly dialable extension. Dialable extensions
-- begin with a number or +.
function dial_context(destination_function)
    local context_array = {}
    -- Asterisk doesn't like _!, so we need a more specific pattern.
    -- Filterable outgoing dialed numbers begin with +.
    context_array["_+!"] = destination_function
    -- Other dialble numbers begin with a digit.
    context_array["_X!"] = destination_function    
    return context_array
end

-- return context array with standard keys added
-- keys: selections values: destinations
function context_array(menu_function, destinations)
    local context_array = {}
    -- add standard/default/necessary keys and destinations
    -- s is the defualt destination and is automagically selected on enter
    context_array.s = menu_function
    -- i is the default invalid entry destination
    context_array.i = menu_function
    -- # is our default key for parent menu destination
    context_array["#"] = function(context, exten)
        goto_parent_context(menu_function, context, exten)
    end
    -- * is our default key for localization
    context_array["*"] = function(context, exten)
        set_language_es(menu_function, context, exten)
    end
    -- add keys specific to this context definition
    for key in iter(positions) do
        if destinations[key] then
              context_array[key] = function(context, exten)
                  goto_context(destinations[key], context, exten)
              end
        end
    end
    return context_array
end

-- return context array with a menu and standard keys added
function context(arg)
    local pre_callable = arg.pre_callable
    local intro_statements = arg.intro_statements
    local menu_entries = arg.menu_entries
    local statement_dir = arg.statement_dir

    local menu_statements = map(
        menu_entries, function(v) return v[1] end) 
    local menu_destinations = map(
        menu_entries, function(v) return v[2] end)
    
    -- curry a menu function that receives the context variables
    local menu_function = function(context, exten)
        return menu(
            pre_callable,
            intro_statements,
            menu_statements,
            statement_dir,
            context,
            exten)
    end

    return context_array(menu_function, menu_destinations)
end

local util = {
    context = context,
    context_array = context_array,
    destination_context = destination_context,
    dial_context = dial_context,    
    iter = iter,
    lockfile_create = lockfile_create,
    lockfile_exists = lockfile_exists,
    max_iterations = max_iterations,
    menu = menu,
    metric = metric,    
    play_random_background = play_random_background,
    record = record,
    say = say}

return util
