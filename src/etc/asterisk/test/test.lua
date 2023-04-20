luaunit = require('luaunit')

package.path = package.path .. ';' .. '../?.lua'
util = require('util')

function test_split_empty()
    local str = ""
    luaunit.assertEquals(split(str, ":"), {})
end    

function test_split()
    local str = "foo:bar"
    luaunit.assertEquals(split(str, ":"), {"foo", "bar"})
    local str = "foo:bar:baz"
    luaunit.assertEquals(split(str, ":"), {"foo", "bar", "baz"})
end

function test_push_stack()
    local stack = "";
    stack = util.push_stack(stack, "foo")
    luaunit.assertEquals(stack, "foo")
    stack = util.push_stack(stack, "bar")
    luaunit.assertEquals(stack, "foo:bar")    
end

function test_pop_stack_empty()
    local stack = "";
    stack, entry = util.pop_stack(stack)
    luaunit.assertEquals(stack, "")
    luaunit.assertEquals(entry, nil)
end

function test_pop_stack()
    local stack = "";
    stack = util.push_stack(stack, "foo")
    stack = util.push_stack(stack, "bar")
    stack = util.push_stack(stack, "baz")
    stack, entry = util.pop_stack(stack)
    luaunit.assertEquals(stack, "foo:bar")
    luaunit.assertEquals(entry, "baz")
    stack, entry = util.pop_stack(stack)
    luaunit.assertEquals(stack, "foo")
    luaunit.assertEquals(entry, "bar")
    stack, entry = util.pop_stack(stack)
    luaunit.assertEquals(stack, "")
    luaunit.assertEquals(entry, "foo")
end

function test_iter()
    t = {"a", "b", "c"}
    for k, v in util.iter(t) do
        luaunit.assertEquals(v, t[k])
    end
end

function test_map()
    t = {"a", "b", "c"}
    map_t = util.map(t, function (v) return v.."x" end)
    -- map_t has been mapped.
    luaunit.assertEquals(map_t[1], "ax")
    luaunit.assertEquals(map_t[2], "bx")
    luaunit.assertEquals(map_t[3], "cx")
    luaunit.assertEquals(#map_t, 3)
    -- t is unchanged.
    luaunit.assertEquals(t[1], "a")
    luaunit.assertEquals(t[2], "b")
    luaunit.assertEquals(t[3], "c")
    luaunit.assertEquals(#t, 3)
end

local function truthy(v) return true end
local function falsy(v) return false end    

function test_filter_empty_truthy_falsy()
    luaunit.assertEquals(util.filter({}, truthy), {})
    luaunit.assertEquals(util.filter({}, falsy), {})    
end

function test_filter_truthy_falsy()
    t = {1, 2, 3}
    luaunit.assertEquals(util.filter(t, truthy), t)
    luaunit.assertEquals(util.filter(t, falsy), {})    
end

function test_filter()
    t = {1, 2, 3}
    local function greater_than_one(v) return v > 1 end
    luaunit.assertEquals(util.filter(t, greater_than_one), {2, 3})
end

function test_directory_filenames()
    -- XXX a stupid smoke test
    _ = util.directory_filenames("/tmp")
end


os.exit( luaunit.LuaUnit.run() )
