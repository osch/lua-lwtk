local lwtk = require"lwtk"

local format          = string.format
local newClass        = lwtk.newClass
local newWrapperClass = lwtk.newWrapperClass


function WidgetWrapper(className, WrappedParentClass)

    local wrappedClasses = {}

    local function wrap(WrappedChildClass)
        local c = wrappedClasses[WrappedChildClass]
        if not c then
            c = newWrapperClass(format("%s(%s)", className, WrappedChildClass),
                                WrappedChildClass, 
                                WrappedParentClass, 
                                { "frame" })
            wrappedClasses[WrappedChildClass] = c
        end
        return c
    end
    return wrap
end

return WidgetWrapper
