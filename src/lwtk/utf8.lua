local tryrequire = require("lwtk.tryrequire")

local luautf8 = tryrequire("lua-utf8") -- https://luarocks.org/modules/xavier-wang/luautf8
                                       -- https://github.com/starwing/luautf8

local builtin_utf8 = utf8 or tryrequire("utf8")

if builtin_utf8 and not luautf8 then
    -- utf8string copied from https://love2d.org/forums/viewtopic.php?p=232176
    luautf8 = require("lwtk.internal.utf8string")
end

if not luautf8 then
    -- fail with error
    luautf8 = require("lua-utf8")
end

if not builtin_utf8 then
    local lua_version = _VERSION:match("[%d%.]*$")
    
    if #lua_version == 3 and lua_version < "5.3" then
        builtin_utf8 = require("compat53.utf8")
        if lua_version == "5.1" then
            builtin_utf8.charpattern = "[%z\1-\127\194-\244][\128-\191]*"
        end
    end
end

local utf8 = {}

for k, v in pairs(luautf8) do
    utf8[k] = v
end

for k, v in pairs(builtin_utf8) do
    utf8[k] = v
end

return utf8