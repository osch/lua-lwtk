local lwtk = require"lwtk"

local upper    = string.upper
local lower    = string.lower
local sub      = string.sub
local format   = string.format
local match    = string.match

local newClass          = lwtk.newClass
local getWrapper        = lwtk.get.wrapper
local getWrappedChild   = lwtk.get.wrappedChild
local getWrappingParent = lwtk.get.wrappingParent
local getStylePath      = lwtk.get.stylePath

local function cloneClass(class, selectorFrag)
    local cloned = {}
    for k, v in pairs(class) do
        cloned[k] = v
    end
    cloned.__index = cloned
    local selector = getStylePath[class]
    if selector and selectorFrag then
        getStylePath[cloned] = selector.."<"..lower(selectorFrag)..">"
    end
    setmetatable(cloned, getmetatable(class))
    return cloned
end

local function shortName(className)
    return match(className, "^.*%.([^.]*)$") or className
end

local function newWrapperClass(className, WrappedChildClass, WrappingParentClass, parentAttributes, parentMethods)
    

    local shortWrapperName  = shortName(className)
    local shortWrappedName  = shortName(WrappedChildClass.__name)
    local selectorFrag      = format("%s(%s)", shortWrapperName, shortWrappedName)
    
    local WrapperClass = newClass(format("%s(%s)", className, tostring(WrappedChildClass)))

    WrappedChildClass   = cloneClass(WrappedChildClass, selectorFrag)
    WrappingParentClass = cloneClass(WrappingParentClass, selectorFrag)
    
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
        local setter = WrappingParentClass[setterName]
        local getter = WrappingParentClass[getterName]
        if setter then
            WrapperClass[setterName] = function(self, ...)
                return setter(getWrappingParent[self], ...)
            end
        end
        if getter then
            WrapperClass[getterName] = function(self, ...)
                return getter(getWrappingParent[self], ...)
            end
        end
    end
    for _, methodName in ipairs(parentMethods) do
        local method = WrappingParentClass[methodName]
        if method then
            WrapperClass[methodName] = function(self, ...)
                return method(getWrappingParent[self], ...)
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
        local wrappingParent = WrappingParentClass(parentParams)
        local wrappedChild  = WrappedChildClass(initParams)
        wrappingParent:addChild(wrappedChild)
        getWrappingParent[self]   = wrappingParent
        getWrappedChild[self]     = wrappedChild
        getWrapper[wrappedChild]  = self
    end

    function WrapperClass:getWrappingParent()
        return getWrappingParent[self]
    end
    function WrapperClass:getWrappedChild()
        return getWrappedChild[self]
    end

    return WrapperClass
end

function WidgetWrapper(className, WrappingParentClass)

    local wrappedClasses = {}

    local function wrap(WrappedChildClass)
        local c = wrappedClasses[WrappedChildClass]
        if not c then
            c = newWrapperClass(className,
                                WrappedChildClass, 
                                WrappingParentClass, 
                                { "frame" }, { "changeFrame", "setVisible", "isVisible" })
            wrappedClasses[WrappedChildClass] = c
        end
        return c
    end
    return wrap
end

return WidgetWrapper
