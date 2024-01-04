local lwtk = require"lwtk"

local getChildLookup = lwtk.get.childLookup

local ChildLookup = lwtk.newMeta("lwtk.ChildLookup")

ChildLookup.__mode = "v"

function ChildLookup:new(group)
    self[0]  = false
    self[-1] = group
end

function ChildLookup:__index(id)
    assert(type(id) == "string", "id must be string")
    local group = rawget(self, -1)
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
        self[0] = true
        self[id] = found
    end
    return found
end

function ChildLookup.clear(self)
    if self and self[0] then
        for k,v in pairs(self) do
            if type(k) == "string" then
                self[k] = nil
            end
        end
        self[0] = false
    end
end


return ChildLookup
