local lwtk = require"lwtk"

local HotkeyHandler = lwtk.newClass("lwtk.HotkeyHandler")

local getRegistry = setmetatable({}, { __mode = "k" })

function HotkeyHandler:new()
    getRegistry[self] = {}
end

return HotkeyHandler
