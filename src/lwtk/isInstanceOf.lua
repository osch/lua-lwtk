local lwtk = require"lwtk"

local getSuperClass = lwtk.get.superClass

--[[
    Determines if object is instance of the given class.

    Returns *true*, if *self* is an object that was created by invoking class *C*
    or by invoking a subclass of *C*.
    
    Returns also *true* if *C* is a metatable of *self* or somewhere in the 
    metatable chain of *self*.
]]
local function isInstanceOf(self, C)
    local c = getmetatable(self)
    if c then
        repeat
            if c == C then
                return true
            end
            c = getSuperClass[c]
        until not c
    end
    return false
end

return isInstanceOf
