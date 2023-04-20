local lfs = require("lfs")

outgoingchannel = "twilio"

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

-- Caller IDs for calls which come from Twilio Programmable Voice.
-- This should match the keys of extensions.private.json in
-- twilio-sip-serverl
twilio_pv_callerids = {
    "demo",
    "dome-basement", "dome-booth", "dome-garage", "dome-office", 
    "r2d2", "sjac", "test"}

-- return true if table t contains value
local function has_value (t, value)
    for i, v in ipairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

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

-- Return iterator over sequence.
function iter(t)
    local i = 0
    local n = #t
    return function ()
        i = i + 1
        if i <= n then return t[i] end
    end
end

-- Return table from t with map_function applied to values.
-- XXX This function is badly named because we are working only with
--     tables, not iterators.
function map(t, map_function)
    out = {}
    for k,v in pairs(t) do
        out[k] = map_function(t[k])
    end
    return out
end

-- Return sequence from t containing values that pass filter_function.
-- XXX does this require a table?
function filter(t, filter_function)
    -- Does lua pass tables by reference? If not, we could use iter
    -- to do this in place and avoid copying.
    out = {}
    for v in iter(t) do
        if filter_function(v) then
            table.insert(out, v)
        end
    end
    return out
end

-- Return true if file exists at path, else return false.
function file_exists(path)
    return lfs.attributes(path).mode == "file"
end

-- Return sequence of files in directory given by path.
function directory_filenames(path)
    
    -- Return path for file with path prepended.
    -- If path is absolute, this is an abolute path.
    local function filepath(f)
        return path..'/'..f
    end

    -- A stupid function to get around iterating over
    -- the output of lfs.dir().
    function lfs_dir_to_table(p)
        filenames = {}
        for i in lfs.dir(p) do
            table.insert(filenames, i)
        end
        return filenames
    end
    -- XXX map requires a table
    filenames = lfs_dir_to_table(path)
    filenames = map(filenames, filepath)
    filenames = filter(filenames, file_exists)
    return filenames
end

-- play sound file from dirname in background
function play_random_background(dirname)
    app.AGI("random_file_strip.agi", dirname)
    app.Background(channel.agi_out:get())
end

-- execuate background statement using sound_path
function say(filename, context)
    app.AGI("sound_path.agi", filename, context)
    app.Background(channel.agi_out:get())
end

-- write a metric line named context
function metric(context)
    app.AGI("metric.agi", context)    
end

-- Goto bounce context if there is a lockfile.
function bounce()
    if util.lockfile_exists() then
        app.Goto("bounce", "s", 1)
    end
end

-- Return a string usable for the asterisk Dial command.
function get_dialstring(number, outgoingchannel)
    dialstring = "PJSIP/" .. number
    if outgoingchannel ~= nil then
        dialstring = dialstring .. "@" .. outgoingchannel        
    end
    return dialstring
end

function get_timeoutstring(timeout)
    if timeout == nil then
        timeout = ""
    end
    return "g" .. timeout
end

-- Dial number with timeout in dial command syntax (which can be empty).
-- Note that this can dial external endpoints, "internaldial" may be
-- a confusing name.
function internaldial(number, timeout)
    metric("internaldial")
    -- wait for ratelimiter
    app.AGI("call_ratelimit.agi")
    dialstring = get_dialstring(number, outgoingchannel)
    timeoutstring = get_timeoutstring(timeout)
    -- start trying to dial
    app.Dial(dialstring, nil, timeoutstring)
    dialstatus = channel.DIALSTATUS:get()
    -- we have completed the call, metric and react to the outcome    
    -- note that we don't get here if the caller hung up first
    metric("outgoing-dialstatus-" .. dialstatus)
    if (dialstatus == "CHANUNAVAIL") or (dialstatus == "CONGESTION") then
        app.Playtones("congestion")
        app.Congestion()
    end
end

-- say goodbye and hang up
function goodbye()    
    say("goodbye")
    app.Hangup()
end

-- execute menu of statements by saying them
-- intro statements is sequence of strings
-- menu_statements is sequence of strings, sequences, or nils
function menu(pre_callable, post_callable, intro_statements, menu_statements, statement_dir, context, exten)
    
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

    if post_callable then
        post_callable()
    else
        goodbye()
    end
