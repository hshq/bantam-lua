
local push   = table.insert
local remove = table.remove

---@class ArrayList

---@return ArrayList
return function()
    local vec = {}

    return {
        ---@param item any
        ---@return nil
        add = function(item)
            push(vec, item)
        end,

        ---@return number int
        size = function()
            return #vec
        end,

        ---@param index number int
        ---@return any
        get = function(index)
            return vec[index]
        end,

        ---@param index number int
        ---@return any
        remove = function(index)
            return remove(vec, index)
        end,
    }
end
