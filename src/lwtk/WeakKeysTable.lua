local lwtk = require("lwtk")

local format        = string.format
local getHashString = lwtk.util.getHashString

local WeakKeysTable = lwtk.newMeta("lwtk.WeakKeysTable")

WeakKeysTable.__mode = "k"

WeakKeysTable.tableNames = setmetatable({}, { __mode = "k" })

local tableNames = WeakKeysTable.tableNames

function WeakKeysTable:new(name)
    tableNames[self] = name or false
end

function WeakKeysTable:__tostring()
    local n = tableNames[self]
    if n then
        return format("lwtk.WeakKeysTable(%q): %s", n, getHashString(self))
    else
        return format("lwtk.WeakKeysTable: %s", getHashString(self))
    end
end

function WeakKeysTable.discard(key)
    for t, _ in pairs(tableNames) do
        t[key] = nil
    end
end

return WeakKeysTable
