
local pairs = pairs

-- local HashMap = require 'HashMap'

local Token     = require 'Token'
local TokenType = require 'TokenType'

--[[
 * A very primitive lexer. Takes a string and splits it into a series of
 * Tokens. Operators and punctuation are mapped to unique keywords. Names,
 * which can be any series of letters, are turned into NAME tokens. All other
 * characters are ignored (except to separate names). Numbers and strings are
 * not supported. This is really just the bare minimum to give the parser
 * something to work with.
--]]

--[[
  * Creates a new Lexer to tokenize the given string.
  * @param text String to tokenize.
--]]
---@class Lexer
---@param text string
---@return Lexer
return function(text)
  -- Map<Character, TokenType> mPunctuators =
  --     new HashMap<Character, TokenType>()
  -- local mPunctuators = HashMap()
  local mPunctuators = {}
  local mText        = text
  local mIndex       = START_INDEX

  -- Register all of the TokenTypes that are explicit punctuators.
  ---@param typ TokenType
  for _, typ in pairs(TokenType) do
    local punctuator = typ.punctuator()
    if punctuator then
      -- mPunctuators.put(punctuator, typ)
      mPunctuators[punctuator] = typ
    end
  end

  return {
    -- -- @Override
    -- ---@return boolean
    -- hasNext = function()
    --   return true
    -- end,

    -- @Override
    ---@return Token
    next = function()
      while mIndex <= #mText do
        local c = mText:sub(mIndex, mIndex)

        -- if mPunctuators.containsKey(c) then
        if mPunctuators[c] then
          mIndex = mIndex + 1
          -- Handle punctuation.
          -- return Token(mPunctuators.get(c), c)
          return Token(mPunctuators[c], c)
        else
          -- NOTE hsq 正则中的 ^ 是必须的，否则会越过指定位置开始的非匹配字符。
          local name = mText:match('^%a+', mIndex)
          if name then
            -- Handle names.
            mIndex = mIndex + #name
            return Token(TokenType.NAME, name)
          else
            mIndex = mIndex + 1
            -- Ignore all other characters (whitespace, etc.)
          end
        end
      end

      -- Once we've reached the end of the string, just return EOF tokens. We'll
      -- just keeping returning them as many times as we're asked so that the
      -- parser's lookahead doesn't have to worry about running out of tokens.
      return Token(TokenType.EOF, "")
    end,

    -- -- @Override
    -- ---@return nil
    -- remove = function()
    --   UnsupportedOperationException()
    -- end,
  }
end
