
--[[
 * A postfix unary arithmetic expression like "a!".
--]]
---@class PostfixExp
return class('exps.PostfixExp',
---@param left Exp
---@param op TokenType
---@return PostfixExp
function(left, op)
  local mLeft = left
  local mOp   = op

  return {
    ---@param builder StringBuilder
    ---@return nil
    print = function(builder)
      builder.append('(', mLeft, mOp.punctuator(), ')')
    end,
  }
end
, 'exps.Exp')
