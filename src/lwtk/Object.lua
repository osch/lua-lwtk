--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--
-- copied from also https://github.com/rxi/classic
--

local lua_version = _VERSION:match("[%d%.]*$")
local isOldLua = (#lua_version == 3 and lua_version < "5.3")

local upper  = string.upper
local sub    = string.sub

local lwtk          = require("lwtk")
local Class         = lwtk.Class
local getSuperClass = lwtk.get.superClass


local Object = {}
Object.__index = Object
Object.__name = "lwtk.Object"
setmetatable(Object, Class)

function Object:new()
end

local fallbackToString
if isOldLua then
    fallbackToString = function(self)
        local mt = getmetatable(self)
        setmetatable(self, nil)
        local s = tostring(self)
        setmetatable(self, mt)
        return mt.__name..": "..s:match("([^ :]*)$")
    end
end

function Object.newSubClass(className, superClass)
    local newClass = {}
    for k, v in pairs(superClass) do
        if k ~= "extra" then
            newClass[k] = v
        end
    end
    newClass.__index = newClass
    newClass.__name = className
    if isOldLua and not newClass.__tostring then
        newClass.__tostring = fallbackToString
    end
    setmetatable(newClass, Class)
    getSuperClass[newClass] = superClass
    return newClass
end


Object.isInstanceOf = lwtk.isInstanceOf

function Object:setAttributes(attr)
    if attr ~= nil then
        assert(type(attr) == "table", "table expected")
        for k, v in pairs(attr) do
            assert(type(k) == "string", "attribute names  must be string")
            local setterName = "set"..upper(sub(k, 1, 1))..sub(k, 2)
            local setter = self[setterName]
            assert(type(setter) == "function", "unknown attribute '"..k.."'")
            setter(self, v)
        end
    end
end

return Object
