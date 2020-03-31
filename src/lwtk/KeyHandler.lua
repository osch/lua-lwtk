local lpugl = require"lpugl"
local lwtk  = require"lwtk"

local match           = string.match
local btest           = lpugl.btest
local MOD_SHIFT       = lpugl.MOD_SHIFT
local MOD_CTRL        = lpugl.MOD_CTRL
local MOD_ALT         = lpugl.MOD_ALT
local MOD_SUPER       = lpugl.MOD_SUPER
local utf8            = lwtk.utf8
local len             = utf8.len
local getKeyBinding   = lwtk.get.keyBinding
local getFocusHandler = lwtk.get.focusHandler

local KeyHandler = lwtk.newClass("lwtk.KeyHandler")

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

function KeyHandler:new()
    getState[self] = { current = false, mod = false }
end

function KeyHandler:resetKeyHandling()
    print("resetKeyHandling")
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
                if isMod ~= "Ctrl" and btest(modifier, MOD_CTRL) then
                    modString = "Ctrl+"..modString
                end
                if isMod ~= "Shift" and btest(modifier, MOD_SHIFT) then
                    modString = "Shift+"..modString
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


function KeyHandler:_handleKeyDown(key, modifier, ...)
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
            if state.current then
                modifier = 0
            end
            key = toModKeyString(key, modifier)

            print("_handleKeyDown", key, modifier, ...)
            for i = #self, 1, -1 do
                local child = self[i]
                if child.visible then
                    local keyBinding = getKeyBinding[self]
                    local actions    = (state.current or keyBinding)[key]
                    local focusHandler = getFocusHandler[child]
                    if actions then 
                        local handled
                        for i = #actions, 1, -1 do
                            local action = actions[i]
                            handled = focusHandler:invokeActionMethod(action)
                            if handled then
                                state.current = false
                                break
                            end
                        end
                        if not handled then
                            if actions[0] then
                                state.current = actions
                                print("Step:", actions[-1])
                            else
                                state.current = false
                            end
                        end
                    else
                        state.current = false
                    end
                    break
                end
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
            print("_handleKeyUp", key)
            local keyBinding = getKeyBinding[self]
            local actions = keyBinding[key]                    
            if actions then
                for i = #self, 1, -1 do
                    local child = self[i]
                    if child.visible then
                        local focusHandler = getFocusHandler[child]
                        for i = #actions, 1, -1 do
                            local action = actions[i]
                            local handled = focusHandler:invokeActionMethod(action)
                            if handled then
                                break
                            end
                        end
                        break
                    end
                end
            end
        end
    end

end

return KeyHandler

