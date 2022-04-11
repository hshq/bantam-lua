
---@class HashMap

---@return HashMap
return function()
    local map = {}

    return {
        ---@param k any
        ---@param v any
        ---@return nil
        put = function(k, v)
            map[k] = v
        end,

        ---@param k any
        ---@return boolean
        containsKey = function(k)
            return map[k] ~= nil
        end,

        ---@param k any
        ---@return any
        get = function(k)
            return map[k]
        end,
    }
end
