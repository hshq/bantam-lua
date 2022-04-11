
local Precedence = require 'Precedence'
local TokenType  = require 'TokenType'
local CondExp    = require 'exps.CondExp'

--[[
 * Parselet for the condition or "ternary" operator, like "a ? b : c".
--]]
---@class CondParselet
return class('parselets.CondParselet',
---@return CondParselet
function()
  return {
    ---@param parser Parser
    ---@param left Exp
    ---@param token Token
    ---@return Exp
    parse = function(parser, left, token)
      local thenArm = parser.parseExp()
      parser.consume(TokenType.COLON)
      local elseArm = parser.parseExp(Precedence.CONDITIONAL - 1)

      return CondExp(left, thenArm, elseArm)
    end,

    ---@return number int
    getPrecedence = function()
      return Precedence.CONDITIONAL
    end,
  }
end
, 'parselets.InfixOpParselet')
