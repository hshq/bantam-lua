
--[[
 * An assignment expression like "a = b".
--]]
---@class AssignExp
return class('exps.AssignExp',
---@param name Exp
---@param right Exp
---@return AssignExp
function(name, right)
  local mName  = name
  local mRight = right

  return {
    ---@param builder StringBuilder
    ---@return nil
    print = function(builder)
      builder.append('(', mName, ' = ', mRight, ')')
    end,
  }
end
, 'exps.Exp')
