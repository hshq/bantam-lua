
local push = table.insert

-- local ArrayList = ArrayList

local Precedence = require 'Precedence'
local TokenType  = require 'TokenType'
local CallExp    = require 'exps.CallExp'

--[[
 * Parselet to parse a function call like "a(b, c, d)".
--]]
---@class CallParselet
return class('parselets.CallParselet',
---@return CallParselet
function()
  return {
    ---@param parser Parser
    ---@param left Exp
    ---@param token Token
    ---@return Exp
    parse = function(parser, left, token)
      -- Parse the comma-separated arguments until we hit, ")".
      -- List<Exp> args = new ArrayList<Exp>()
      -- local args = ArrayList()
      local args = {}

      -- There may be no arguments at all.
      if not parser.match(TokenType.RIGHT_PAREN) then
        repeat
          -- args.add(parser.parseExp())
          push(args, parser.parseExp())
        until not parser.match(TokenType.COMMA)
        parser.consume(TokenType.RIGHT_PAREN)
      end

      return CallExp(left, args)
    end,

    ---@return number int
    getPrecedence = function()
      return Precedence.CALL
    end,
  }
end
, 'parselets.InfixOpParselet')
