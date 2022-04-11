
---@param message string
---@return nil
return function(message)
  return error('Unsupported Operation: ' .. message, 2)
end
