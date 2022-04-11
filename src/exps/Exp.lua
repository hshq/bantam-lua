
--[[
 * Interface for all expression AST node classes.
--]]
---@class Exp
return interface {
  --[[
   * Pretty-print the expression to a string.
  --]]
  ---@param builder StringBuilder
  ---@return nil
  print = 'function(builder)',
}
