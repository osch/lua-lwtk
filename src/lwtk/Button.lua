local lwtk = require"lwtk"

local getHotkeys        = lwtk.get.hotKeys
local getFocusHandler   = lwtk.get.focusHandler
local Super             = lwtk.Control
local Button            = lwtk.newClass("lwtk.Button", Super)


function Button:new(initParams)
    Super.new(self, initParams)
end

function Button:setHotkey(hotkey)
    if hotkey then
        local hotkeys
        if type(hotkey) == "string" then
            hotkeys = { [hotkey] = true }
        else
            hotkeys = {}
            for _, h in ipairs(hotkey) do
                hotkeys[h] = true
            end
        end
        getHotkeys[self] = hotkeys
        local focusHandler = getFocusHandler[self]
        if focusHandler and self.visible then
            focusHandler:registerHotkeys(self, hotkeys)
        end
    end
end

function Button:setVisible(shouldBeVisible)
    if shouldBeVisible ~= self.visible then
        if shouldBeVisible then
            local focusHandler = getFocusHandler[self]
            local hotkeys = getHotkeys[self]
            if focusHandler and hotkeys then
                focusHandler:registerHotkeys(self, hotkeys)
            end
        else
            local focusHandler = getFocusHandler[self]
            local hotkeys = getHotkeys[self]
            if focusHandler and hotkeys then
                focusHandler:deregisterHotkeys(self, hotkeys)
            end
        end
        Super.setVisible(self, shouldBeVisible)
    end
end

function Button:_handleHasFocusHandler(focusHandler)
    local hotkeys = getHotkeys[self]
    if hotkeys and self.visible then
        focusHandler:registerHotkeys(self, hotkeys)
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

function Button:onActionFocusedButtonClick()
    local onHotkeyDown = self.onHotkeyDown
    if onHotkeyDown then
        onHotkeyDown(self)
    end
end


return Button
