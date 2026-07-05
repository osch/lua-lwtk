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
    -- Lua < 5.3: luautf8 also provides all functions of the builtin
    -- Lua 5.3 utf8 library, including a Lua 5.1 compatible charpattern
    builtin_utf8 = luautf8
end

local utf8 = {}

for k, v in pairs(luautf8) do
    utf8[k] = v
end

for k, v in pairs(builtin_utf8) do
    utf8[k] = v
end

utf8.version = nil -- luautf8's own version field is not part of this API

return utf8