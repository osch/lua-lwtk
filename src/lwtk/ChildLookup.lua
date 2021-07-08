local lwtk = require"lwtk"

local getWrapper     = lwtk.get.wrapper
local getChildLookup = lwtk.get.childLookup

local ChildLookup = lwtk.newClass("lwtk.ChildLookup")

ChildLookup.__mode = "v"

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
            local ccLookup = getChildLookup[c]
            if ccLookup then
                local c2 = ccLookup[id]
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

function ChildLookup.clear(self)
    if self[0] then
        for k,v in pairs(self) do
            if type(k) == "string" then
                self[k] = nil
            end
        end
    end
end


return ChildLookup
