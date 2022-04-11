
local NameExp = require 'exps.NameExp'

--[[
 * Simple parselet for a named variable like "abc".
--]]
---@class NameParselet
return class('parselets.NameParselet',
---@return NameParselet
function()
  return {
    ---@param parser Parser
    ---@param token Token
    ---@return Exp
    parse = function(parser, token)
      return NameExp(token.getText())
    end,
  }
end
, 'parselets.PrefixOpParselet')
