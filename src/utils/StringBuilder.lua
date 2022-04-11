
local push = table.insert
local join = table.concat

---@class StringBuilder
---@field append function

---@return StringBuilder
return function()
  local buf = {}
  local this

  this = {
    ---@vararg Exp|string
    ---@return StringBuilder
    append = function(...)
      for _, exp in ipairs{...} do
        if type(exp) == 'string' then
          push(buf, exp)
        else
          exp.print(this)
        end
      end
      return this
    end,

    ---@return string
    toString = function()
      return join(buf)
    end,
  }
  return this
end
