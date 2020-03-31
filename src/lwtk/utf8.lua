local luautf8 = require"lua-utf8" -- https://luarocks.org/modules/xavier-wang/luautf8
                                  -- https://github.com/starwing/luautf8
local builtin_utf8 = utf8

local utf8 = {}

for k, v in pairs(luautf8) do
    utf8[k] = v
end

local lua_version = _VERSION:match("[%d%.]*$")

if #lua_version == 3 and lua_version < "5.3" then
    builtin_utf8 = require("compat53.utf8")
    if lua_version == "5.1" then
        builtin_utf8.charpattern = "[%z\1-\127\194-\244][\128-\191]*"
    end
end

for k, v in pairs(builtin_utf8) do
    utf8[k] = v
end

return utf8