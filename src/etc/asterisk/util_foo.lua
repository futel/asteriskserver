-- return iterator that zips over left and right sequences
-- until left is exhausted
function zip(left, right)
    left_iter = iter(left)
    right_iter = iter(right)
    elements = {}
    return function ()
        if #elements == 0 then
            left_element = left_iter()
            if left_element then
                table.insert(elements, right_iter()) -- push
                table.insert(elements, left_element) -- push
            end
        end
        return table.remove(elements) -- pop
    end
end
