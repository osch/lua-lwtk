local lwtk = require"lwtk"

local Super  = lwtk.Control
local Button = lwtk.newClass("lwtk.Button", Super)

local getHotkeys = setmetatable({}, { __mode = "k" })

function Button:new(initParams)
    Super.new(self, initParams)
end

function Button:setHotkey(hotkey)
    if type(hotkey) == "string" then
        getHotkeys[self] = { [hotkey] = true }
    else
        local hotkeys = {}
        getHotkeys[self] = hotkeys
        for _, h in ipairs(hotkey) do
            hotkeys[h] = true
        end
    end
end

function Button:isHotkeyEnabled(hotkey)
    local hotkeys = getHotkeys[self]
    return hotkeys and hotkeys[hotkey]
end

function Button:onHotkeyEnabled(hotkey)
    local hotkeys = getHotkeys[self]
    if not hotkeys then
        hotkeys = { [hotkey] = true }
        getHotkeys[self] = hotkeys
        self:triggerRedraw()
    elseif not hotkeys[hotkey] then
        hotkeys[hotkey] = true
        self:triggerRedraw()
    end
end

function Button:onHotkeyDisabled(hotkey)
    local hotkeys = getHotkeys[self]
    if hotkeys and hotkeys[hotkey] then
        hotkeys[hotkey] = false
        self:triggerRedraw()
    end
end


return Button
