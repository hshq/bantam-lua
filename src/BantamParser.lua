
-- import com.stuffwithstuff.bantam.parselets.*
local AssignParselet  = require 'parselets.AssignParselet'
local BinaryParselet  = require 'parselets.BinaryParselet'
local CallParselet    = require 'parselets.CallParselet'
local CondParselet    = require 'parselets.CondParselet'
local GroupParselet   = require 'parselets.GroupParselet'
local NameParselet    = require 'parselets.NameParselet'
local PostfixParselet = require 'parselets.PostfixParselet'
local PrefixParselet  = require 'parselets.PrefixParselet'

local Precedence = require 'Precedence'
local TokenType  = require 'TokenType'

--[[
 * Extends the generic Parser class with support for parsing the actual Bantam
 * grammar.
--]]

local register

--[[
  * Registers a postfix unary operator parselet for the given token and
  * precedence.
--]]
---@param token TokenType
---@return nil
local function postfix(token)
  register(token, PostfixParselet(Precedence.POSTFIX))
end

--[[
  * Registers a prefix unary operator parselet for the given token and
  * precedence.
--]]
---@param token TokenType
---@return nil
local function prefix(token)
  register(token, PrefixParselet(Precedence.PREFIX))
end

--[[
  * Registers a left-associative binary operator parselet for the given token
  * and precedence.
--]]
---@param token TokenType
---@param precedence number int
---@return nil
local function infixLeft(token, precedence)
  register(token, BinaryParselet(precedence, false))
end

--[[
  * Registers a right-associative binary operator parselet for the given token
  * and precedence.
--]]
---@param token TokenType
---@param precedence number int
---@return nil
local function infixRight(token, precedence)
  register(token, BinaryParselet(precedence, true))
end

local super = require 'Parser'
local _ENV = _ENV or _env()

---@class BantamParser

return _ENV.class('BantamParser',
---@param lexer Lexer
---@return BantamParser
function(lexer)
  -- super(lexer)
  local this = super(lexer)
  _ENV.register = this.register
  register = this.register

  -- Register all of the parselets for the grammar.

  -- Register the ones that need special parselets.
  register(TokenType.NAME,       NameParselet())
  register(TokenType.ASSIGN,     AssignParselet())
  register(TokenType.QUESTION,   CondParselet())
  register(TokenType.LEFT_PAREN, GroupParselet())
  register(TokenType.LEFT_PAREN, CallParselet())

  -- Register the simple operator parselets.
  prefix(TokenType.PLUS)
  prefix(TokenType.MINUS)
  prefix(TokenType.TILDE)
  prefix(TokenType.BANG)

  -- For kicks, we'll make "!" both prefix and postfix, kind of like ++.
  postfix(TokenType.BANG)

  infixLeft(TokenType.PLUS,     Precedence.SUM)
  infixLeft(TokenType.MINUS,    Precedence.SUM)
  infixLeft(TokenType.ASTERISK, Precedence.PRODUCT)
  infixLeft(TokenType.SLASH,    Precedence.PRODUCT)
  infixRight(TokenType.CARET,   Precedence.EXPONENT)

  -- this.postfix    = postfix
  -- this.prefix     = prefix
  -- this.infixLeft  = infixLeft
  -- this.infixRight = infixRight
  return this
end)
