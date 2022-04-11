
---@class List
---@class Iterator


if not _ENV then
    function _G._env()
        return _G.getfenv(2)
    end
end

_G.START_INDEX = 1


local OO = require 'utils.oo'
_G.class      = OO.class
_G.interface  = OO.interface
_G.instanceof = OO.instanceof
_G.is         = OO.is

-- _G.ArrayList     = require 'utils.ArrayList'
-- _G.HashMap       = require 'utils.HashMap'
_G.StringBuilder = require 'utils.StringBuilder'

_G.RuntimeException = require 'utils.RuntimeException'
_G.UnsupportedOperationException =
    require "utils.UnsupportedOperationException"
