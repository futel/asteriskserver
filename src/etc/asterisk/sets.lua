function add(set, key)
    set[key] = true
end

function remove(set, value)
    set[value] = nil
end

function contains(set, key)
    return set[key] ~= nil
end

-- Subtract all values of set s2 from set s1 and return s1.
function subtract(s1, s2)
    for v,_ in pairs(s2) do
        remove(s1, v)
    end
end

-- Return a set containing the values of table t.
function from_table(t)
    local set = {}
    for _,v in pairs(t) do
        add(set, v)
    end
    return set
end

-- Return a table containing the values of set s.
function to_table(s)
    local t = {}
    for v,_ in pairs(s) do
        table.insert(t, v)
    end
    return t
end

local sets = {
    -- add = add,
    -- contains = contains,
    from_table = from_table,
    subtract = subtract,
    to_table = to_table
}

return sets
