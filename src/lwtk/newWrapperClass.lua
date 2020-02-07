local lwtk = require"lwtk"

local upper    = string.upper
local sub      = string.sub
local format   = string.format

local newClass         = lwtk.newClass
local getWrapper       = lwtk.get.wrapper
local getWrappedChild  = lwtk.get.wrappedChild
local getWrappedParent = lwtk.get.wrappedParent

local function newWrapperClass(className, WrappedChildClass, WrappedParentClass, parentAttributes)
    
    local WrapperClass = newClass(className)
    
    for k, v in pairs(WrappedChildClass) do
        if type(v) == "function" then
            WrapperClass[k] = function(self, ...)
                return v(getWrappedChild[self], ...)
            end
        end
    end

    for _, a in ipairs(parentAttributes) do
        local setterName = "set"..upper(sub(a, 1, 1))..sub(a, 2)
        local getterName = "get"..upper(sub(a, 1, 1))..sub(a, 2)
        local setter = WrappedParentClass[setterName]
        local getter = WrappedParentClass[getterName]
        if setter then
            WrapperClass[setterName] = function(self, ...)
                return setter(getWrappedParent[self], ...)
            end
        end
        if getter then
            WrapperClass[getterName] = function(self, ...)
                return getter(getWrappedParent[self], ...)
            end
        end
    end

    function WrapperClass:new(initParams)
        local parentParams
        if initParams then
            self.id = initParams.id
            parentParams = {}
            for _, a in ipairs(parentAttributes) do
                local p = initParams[a]
                if p then
                    parentParams[a] = p
                    initParams[a] = nil
                end
            end
        end
        local wrappedParent = WrappedParentClass(parentParams)
        local wrappedChild  = WrappedChildClass(initParams)
        wrappedParent:addChild(wrappedChild)
        getWrappedParent[self]   = wrappedParent
        getWrappedChild[self]    = wrappedChild
        getWrapper[wrappedChild] = self
    end

    function WrapperClass:getWrappedParent()
        return getWrappedParent[self]
    end
    function WrapperClass:getWrappedChild()
        return getWrappedChild[self]
    end

    return WrapperClass
end

return newWrapperClass
