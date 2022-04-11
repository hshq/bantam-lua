
local TokenType = require 'TokenType'

--[[
 * Parses parentheses used to group an expression, like "a * (b + c)".
--]]
---@class GroupParselet
return class('parselets.GroupParselet',
---@return GroupParselet
function()
  return {
    ---@param parser Parser
    ---@param token Token
    ---@return Exp
    parse = function(parser, token)
      local expression = parser.parseExp()
      parser.consume(TokenType.RIGHT_PAREN)
      return expression
    end,
  }
end
, 'parselets.PrefixOpParselet')
