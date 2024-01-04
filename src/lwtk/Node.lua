local lwtk = require"lwtk"

local WeakKeysTable = lwtk.WeakKeysTable
local getParent     = lwtk.get.parent

local Node = lwtk.newMixin("lwtk.Node")

Node:declare(
    "_processMouseEnter",
    "onMouseEnter",
    "_processMouseLeave",
    "onMouseLeave",
    "_processMouseMove",
    "onMouseMove",
    "_processMouseScroll",
    "onMouseScroll",
    "_processMouseDown",
    "onMouseDown",
    "_processMouseUp",
    "onMouseUp",
    "onInputChanged",

    "addChild",
    "removeChild",
    "discardChild"
)

--[[
    Discard Node that should no longer be used.
    
    This function could be useful under Lua 5.1 which does not have ephemeron tables.
]]
function Node:discard()
    local parent = getParent[self]
    if parent then
        local removeChild = parent.removeChild
        if removeChild then
            removeChild(parent, self)
        else
            getParent[self] = nil
        end
    end
    WeakKeysTable.discard(self)
    for i = #self, 1, -1 do 
        rawget(self, i):discard()
    end
end

return Node
