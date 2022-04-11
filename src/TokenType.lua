
---@class TokenType
---@field punctuator function

-- enum
local TokenType = {
  LEFT_PAREN  = '(',
  RIGHT_PAREN = ')',
  COMMA       = ',',
  ASSIGN      = '=',
  PLUS        = '+',
  MINUS       = '-',
  ASTERISK    = '*',
  SLASH       = '/',
  CARET       = '^',
  TILDE       = '~',
  BANG        = '!',
  QUESTION    = '?',
  COLON       = ':',
  NAME        = false,
  EOF         = false,
}

local mt = {
  -- NOTE hsq 用于 Parser.consume 中的报错。
  __tostring = function(tt) return tt.v or tt.k end,
}
for k, punc in pairs(TokenType) do
  --[[
    * If the TokenType represents a punctuator (i.e. a token that can split an
    * identifier like '+', this will get its text.
  --]]
  TokenType[k] = setmetatable({
    punctuator = function() return punc--[[ , k ]] end,
    k = k, v = punc,
  }, mt)
  -- TokenType[k] = function() return punc--[[ , k ]] end
end

-- setmetatable(TokenType, {
--   __index = function(t, k) error('invalid field: ' .. k, 2) end,
-- })

return TokenType
