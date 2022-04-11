
local PrefixExp = require 'exps.PrefixExp'

--[[
 * Generic prefix parselet for an unary arithmetic operator. Parses prefix
 * unary "-", "+", "~", and "!" expressions.
--]]
---@class PrefixParselet
return class('parselets.PrefixParselet',
---@param precedence number int
---@return PrefixParselet
function(precedence)
  local mPrecedence = precedence

  return {
    ---@param parser Parser
    ---@param token Token
    ---@return Exp
    parse = function(parser, token)
      local right = parser.parseExp(mPrecedence)

      return PrefixExp(token.getType(), right)
    end,

    -- ---@return number int
    -- getPrecedence = function()
    --   return mPrecedence
    -- end,
  }
end
, 'parselets.PrefixOpParselet')
