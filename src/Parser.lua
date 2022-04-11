
local assert = assert

-- local HashMap = require 'HashMap'

local TokenType        = require 'TokenType'
local ParseException   = require 'ParseException'
local InfixOpParselet  = require 'parselets.InfixOpParselet'
local PrefixOpParselet = require 'parselets.PrefixOpParselet'

---@class Parser
---@field parseExp function
---@field consume function
---@field match function

---@param tokens Iterator<Token>
---@return Parser
return class('Parser',
function(tokens)
  local mTokens = tokens

  ---@type Token
  local mRead

  -- Map<TokenType, PrefixOpParselet> mPrefixOpParselets =
  --     new HashMap<TokenType, PrefixOpParselet>()
  -- local mPrefixOpParselets = HashMap()
  local mPrefixOpParselets = {}

  -- Map<TokenType, InfixOpParselet> mInfixOpParselets =
  --     new HashMap<TokenType, InfixOpParselet>()
  -- local mInfixOpParselets = HashMap()
  local mInfixOpParselets = {}

  local this, consume

  ---@return Token
  local function lookAhead()
    if not mRead then
      mRead = mTokens.next()
    end

    return mRead
  end

  ---@param token TokenType
  ---@param parselet PrefixOpParselet
  ---@return nil
  local registerPrefix = function(token, parselet)
    -- mPrefixOpParselets.put(token, parselet)
    mPrefixOpParselets[token] = parselet
  end

  ---@param token TokenType
  ---@param parselet InfixOpParselet
  ---@return nil
  local registerInfix = function(token, parselet)
    -- mInfixOpParselets.put(token, parselet)
    mInfixOpParselets[token] = parselet
  end

  ---@param token TokenType
  ---@param parselet PrefixOpParselet|InfixOpParselet
  ---@return nil
  local register = function(token, parselet)
    if instanceof(parselet, InfixOpParselet) then
      registerInfix(token, parselet)
    elseif instanceof(parselet, PrefixOpParselet) then
      registerPrefix(token, parselet)
    else
      assert(false)
    end
  end

  ---@return number int
  local getPrecedence = function()
    -- local parser = mInfixOpParselets.get(lookAhead().getType())
    local parseslet = mInfixOpParselets[lookAhead().getType()]
    if parseslet ~= nil then
      return parseslet.getPrecedence()
    end

    return 0
  end

  ---@param precedence? number int
  ---@return Exp
  local parseExp = function(precedence)
    ---@param precedence number int
    precedence = precedence or 0

    local token = consume()
    assert(token.getType() ~= TokenType.EOF)

    -- local prefix = mPrefixOpParselets.get(token.getType())
    local prefix = mPrefixOpParselets[token.getType()]

    if prefix == nil then
      ParseException(('Could not parse "%s".'):format(token.getText()))
    end

    local left = prefix.parse(this, token)

    while precedence < getPrecedence() do
      token = consume()

      -- local infix = mInfixOpParselets.get(token.getType())
      local infix = mInfixOpParselets[token.getType()]
      left = infix.parse(this, left, token)
    end

    return left
  end

  ---@param expected TokenType
  ---@return boolean
  local match = function(expected)
    local token = lookAhead()
    if token.getType() ~= expected then
      return false
    end

    mRead = nil
    return true
  end

  ---@param expected? TokenType
  ---@return Token
  consume = function(expected)
    -- Make sure we've read the token.
    local token = lookAhead()

    ---@type TokenType
    if expected then
      if token.getType() ~= expected then
        RuntimeException(("Expected token %s and found %s"):format(
          expected, token.getType()))
      end
    end

    mRead = nil
    return token
  end

  this = {
    registerPrefix = registerPrefix,
    registerInfix  = registerInfix,
    register       = register,
    parseExp       = parseExp,
    match          = match,
    consume        = consume,
    -- getPrecedence = getPrecedence,
  }
  return this
end)
