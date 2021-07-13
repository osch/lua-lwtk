local lwtk = require("lwtk")

local getHotkeys        = lwtk.get.hotKeys
local getFocusHandler   = lwtk.get.focusHandler

local HotkeyListener    = lwtk.newMixin("lwtk.HotkeyListener", lwtk.Styleable.NO_STYLE_SELECTOR)

local processHotKeyRegistration

function HotkeyListener.initClass(HotkeyListener, Super)  -- luacheck: ignore 431/HotkeyListener

    local Super_onEffectiveVisibilityChanged = Super.onEffectiveVisibilityChanged
    
    function HotkeyListener:onEffectiveVisibilityChanged(hidden)
        if Super_onEffectiveVisibilityChanged then
            Super_onEffectiveVisibilityChanged(self, hidden)
        end
        processHotKeyRegistration(self, not hidden)
    end

    function HotkeyListener:_handleHasFocusHandler(focusHandler)
        local superCall = Super._handleHasFocusHandler
        if superCall then
            superCall(self, focusHandler)
        end
        local hotkeys = getHotkeys[self]
        if hotkeys and not self._hidden then
            focusHandler:registerHotkeys(self, hotkeys)
        end
    end
    
    local Super_onDisabled = Super.onDisabled

    function HotkeyListener:onDisabled(disableFlag)
        processHotKeyRegistration(self, not disableFlag)
        if Super_onDisabled then
            Super_onDisabled(self, disableFlag)
        end
    end
    
end

function processHotKeyRegistration(self, registrateFlag)
    if registrateFlag then
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
end

function HotkeyListener:setHotkey(hotkey)
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
        if focusHandler and not self._hidden then
            focusHandler:registerHotkeys(self, hotkeys)
        end
    else
        local hotkeys = getHotkeys[self]
        getHotkeys[self] = nil
        local focusHandler = getFocusHandler[self]
        if hotkeys and focusHandler then
            focusHandler:deregisterHotkeys(self, hotkeys)
        end
    end
end


function HotkeyListener:isHotkeyEnabled(hotkey)
    local hotkeys = getHotkeys[self]
    return hotkeys and hotkeys[hotkey]
end

function HotkeyListener:onHotkeyEnabled(hotkey)
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

function HotkeyListener:onHotkeyDisabled(hotkey)
    local hotkeys = getHotkeys[self]
    if hotkeys and hotkeys[hotkey] then
        hotkeys[hotkey] = false
        self:triggerRedraw()
    end
end

return HotkeyListener
