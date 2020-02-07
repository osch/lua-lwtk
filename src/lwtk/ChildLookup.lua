local lwtk = require"lwtk"

local Class      = lwtk.Class
local getWrapper = lwtk.get.wrapper

local ChildLookup = {}
ChildLookup.__name = "lwtk.ChildLookup"
setmetatable(ChildLookup, Class)

function ChildLookup:new(group)
    self[0] = false
    self[-1] = group
end

function ChildLookup.__index(self, id)
    assert(type(id) == "string", "id must be string")
    local group = self[-1]
    local found = nil
    if group then
        for i = 1, #group do
            local c = group[i]
            if c.id == id then
                assert(not found, "ambiguous id='"..id.."'")
                found = c
            end
            if c.child then
                local c2 = c.child[id]
                if c2 then
                    assert(not found, "ambiguous id='"..id.."'")
                    found = c2
                end
            end
        end
    end
    if found ~= nil then
        found = getWrapper[found] or found
        self[0] = true
        self[id] = found
    end
    return found
end


return ChildLookup
