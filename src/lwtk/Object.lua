--
-- This code was inspired by:
-- 
--      classic
--     
--      Copyright (c) 2014, rxi
--     
--      This module is free software; you can redistribute it and/or modify it under
--      the terms of the MIT license. See LICENSE for details.
--     
--      see also https://github.com/rxi/classic
--     

local rawset       = rawset
local rawget       = rawget
local getmetatable = getmetatable
local upper        = string.upper
local sub          = string.sub

local lwtk          = require("lwtk")
local Class         = lwtk.Class
local type          = lwtk.type
local getSuperClass = lwtk.get.superClass
local getClass      = lwtk.get.class
local getObjectMeta = lwtk.get.objectMeta
local getMixinBase  = lwtk.get.mixinBase

local indexMeta = {}

local createObjMetaNewIndex

if _G.LWTK_DISABLE_CHECKS then
    function createObjMetaNewIndex(newObjMeta, index)
    end
else
    function createObjMetaNewIndex(newObjMeta, index)
        function newObjMeta:__newindex(k, v)
            if type(k) ~= "string" or index[k] ~= nil then
                rawset(self, k, v)
            else
                lwtk.errorf("no object member %q declared in class %s", k, self:getClassPath())
            end
        end
    end
    function indexMeta:__index(k)
        if type(k) == "string" then
            lwtk.errorf("member %q not declared in class %s", k, getClass[getObjectMeta[self]]:getClassPath())
        end
    end
end

local function onext(obj, k)
    local index = getObjectMeta[getmetatable(obj)].__index
    while true do
        k = next(index, k)
        local rslt = (k ~= nil and obj[k])
        if rslt ~= nil then
            return k, rslt
        end
    end
end

local function objPairs(obj)
    return onext, obj, nil
end

local function createClass(newObjMeta, className, index, baseClass)
    newObjMeta.__name = className
    if newObjMeta.__tostring == nil then
        newObjMeta.__tostring = lwtk.Meta.fallbackToString
    end
    createObjMetaNewIndex(newObjMeta, index)
    local newClass = {}
    newObjMeta.declared = {}
    newObjMeta.__index     = setmetatable(index, indexMeta)
    newObjMeta.__metatable = newClass
    newObjMeta.__pairs = objPairs
    
    getObjectMeta[newClass] = newObjMeta
    getObjectMeta[index]    = newObjMeta
    getSuperClass[newClass] = baseClass
    getClass[newObjMeta]    = newClass
    setmetatable(newClass, Class)
    
    return newClass
end

--[[
    Superclass for all classes created by lwtk.newClass().
]]
local Object = createClass({}, "lwtk.Object", {})

function Object.static.newSubClass(baseClass, className, ...)
    assert(type(baseClass) == "lwtk.Class", "arg 1 must be of type lwtk.Class")
    assert(type(className) == "string", "arg 2: exptected class name string")
    local baseObjMeta = getObjectMeta[baseClass]
    local newObjMeta = {}
    for k, v in pairs(baseObjMeta) do
        if type(k) == "string" and k ~= "extra"   and k ~= "static"    and k ~= "declared"   
                               and k ~= "__index" and k ~= "override"  and k ~= "__newindex" and k ~= "__name"
                               and k ~= "implement"
        then
            newObjMeta[k] = v
        end
    end
    local index = {}
    for k, v in pairs(baseObjMeta.__index) do
        index[k] = v
    end
    local newClass = createClass(newObjMeta, className, index, baseClass)
    return newClass
end

Object.isInstanceOf = lwtk.isInstanceOf

local function getClassPath(self)
    local s = getSuperClass[self]
    local p = s and "("..getClassPath(s)..")" or ""
    local mixinBase = getMixinBase[self]
    if mixinBase then
        return "#"..mixinBase.__name..p
    else
        return self.__name..p
    end
end

function Object:getClassPath()
    local mt = getmetatable(self)
    if mt == Class then
        return getClassPath(self)
    else
        return getClassPath(mt)
    end
end

--[[
    Returns the superclass of this object.
    
    This method can also be called on a class. In this
    case the superclass of the given class is returned.
]]
function Object:getSuperClass()
    local mt = getmetatable(self)
    if mt == Class then
        return getSuperClass[self]
    else
        return getSuperClass[mt]
    end
end

function Object:getMember(name)
    local mt = getmetatable(self)
    if mt == Class then
        local objMeta = getObjectMeta[self]
        return rawget(objMeta.__index, name)
    else
        local m = rawget(self, name)
        if m == nil then
            m = rawget(getmetatable(self).__index, name)
        end
        return m
    end
end

local function getReverseClassPath(self)
    local s = getSuperClass[self]
    local p = s and getReverseClassPath(s).."/" or "/"
    local mixinBase = getMixinBase[self]
    if mixinBase then
        return p.."#"..mixinBase.__name
    else
        return p..self.__name
    end
end

function Object:getReverseClassPath()
    local mt = getmetatable(self)
    if mt == Class then
        return getReverseClassPath(self)
    else
        return getReverseClassPath(mt)
    end
end

function Object:getClass()
    return getmetatable(self)
end

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

function Object.static:getMixinBase()
    return getMixinBase[self]
end

if _G.LWTK_DISABLE_CHECKS then
    function Object.static:declare(...)
        for i = 1, select("#", ...) do
            local var = select(i, ...)
            self[var] = false
        end
    end 
else
    function Object.static:declare(...)
        for i = 1, select("#", ...) do
            local var = select(i, ...)
            if var:match("^[a-zA-Z_][a-zA-Z_0-9]*$") then
                local objMeta = getObjectMeta[self]
                if objMeta[var] == nil then
                    self[var] = false
                else
                    local c = self
                    local m = objMeta
                    while true do
                        if m.declared[var] then
                            if c[var] ~= false then
                                lwtk.errorf("member %q from class %q is already defined in superclass %q in class path %s", var, objMeta.__name, m.__name, self:getClassPath())
                            else
                                lwtk.errorf("member %q from class %q is already declared in superclass %q in class path %s", var, objMeta.__name, m.__name, self:getClassPath())
                            end
                        end
                        c = getSuperClass[c]
                        m = getObjectMeta[c]
                    end
                end
            else
                lwtk.errorf("invalid member name %q", var)
            end
        end
    end 
end

return Object
