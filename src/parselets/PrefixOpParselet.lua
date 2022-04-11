
--[[
 * One of the two interfaces used by the Pratt parser. A PrefixOpParselet is
 * associated with a token that appears at the beginning of an expression. Its
 * parse() method will be called with the consumed leading token, and the
 * parselet is responsible for parsing anything that comes after that token.
 * This interface is also used for single-token expressions like variables, in
 * which case parse() simply doesn't consume any more tokens.
 * @author rnystrom
 *
--]]
---@class PrefixOpParselet
return interface {
  ---@param parser Parser
  ---@param token Token
  ---@return Exp
  parse = 'function(parser, token)',
}
