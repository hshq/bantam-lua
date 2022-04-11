
--[[
 * A simple variable name expression like "abc".
--]]
---@class NameExp
return class('exps.NameExp',
---@param name string
---@return NameExp
function(name)
  local mName = name

  return {
    ---@param builder StringBuilder
    ---@return nil
    print = function(builder)
      builder.append(mName)
    end,
  }
end
, 'exps.Exp')
