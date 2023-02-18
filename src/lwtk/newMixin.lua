local lwtk     = require("lwtk")
local type     = lwtk.type

local caches = lwtk.WeakKeysTable()
local mixins = lwtk.WeakKeysTable()
local unpack = table.unpack or unpack

local Mixin = lwtk.Mixin

local function newMixin(name, ...)
    assert(type(name) == "string", "arg 1 must be string")
    local mixin = { name = name }
    local nargs = select("#", ...)
    for i = 1, nargs do
        local arg = select(i, ...)
        if type(arg) ~= "lwtk.Mixin" then
            break
        end
        mixin[i] = arg
    end
    mixin.cargs = { nargs = nargs - #mixin, 
                    select(#mixin + 1, ...) }
    local self = setmetatable({}, Mixin)
    mixins[self] = mixin
    caches[self] = setmetatable({}, { __mode = "v" })
    return self
end

function Mixin.__index:isInstanceOf(mt)
    return lwtk.isInstanceOf(self, mt)
end

function Mixin:__tostring()
    return "lwtk.Mixin("..mixins[self].name..")"
end

function Mixin:__call(baseClass, ...)
    assert(type(baseClass) == "lwtk.Class", "arg must be of type lwtk.Class, but is "..type(baseClass))
    local cache = caches[self]
    local class = cache[baseClass]
    if not class then
        local mixin = mixins[self]
        for i = #mixin, 1, -1 do
            baseClass = mixin[i](baseClass)
        end
        local cargs = mixin.cargs
        class = baseClass.newSubClass(mixin.name, baseClass, unpack(cargs, 1, cargs.nargs))
        for k, v in pairs(self) do
            if k ~= "initClass" and k ~= "extra" then
                class[k] = v
            end
        end
        local initClass = self.initClass
        if initClass then
            initClass(class, baseClass)
        end
        cache[baseClass] = class
    end
    return class
end

return newMixin
