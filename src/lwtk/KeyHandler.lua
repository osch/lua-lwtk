local lpugl = require"lpugl"
local lwtk  = require"lwtk"

local btest           = lpugl.btest
local MOD_SHIFT       = lpugl.MOD_SHIFT
local MOD_CTRL        = lpugl.MOD_CTRL
local MOD_ALT         = lpugl.MOD_ALT
local MOD_ALTGR       = lpugl.MOD_ALTGR
local MOD_SUPER       = lpugl.MOD_SUPER
local utf8            = lwtk.utf8
local len             = utf8.len
local getKeyBinding   = lwtk.get.keyBinding
local getFocusHandler = lwtk.get.focusHandler

local KeyHandler = lwtk.newMixin("lwtk.KeyHandler")

local modMap = {}
local caches = {}
local keyMap = {}

local isModifier = {
    Shift_L = "Shift",
    Shift_R = "Shift",
    
    Ctrl_L = "Ctrl",
    Ctrl_R = "Ctrl",
    
    Alt_L  = "Alt",
    Alt_R  = "Alt",
    
    Super_L = "Super",
    Super_R = "Super"
}

local getState = setmetatable({}, { __mode = "k" })

function KeyHandler.initClass(KeyHandler, Super)  -- luacheck: ignore 431/KeyHandler

    function KeyHandler:new(...)
        Super.new(self, ...)
        getState[self] = { current = false, mod = false }
    end

end

function KeyHandler:resetKeyHandling()
    local state = getState[self]
    state.current = false
    state.mod     = false
end



local function toModKeyString(keyName, keyState)
    local cache = caches[keyState]
    if not cache then cache = {}; caches[keyState] = cache; end
    local mapped = cache[keyName]
    if not mapped then
        if keyState ~= 0 then
            local isMod = isModifier[keyName]
            local modString = not isMod and modMap[keyState]
            if not modString then
                modString = ""
                if isMod ~= "Super" and btest(keyState, MOD_SUPER) then
                    modString = "Super+"..modString
                end
                if isMod ~= "Alt" and btest(keyState, MOD_ALT) then
                    modString = "Alt+"..modString
                end
                if isMod ~= "Alt" and btest(keyState, MOD_ALTGR) then
                    modString = "AltGr+"..modString
                end
                if isMod ~= "Ctrl" and btest(keyState, MOD_CTRL) then
                    modString = "Ctrl+"..modString
                end
                if isMod ~= "Shift" and btest(keyState, MOD_SHIFT) then
                    modString = "Shift+"..modString
                end
                if not isMod and keyState ~= 0 and #modString == 0 then
                    modString = "???+"
                end
                if not isMod then
                    modMap[keyState] = modString
                end
            end
            mapped = modString..keyName
        else
            mapped = keyName
        end
        cache[keyName] = mapped
    end
    return mapped
end

local function getVisibleChild(self)
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            return child
        end
    end
end

local function invokeActionMethods(self, actions)
    if actions then
        local invokeActionMethod = self.invokeActionMethod
        if invokeActionMethod then
            for i = #actions, 1, -1 do
                local action = actions[i]
                local handled = invokeActionMethod(self, action)
                if handled then
                    return true
                end
            end
        end
    end
end

function KeyHandler:_handleKeyDown(keyName, keyState, keyText)
    --print("KeyHandler:_handleKeyDown", keyName, keyState, keyText)
    local interceptKeyDown = self.interceptKeyDown
    if interceptKeyDown then
        keyName, keyState, keyText = interceptKeyDown(self, keyName, keyState, keyText)
    end
    local state = getState[self]
    if keyName then
        if len(keyName) == 1 then
            local mapped = keyMap[keyName]
            if not mapped then
                mapped = utf8.upper(keyName)
                keyMap[keyName] = mapped
            end
            keyName = mapped
        end
        if isModifier[keyName] then
            state.mod = keyName
        else
            state.mod = false
            local current = state.current
            if current then
                keyState = 0
            end
            local child = getVisibleChild(self)
            if child then
                local focusHandler = getFocusHandler[child]
                local handled = not current and focusHandler:handleHotkey(keyName, keyState, keyText)
                if not handled then
                    local modAndKey = toModKeyString(keyName, keyState)
                    local keyBinding = getKeyBinding[self]
                    local actions    = (current or keyBinding)[modAndKey]
                    handled = invokeActionMethods(focusHandler, actions)
                    if handled then
                        state.current = false
                    else
                        if actions and actions[0] then
                            state.current = actions
                        elseif state.current then
                            state.current = false
                        else
                            handled = focusHandler:onKeyDown(keyName, keyState, keyText)
                        end
                    end
                end
                return handled
            end
        end
    end
end

function KeyHandler:_handleKeyUp(keyName, keyState, keyText)
    if isModifier[keyName] then
        local state = getState[self]
        if state.mod == keyName then
            state.mod = false
            keyName = toModKeyString(keyName, keyState)
            local keyBinding = getKeyBinding[self]
            local actions = keyBinding[keyName]                    
            if actions then
                local child = getVisibleChild(self)
                if child then
                    local focusHandler = getFocusHandler[child]
                    for i = #actions, 1, -1 do
                        local action = actions[i]
                        local handled = focusHandler:invokeActionMethod(action)
                        if handled then
                            break
                        end
                    end
                end
            end
        end
    end

end

return KeyHandler
