local luaType = type

local function type(arg)
    local t = luaType(arg)
    if t == "table" or t == "userdata" then
        local mt = getmetatable(arg)
        local mtt = luaType(mt)
        if mtt == "table" then
            local n = mt.__name
            if n then t = n end
        elseif mtt == "string" then
            t = mt
        end
    end
    return t
end

return type
