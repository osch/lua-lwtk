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

local upper  = string.upper
local sub    = string.sub
local format = string.format

local lwtk  = require"lwtk"
local Class = lwtk.Class

local Object = {}
Object.__index = Object
Object.__name = "lwtk.Object"
setmetatable(Object, Class)

function Object:new()
end

function Object.newClass(className, superClass)
  local newClass = {}
  for k, v in pairs(superClass) do
      newClass[k] = v
  end
  newClass.__index = newClass
  newClass.__name = className
  setmetatable(newClass, Class)
  newClass.super = superClass
  return newClass
end


function Object.implement(class, ...)
  for _, mixin in pairs({...}) do
    for k, v in pairs(mixin) do
      if class[k] == nil and type(v) == "function" then
        class[k] = v
      end
    end
    if mixin.initClass then
        mixin:initClass(class)
    end
  end
end


function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = mt.super
  end
  return false
end


function Object:setAttributes(attr)
    assert(type(attr) == "table", "table expected")
    for k, v in pairs(attr) do
        assert(type(k) == "string", "attribute names  must be string")
        local setterName = "set"..upper(sub(k, 1, 1))..sub(k, 2)
        local setter = self[setterName]
        assert(type(setter) == "function", "unknown attribute '"..k.."'")
        setter(self, v)
    end
end


return Object