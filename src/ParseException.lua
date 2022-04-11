
---@param message string
---@return nil
return function(message)
  return error('Parse Exception: ' .. message, 2)
end