end

-- play statement, then record and store file in directory
function record(statement, directory)
    say(statement)
    app.AGI("record.agi", directory)
    say("thank-you")
    app.Hangup()
end

-- Split str into pieces with separator and return an array.
function split(str, separator)
    local tbl = {}
    local pattern = string.format("[^%s]+", separator)    -- everything except separator
    str:gsub(pattern, function(x) tbl[#tbl+1]=x end)
    if tbl[1] == "" then
        -- Assume we have one empty string entry.
        return {}
    end
    return tbl
end

-- Push entry string into stack and return stack. Stack is a string with 0 or more entries
-- separated by the separator and not containing the separator.
function push_stack(stack, entry)
    local separator = ':'
    if stack ~= "" then
        return string.format('%s%s%s', stack, separator, entry)
    end
    return entry
end

-- Pop entry string from stack and return (stack, entry). Stack is a string with 0 or more entries
-- separated by the separator and not containing the separator. Entry may be nil.
function pop_stack(stack)
    local separator = ':'
    local tbl = split(stack, separator)
    local entry = table.remove(tbl)
    return table.concat(tbl, separator), entry
end

-- Push parent context stored in channel variable.
function push_parent_context(context)
    channel.parent_context = push_stack(channel.parent_context:get(), context)
end

-- execute goto to destination_context
function goto_context(destination_context, context, exten)
    push_parent_context(context)
    return app.Goto(destination_context, "s", 1)
end

-- Pop and return parent context stored in channel variable.
function pop_parent_context()
    local parent_context = channel.parent_context:get();
    if not parent_context then
        parent_context = ""
    end
    local stack, context = pop_stack(parent_context)
    if not context then
        context = ""
    end
    channel.parent_context = stack
    return context
end

-- Pop parent context and goto it. We do this becuase we can't call Asterisk's gosub in lua.
function goto_parent_context()
    local parent_context = pop_parent_context()
    if parent_context ~= "" and parent_context then
        return app.Goto(parent_context, "s", 1)
    else
        -- No parent_context, this shouldn't happen unless we are at the initial context.
        callerid = channel.CALLERID("number"):get()
        if has_value(twilio_pv_callerids, callerid) then
            -- We are coming from Twilio Programmable Voice, hang up so it can continue.
            return app.Hangup()
        else
            -- Replay our current context, hopefully it has an s extension.
            return app.Goto("s", 1)
        end
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
-- begin with a digit or +.
function dial_context(destination_function)
    local context_array = {}
    -- Asterisk doesn't like _!, so we need a more specific pattern.
    -- Most outgoing numbers, including filterable, begin with +.
    context_array["_+!"] = destination_function
    -- Other dialble numbers begin with a digit.
    context_array["_X!"] = destination_function    
    return context_array
end

-- Return context array which says statements with nothing but default
-- menu entries, then gotos parent context
function statement_context(arg)
    local statements = arg.statements
    local statement_dir = arg.statement_dir
    return context(
        {intro_statements=statements,
         post_callable=goto_parent_context,
         menu_entries={},
         statement_dir=statement_dir})
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
        goto_parent_context()
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
    local post_callable = arg.post_callable    
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
            post_callable,
            intro_statements,
            menu_statements,
            statement_dir,
            context,
            exten)
    end

    return context_array(menu_function, menu_destinations)
end

-- XXX We only export some of these to unit test them, is there another way?
local util = {
    bounce = bounce,
    context = context,
    context_array = context_array,
    destination_context = destination_context,
    dial_context = dial_context,
    directory_filenames = directory_filenames,
    filter = filter,
    get_dialstring = get_dialstring,    
    statement_context = statement_context,    
    internaldial = internaldial,
    file_exists = file_exists,
    iter = iter,
    lockfile_create = lockfile_create,
    lockfile_exists = lockfile_exists,
    map = map,
    max_iterations = max_iterations,
    metric = metric,    
    play_random_background = play_random_background,
    push_stack = push_stack,
    pop_stack = pop_stack,
    record = record,
    say = say}

return util
