
--[[
 * A ternary conditional expression like "a ? b : c".
--]]
---@class CondExp
return class('exps.CondExp',
---@param condition Exp
---@param thenArm Exp
---@param elseArm Exp
---@return CondExp
function(condition, thenArm, elseArm)
  local mCondition = condition
  local mThenArm   = thenArm
  local mElseArm   = elseArm

  return {
    ---@param builder StringBuilder
    ---@return nil
    print = function(builder)
      builder.append('(', mCondition, ' ? ', mThenArm, ' : ', mElseArm, ')')
    end,
  }
end
, 'exps.Exp')
