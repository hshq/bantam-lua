
local BinaryExp = require 'exps.BinaryExp'

--[[
 * Generic infix parselet for a binary arithmetic operator. The only
 * difference when parsing, "+", "-", "*", "/", and "^" is precedence and
 * associativity, so we can use a single parselet class for all of those.
--]]
---@class BinaryParselet
return class('parselets.BinaryParselet',
---@param precedence number int
---@param isRight boolean
---@return BinaryParselet
function(precedence, isRight)
  local mPrecedence = precedence
  local mIsRight    = isRight

  return {
    ---@param parser Parser
    ---@param left Exp
    ---@param token Token
    ---@return Exp
    parse = function(parser, left, token)
      -- To handle right-associative operators like "^", we allow a slightly
      -- lower precedence when parsing the right-hand side. This will let a
      -- parselet with the same precedence appear on the right, which will then
      -- take *this* parselet's result as its left-hand argument.
      local right = parser.parseExp(mPrecedence - (mIsRight and 1 or 0))

      return BinaryExp(left, token.getType(), right)
    end,

    ---@return number int
    getPrecedence = function()
      return mPrecedence
    end,
  }
end
, 'parselets.InfixOpParselet')
