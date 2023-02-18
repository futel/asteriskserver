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


os.exit( luaunit.LuaUnit.run() )
