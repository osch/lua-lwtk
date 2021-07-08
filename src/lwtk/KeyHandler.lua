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



local function toModKeyString(key, modifier)
    local cache = caches[modifier]
    if not cache then cache = {}; caches[modifier] = cache; end
    local mapped = cache[key]
    if not mapped then
        if modifier ~= 0 then
            local isMod = isModifier[key]
            local modString = not isMod and modMap[modifier]
            if not modString then
                modString = ""
                if isMod ~= "Super" and btest(modifier, MOD_SUPER) then
                    modString = "Super+"..modString
                end
                if isMod ~= "Alt" and btest(modifier, MOD_ALT) then
                    modString = "Alt+"..modString
                end
                if isMod ~= "Alt" and btest(modifier, MOD_ALTGR) then
                    modString = "AltGr+"..modString
                end
                if isMod ~= "Ctrl" and btest(modifier, MOD_CTRL) then
                    modString = "Ctrl+"..modString
                end
                if isMod ~= "Shift" and btest(modifier, MOD_SHIFT) then
                    modString = "Shift+"..modString
                end
                if not isMod and modifier ~= 0 and #modString == 0 then
                    modString = "???+"
                end
                if not isMod then
                    modMap[modifier] = modString
                end
            end
            mapped = modString..key
        else
            mapped = key
        end
        cache[key] = mapped
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

function KeyHandler:_handleKeyDown(key, modifier, ...)
    --print("KeyHandler:_handleKeyDown", key, modifier, ...)
    local state = getState[self]
    if key then
        if len(key) == 1 then
            local mapped = keyMap[key]
            if not mapped then
                mapped = utf8.upper(key)
                keyMap[key] = mapped
            end
            key = mapped
        end
        if isModifier[key] then
            state.mod = key
        else
            state.mod = false
            local current = state.current
            if current then
                modifier = 0
            end
            local child = getVisibleChild(self)
            if child then
                local focusHandler = getFocusHandler[child]
                local handled = not current and focusHandler:handleHotkey(key, modifier, ...)
                if not handled then
                    local modAndKey = toModKeyString(key, modifier)
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
                            handled = focusHandler:onKeyDown(key, modifier, ...)
                        end
                    end
                end
                return handled
            end
        end
    end
end

function KeyHandler:_handleKeyUp(key, modifier, ...)
    if isModifier[key] then
        local state = getState[self]
        if state.mod == key then
            state.mod = false
            key = toModKeyString(key, modifier)
            local keyBinding = getKeyBinding[self]
            local actions = keyBinding[key]                    
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
