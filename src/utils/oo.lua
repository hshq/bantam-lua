
local ipairs  = ipairs
local pairs   = pairs
local type    = type
local require = require
local assert  = assert
-- local setmetatable = setmetatable
-- local getmetatable = getmetatable

--[[
NOTE hsq 基于函数、upvalue 的 OO 继承用法：
  1 子类中导入父类构造函数，可命名为 super，在子类构造函数中调用它，
    返回父类对象，将子类接口附加其中，并返回它；
    父类状态在私有的 upvalue 中，不受影响。
  2 子类中: local _ENV = _ENV or getfenv()
    将需要调用的父类接口导入 _ENV ，即可直接调用而无需对象前缀。
  3 参考 BantamParser: Parser 。

NOTE hsq interface:
  {
    __INTERFACE = true,
    name = function(...) ... end,
    ...
  }

NOTE hsq class:
  function(...)
    return {
      __CONSTRUCTOR = ctor,
      __INTERFACES = {...},
      ...
    }
  end
--]]

---@param funcs table
---@return table
local function interface(funcs)
  assert(type(funcs) == 'table')
  assert(funcs.__INTERFACE == nil)
  funcs.__INTERFACE = true
  return funcs
end

local classes = {} -- {name = ctor, ctor = name}
local checked_implements = {} -- {ctor = true}

---@param name string
---@param ctor function
---@vararg table|function interfaces
---@return function
local function class(name, ctor, ...)
  assert(not classes[name])
  assert(not classes[ctor])

  local interfaces = {}
  for _, iface in ipairs{...} do
    if type(iface) == 'string' then
      iface = require(iface)
      interfaces[iface] = true
    end
    assert(iface.__INTERFACE)
  end

  -- NOTE hsq 用或不用 metatable：搜索 mt 。
  -- local mt = {}

  ---@vararg any
  ---@return table
  local function ctor2(...)
    local obj = ctor(...)

    if not checked_implements[ctor] then
      checked_implements[ctor] = true
      for iface in pairs(interfaces) do
        for k, v in pairs(iface) do
          -- assert(type(v) == 'function')
          if type(v) == 'function' then
            -- assert(obj[k] and type(obj[k]) == 'function')
            if not obj[k] or type(obj[k]) ~= 'function' then
              local cls = classes[obj.__CONSTRUCTOR] or '<unknown class>'
              UnsupportedOperationException(('%s.%s'):format(cls, k))
            end
          end
        end
      end
    end

    -- ---@param meta function
    -- ---@return boolean
    -- obj.instanceof = function(meta)
    --   -- return getmetatable(obj) == meta -- mt
    --   return meta == ctor2
    -- end
    -- obj.is = obj.instanceof

    -- return setmetatable(obj, mt)
    obj.__CONSTRUCTOR = ctor2
    obj.__INTERFACES  = interfaces
    return obj
  end

  classes[name] = ctor2
  classes[ctor2] = name

  -- mt.__metatable = ctor2
  return ctor2
end

---@param obj any
---@param meta function|table
---@return boolean
local function instanceof(obj, meta)
  if type(meta) == 'function' then
    return obj.__CONSTRUCTOR == meta
    -- return getmetatable(obj) == meta -- mt
  else
    assert(meta.__INTERFACE)
    return obj.__INTERFACES[meta]
  end
end

return {
  interface  = interface,
  class      = class,

  instanceof = instanceof,
  is         = instanceof,
}
