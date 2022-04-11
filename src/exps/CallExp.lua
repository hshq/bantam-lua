
--[[
 * A function call like "a(b, c, d)".
--]]
---@class CallExp
return class('exps.CallExp',
---@param func Exp
---@param args List<Exp>
---@return CallExp
function(func, args)
  local mFunction = func
  local mArgs     = args

  return {
    ---@param builder StringBuilder
    ---@return nil
    print = function(builder)
      builder.append(mFunction, '(')
      for i, arg in ipairs(mArgs) do
        builder.append(arg, (i < #mArgs and ', ' or nil))
      end
      builder.append(')')
    end,
  }
end
, 'exps.Exp')
