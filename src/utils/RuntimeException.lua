
---@param message string
---@return nil
return function(message)
  return error('Runtime Error: ' .. message, 2)
end
