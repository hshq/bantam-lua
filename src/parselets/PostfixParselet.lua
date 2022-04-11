
local PostfixExp = require 'exps.PostfixExp'

--[[
 * Generic infix parselet for an unary arithmetic operator. Parses postfix
 * unary "?" expressions.
--]]
---@class PostfixParselet
return class('parselets.PostfixParselet',
---@param precedence number int
---@return PostfixParselet
function(precedence)
  local mPrecedence = precedence

  return {
    ---@param parser Parser
    ---@param left Exp
    ---@param token Token
    ---@return Exp
    parse = function(parser, left, token)
      return PostfixExp(left, token.getType())
    end,

    ---@return number int
    getPrecedence = function()
      return mPrecedence
    end,
  }
end
, 'parselets.InfixOpParselet')
