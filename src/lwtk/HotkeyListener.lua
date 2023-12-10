local lwtk = require("lwtk")

local getFocusHandler   = lwtk.get.focusHandler
local getHotkeys        = lwtk.WeakKeysTable()
local registeredHotkeys = lwtk.WeakKeysTable()

local processHotKeyRegistration

local HotkeyListener = lwtk.newMixin("lwtk.HotkeyListener", lwtk.Styleable.NO_STYLE_SELECTOR,

    function(HotkeyListener, Super)

        local Super_onEffectiveVisibilityChanged = Super.onEffectiveVisibilityChanged
        
        function HotkeyListener.implement:onEffectiveVisibilityChanged(hidden)
            if Super_onEffectiveVisibilityChanged then
                Super_onEffectiveVisibilityChanged(self, hidden)
            end
            processHotKeyRegistration(self, not hidden)
        end
    
        function HotkeyListener.implement:_handleHasFocusHandler(focusHandler)
            local superCall = Super._handleHasFocusHandler
            if superCall then
                superCall(self, focusHandler)
            end
            local hotkeys = getHotkeys[self]
            if hotkeys and not self._hidden then
                focusHandler:registerHotkeys(self, hotkeys)
                registeredHotkeys[self] = hotkeys
            end
        end
        
        local Super_onDisabled = Super.onDisabled
    
        function HotkeyListener.implement:onDisabled(disableFlag)
            processHotKeyRegistration(self, not disableFlag)
            if Super_onDisabled then
                Super_onDisabled(self, disableFlag)
            end
        end
        
    end
)

function processHotKeyRegistration(self, registrateFlag)
    if registrateFlag then
        if not registeredHotkeys[self] then
            local focusHandler = getFocusHandler[self]
            local hotkeys = getHotkeys[self]
            if focusHandler and hotkeys then
                focusHandler:registerHotkeys(self, hotkeys)
                registeredHotkeys[self] = hotkeys
            end
        end
    else
        if registeredHotkeys[self] then
            local focusHandler = getFocusHandler[self]
            local hotkeys = getHotkeys[self]
            if focusHandler and hotkeys then
                focusHandler:deregisterHotkeys(self, hotkeys)
                registeredHotkeys[self] = nil
            end
        end
    end
end

function HotkeyListener:setHotkey(hotkey)
    if hotkey then
        local registered = registeredHotkeys[self]
        if not registered or registered[hotkey] == nil then
            local focusHandler = getFocusHandler[self]
            if registered then
                focusHandler:deregisterHotkeys(self, registered)
                registeredHotkeys[self] = nil
            end
            local hotkeys
            if type(hotkey) == "string" then
                hotkeys = { [hotkey] = false }
            else
                hotkeys = {}
                for _, h in ipairs(hotkey) do
                    hotkeys[h] = false
                end
            end
            getHotkeys[self] = hotkeys
            if focusHandler and not self._hidden then
                focusHandler:registerHotkeys(self, hotkeys)
                registeredHotkeys[self] = hotkeys
            end
        end
    else
        local registered = registeredHotkeys[self]
        if registered then
            getFocusHandler[self]:deregisterHotkeys(self, registered)
            registeredHotkeys[self] = nil
        end
        getHotkeys[self] = nil
    end
end


function HotkeyListener:isHotkeyEnabled(hotkey)
    local hotkeys = getHotkeys[self]
    return hotkeys and hotkeys[hotkey]
end

function HotkeyListener.implement:onHotkeyEnabled(hotkey)
    local hotkeys = getHotkeys[self]
    if not hotkeys[hotkey] then
        hotkeys[hotkey] = true
        self:triggerRedraw()
    end
end

function HotkeyListener:onHotkeyDisabled(hotkey)
    local hotkeys = getHotkeys[self]
    if hotkeys[hotkey] then
        hotkeys[hotkey] = false
        self:triggerRedraw()
    end
end

return HotkeyListener
