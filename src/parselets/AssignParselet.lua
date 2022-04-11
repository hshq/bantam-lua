
local instanceof = instanceof

local ParseException = require 'ParseException'
local Precedence     = require 'Precedence'
local AssignExp      = require 'exps.AssignExp'
local NameExp        = require 'exps.NameExp'

--[[
 * Parses assignment expressions like "a = b". The left side of an assignment
 * expression must be a simple name like "a", and expressions are
 * right-associative. (In other words, "a = b = c" is parsed as "a = (b = c)").
--]]
---@class AssignParselet
return class('parselets.AssignParselet',
---@return AssignParselet
function()
  return {
    ---@param parser Parser
    ---@param left Exp
    ---@param token Token
    ---@return Exp
    parse = function(parser, left, token)
      local right = parser.parseExp(Precedence.ASSIGNMENT - 1)

      -- if not (left.instanceof(NameExp)) then
      if not (instanceof(left, NameExp)) then
        ParseException(
          'The left-hand side of an assignment must be a name.')
      end

      return AssignExp(left, right)
    end,

    ---@return number int
    getPrecedence = function()
      return Precedence.ASSIGNMENT
    end,
  }
end
, 'parselets.InfixOpParselet')
