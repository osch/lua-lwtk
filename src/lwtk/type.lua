local luaType = type

--[[
    Returns the type name.
    
     * If *arg* is of type *"table"* or *"userdata"* and has a metatable of 
       type *"table"* with a field *"__name"*, than the value of this field 
       is returned.
    
     * If *arg* is of type *"table"* or *"userdata"* and has a metatable of 
       type *"string"*, than this string value is returned.
       
     * In all other cases this functions returns the same value, as the
       builtin Lua function *type()* would return.
]]
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
