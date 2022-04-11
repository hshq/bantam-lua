
--[[
 * A prefix unary arithmetic expression like "!a" or "-b".
--]]
---@class PrefixExp
return class('exps.PrefixExp',
---@param op TokenType
---@param right Exp
---@return PrefixExp
function(op, right)
  local mOp    = op
  local mRight = right

  return {
    ---@param builder StringBuilder
    ---@return nil
    print = function(builder)
      builder.append('(', mOp.punctuator(), mRight, ')')
    end,
  }
end
, 'exps.Exp')
