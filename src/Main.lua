
require 'utils'

local StringBuilder = StringBuilder

local TokenType     = require 'TokenType'
local Lexer         = require 'Lexer'
local BantamParser  = require 'BantamParser'

local test
local sPassed = 0
local sFailed = 0

---@param args string[]
---@return nil
local function main(args)
  -- Function call.
  test("a()", "a()")
  test("a(b)", "a(b)")
  test("a(b, c)", "a(b, c)")
  test("a(b)(c)", "a(b)(c)")
  test("a(b) + c(d)", "(a(b) + c(d))")
  test("a(b ? c : d, e + f)", "a((b ? c : d), (e + f))")

  -- Unary precedence.
  test("~!-+a", "(~(!(-(+a))))")
  test("a!!!", "(((a!)!)!)")

  -- Unary and binary predecence.
  test("-a * b", "((-a) * b)")
  test("!a + b", "((!a) + b)")
  test("~a ^ b", "((~a) ^ b)")
  test("-a!",    "(-(a!))")
  test("!a!",    "(!(a!))")

  -- Binary precedence.
  test("a = b + c * d ^ e - f / g", "(a = ((b + (c * (d ^ e))) - (f / g)))")

  -- Binary associativity.
  test("a = b = c", "(a = (b = c))")
  test("a + b - c", "((a + b) - c)")
  test("a * b / c", "((a * b) / c)")
  test("a ^ b ^ c", "(a ^ (b ^ c))")

  -- Conditional operator.
  test("a ? b : c ? d : e", "(a ? b : (c ? d : e))")
  test("a ? b ? c : d : e", "(a ? (b ? c : d) : e)")
  test("a + b ? c * d : e / f", "((a + b) ? (c * d) : (e / f))")

  -- Grouping.
  test("a + (b + c) + d", "((a + (b + c)) + d)")
  test("a ^ (b + c)", "(a ^ (b + c))")
  test("(!a)!",    "((!a)!)")

  -- Show the results.
  if sFailed == 0 then
    print(("Passed all %d tests."):format(sPassed))
  else
    print("----")
    print(("Failed %d out of %d tests."):format(sFailed, (sFailed + sPassed)))
  end
end

--[[
  * Parses the given chunk of code and verifies that it matches the expected
  * pretty-printed result.
--]]
---@param source string
---@param expected string
---@return nil
function test(source, expected)
  local lexer = Lexer(source)
  local parser = BantamParser(lexer)

  ---@return nil
  local function try()
    local result = parser.parseExp()
    local actual = StringBuilder().append(result).toString()
    assert(parser.match(TokenType.EOF))

    if expected == actual then
      sPassed = sPassed + 1
    else
      sFailed = sFailed + 1
      print("[FAIL] Expected: ", expected)
      print("         Actual: ", actual)
    end
  end

  ---@param ex string
  ---@return nil
  local function catch(ex)
    sFailed = sFailed + 1
    print("[FAIL] Expected: ", expected)
    -- print("          Error: ", ex.getMessage())
    print("          Error: ", ex)
  end

  xpcall(try, catch)
end

main{...}