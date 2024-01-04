local lwtk     = require("lwtk")

local unpack         = table.unpack or unpack
local format         = string.format
local ltype          = lwtk.type
local getSuperClass  = lwtk.get.superClass
local getObjectMeta  = lwtk.get.objectMeta
local getMixinBase   = lwtk.get.mixinBase

local caches     = lwtk.WeakKeysTable("lwtk.newMixin.caches")
local mixins     = lwtk.WeakKeysTable("lwtk.newMixin.mixins")

local Mixin = lwtk.Mixin

local cacheMeta = {
    __mode = "v"
}

--[[
    Creates new mixin object. A mixin object has lwtk.Mixin as metatable
    and lwtk.type() evaluates to `"lwtk.Mixin"`.
    
    See [lwtk.Mixin Usage](../../Mixin.md) for detailed documentation
    and usage examples.
]]
local function newMixin(name, ...)
    assert(ltype(name) == "string", "arg 1 must be string")
    local mixin = { name = name }
    local nargs = select("#", ...)
    for i = 1, nargs do
        local arg = select(i, ...)
        if ltype(arg) ~= "lwtk.Mixin" then
            break
        end
        mixin[i] = arg
    end
    mixin.cargs = { nargs = nargs - #mixin, 
                    select(#mixin + 1, ...) }
    local m = setmetatable({}, Mixin)
    m.__name = name
    mixins[m] = mixin
    caches[m] = setmetatable({}, cacheMeta)
    return m
end

local method = {}

function method:isInstanceOf(mt)
    return lwtk.isInstanceOf(self, mt)
end

function method:declare(...)
    local m = mixins[self].declare
    if not m then   
        m = {}
        mixins[self].declare = m
    end
    local n = #m
    for i = 1, select("#", ...) do
        m[n + i] = select(i, ...)
    end
end

function Mixin:__index(k)
    local v = method[k]
    if v ~= nil then
        return v
    elseif k == "extra" or k == "override" or k == "implement" then
        v = {}
        self[k] = v
        return v
    else
        v = self.override[k]
        if v == nil then
            v = self.implement[k]
        end
        return v
    end
end

function Mixin:__tostring()
    return "lwtk.Mixin<"..mixins[self].name..">"
end

function Mixin:__call(baseClass, ...)
    if baseClass ~= nil then
        assert(ltype(baseClass) == "lwtk.Class", "arg must be of type lwtk.Class, but is "..ltype(baseClass))
    else
        baseClass = lwtk.Object
    end
    local mixin = mixins[self]
    for i = #mixin, 1, -1 do
        baseClass = mixin[i](baseClass)
    end
    local cache = caches[self]
    local class = cache[baseClass]
    if not class then
        do
            local s = baseClass
            while s do
                if getMixinBase[s] == self then
                    lwtk.errorf("Mixin %q is already involved in superclass %q", mixin.name, baseClass:getClassPath()) 
                end
                s = getSuperClass[s]
            end
        end
        local cargs = mixin.cargs
        local nargs = cargs.nargs
        local lastArg = (nargs > 0) and cargs[nargs]
        local initClass 
        if lastArg and ltype(lastArg) == "function" then
            nargs = nargs - 1
            initClass = lastArg
        end
        local baseName = (baseClass == lwtk.Object) and "" or baseClass.__name
        class = baseClass:newSubClass(format("%s(%s)", mixin.name, baseName), unpack(cargs, 1, nargs))
        local declare = mixin.declare
        if declare then
            for i = 1, #declare do
                local var = declare[i]
                if var:match("^[a-zA-Z_][a-zA-Z_0-9]*$") then
                    local objMeta = getObjectMeta[class]
                    if objMeta[var] == nil then
                        class[var] = false
                    else
                        local c = class
                        local m = objMeta
                        while true do
                            if m.declared[var] then
                                lwtk.errorf("member %q from mixin %q is already declared in superclass %q in class path %s", var, mixin.name, m.__name, class:getClassPath())
                            end
                            c = getSuperClass[c]
                            m = getObjectMeta[c]
                        end
                    end
                else
                    lwtk.errorf("invalid member name %q in Mixin %s", var, mixin.name)
                end
            end
        end
        for k, v in pairs(self) do
            if k ~= "extra" and k ~= "override" and k ~= "implement" and k ~= "__name" then
                class[k] = v
            end
        end
        local myOverride = self.override
        if myOverride then
            local classOverride = class.override
            for k, v in pairs(myOverride) do
                classOverride[k] = v
            end
        end
        local myImplement = self.implement
        if myImplement then
            local classImplement = class.implement
            for k, v in pairs(myImplement) do
                classImplement[k] = v
            end
        end
        if initClass then
            initClass(class, baseClass)
        end
        getMixinBase[class] = self
        cache[baseClass] = class
    end
    return class
end

return newMixin
