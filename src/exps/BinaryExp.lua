
--[[
 * A binary arithmetic expression like "a + b" or "c ^ d".
--]]
---@class BinaryExp
return class('exps.BinaryExp',
---@param left Exp
---@param op TokenType
---@param right Exp
---@return BinaryExp
function(left, op, right)
  local mLeft  = left
  local mOp    = op
  local mRight = right

  return {
    ---@param builder StringBuilder
    ---@return nil
    print = function(builder)
      builder.append('(', mLeft, ' ', mOp.punctuator(), ' ', mRight, ')')
    end,
  }
end
, 'exps.Exp')
