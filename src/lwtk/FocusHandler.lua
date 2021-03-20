local lpugl = require"lpugl"
local lwtk   = require"lwtk"

local abs                  = math.abs
local btest                = lpugl.btest
local MOD_ALT              = lpugl.MOD_ALT
local getFocusableChildren = lwtk.get.focusableChildren
local getActions           = lwtk.get.actions
local getHotkeys           = lwtk.get.hotKeys

local getFocusedChild      = lwtk.WeakKeysTable()

local Super        = lwtk.Actionable
local FocusHandler = lwtk.newClass("lwtk.FocusHandler", Super)

function FocusHandler:new(baseWidget)
    Super.new(self)
    self.baseWidget = baseWidget
    getFocusableChildren[self] = {}
end



local function dist(x1, w1, x2, w2)
    local c1 = x1 + w1/2
    if x2 >= c1 then
        return x2 - c1
    elseif x2 + w2 <= c1 then
        return c1 - (x2 + w2)
    else
        return 0
    end
end

local function findNextFocusableChild1(self, direction)
    local cx, cy, cw, ch = 0, 0, 0, 0
    local focusedChild = getFocusedChild[self]
    local baseWidget = self.baseWidget
    if focusedChild then
        cx, cy = focusedChild:transformXY(0, 0, baseWidget)
        cw, ch = focusedChild.w, focusedChild.h
    end
    local focusableChildren = getFocusableChildren[self]
    local found
    do
        local fx, fy, fw, fh
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if child.visible and child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, baseWidget)
                local nw, nh = child.w, child.h
                if direction == "right" then
                    if ny + nh > cy  and ny < cy + ch then
                        if nx >= cx and (not found or  nx - cx <  fx - cx 
                                                   or (nx - cx == fx - cx and dist(cy, ch, ny, nh) < dist(cy, ch, fy, fh)))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "left" then
                    if ny + nh >= cy  and ny < cy + ch then
                        if nx < cx and (not found or  cx - nx <  cx - fx
                                                  or (cx - nx == cx - fx and dist(cy, ch, ny, nh) < dist(cy, ch, fy, fh)))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "up" then
                    if nx + nw >= cx  and nx < cx + cw then
                        if ny < cy and (not found or  cy - ny  < cy - fy
                                                  or (cy - ny == cy - fy and dist(cx, cw, nx, nw) < dist(cx, cw, fx, fw)))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "down" then
                    if nx + nw > cx  and nx < cx + cw then
                        if ny >= cy and (not found or  ny - cy <  fy - cy
                                                  or (ny - cy == fy - cy and dist(cx, cw, nx, nw) < dist(cx, cw, fx, fw)))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                end
            end
        end
    end
    if not found and (direction == "up" or direction == "down") then
        local fx, fy, fw, fh
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if child.visible and child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, baseWidget)
                local nw, nh = child.w, child.h
                if direction == "up" then
                    if ny < cy and (not found or dist(cx, cw, nx, nw) < dist(cx, cw, fx, fw)) then
                        found, fx, fy, fw, fh = child, nx, ny, nw, nh
                    end
                elseif direction == "down" then
                    if ny >= cy + ch and (not found or dist(cx, cw, nx, nw) < dist(cx, cw, fx, fw)) then
                        found, fx, fy, fw, fh = child, nx, ny, nw, nh
                    end
                end
            end
        end
    end
    return found
end

local function findNextFocusableChild2(self, direction)
    local isForw = (direction == "next")
    local cx, cy = 0, 0
    local focusedChild = getFocusedChild[self]
    local baseWidget = self.baseWidget
    if focusedChild then
        cx, cy = focusedChild:transformXY(0, 0, baseWidget)
    end
    local focusableChildren = getFocusableChildren[self]
    local found
    for try = 1, 2 do
        local fx, fy
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if child.visible and child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, baseWidget)
                if isForw then
                    if nx > cx and ny >= cy and (not found or ny < fy or (ny == fy and nx < fx)) then
                        found = child
                        fx, fy = nx, ny
                    end
                else
                    if nx < cx and ny <= cy and (not found or ny > fy or (ny == fy and nx > fx)) then
                        found = child
                        fx, fy = nx, ny
                    end
                end
            end
        end
        if found then
            break
        elseif try == 1 then
            if isForw then
                cx = -1
                cy = cy + 1
            else
                cx = baseWidget.w + 1
                cy = cy - 1
            end
        end
    end
    return found
end

function FocusHandler:onActionFocusRight()
    local found = findNextFocusableChild1(self, "right")
    if found then
        self:setFocus(found)
    end
    return true
end
function FocusHandler:onActionFocusLeft()
    local found = findNextFocusableChild1(self, "left")
    if found then
        self:setFocus(found)
    end
    return true
end
function FocusHandler:onActionFocusUp()
    local found = findNextFocusableChild1(self, "up")
    if found then
        self:setFocus(found)
    end
    return true
end
function FocusHandler:onActionFocusDown()
    local found = findNextFocusableChild1(self, "down")
    if found then
        self:setFocus(found)
    end
    return true
end
function FocusHandler:onActionFocusNext()
    local found = findNextFocusableChild2(self, "next")
    if found then
        self:setFocus(found)
    end
    return true    
end
function FocusHandler:onActionFocusPrev()
    local found = findNextFocusableChild2(self, "prev")
    if found then
        self:setFocus(found)
    end
    return true    
end

function FocusHandler:_handleFocusIn()
    if not self._hasFocus then
        self._hasFocus = true
        local focusedChild = getFocusedChild[self]
        if focusedChild then
            focusedChild:_handleFocusIn()
        else
            local baseWidget = self.baseWidget
            local found, foundX, foundY
            local focusableChildren = getFocusableChildren[self]
            for i = 1, #focusableChildren do
                local child = focusableChildren[i]
                if child.visible then
                    if found then
                        local childX, childY = child:transformXY(0, 0, baseWidget)
                        if childY < foundY or childY == foundY and childX < foundX then
                            foundX = childX
                            foundY = childY
                            found = child
                        end
                    else
                        foundX, foundY = child:transformXY(0, 0, baseWidget)
                        found = child
                    end
                end
            end
            if found then
                getFocusedChild[self] = found
                found:_handleFocusIn()
            end
        end
        local allHotkeys = getHotkeys[self]
        if allHotkeys then
            for hotkey, list in pairs(allHotkeys) do
                local n = #list
                if n > 0 then
                    list[n]:onHotkeyEnabled(hotkey)
                end
            end
        end
    end
end

function FocusHandler:_handleFocusOut()
    if self._hasFocus then
        self._hasFocus = false
        local focusedChild = getFocusedChild[self]
        if focusedChild then
            focusedChild:_handleFocusOut()
        end
        local allHotkeys = getHotkeys[self]
        if allHotkeys then
            for hotkey, list in pairs(allHotkeys) do
                local n = #list
                if n > 0 then
                    list[n]:onHotkeyDisabled(hotkey)
                end
            end
        end
    end
end

function FocusHandler:setFocus(newFocusChild)
    local focusedChild = getFocusedChild[self]
    if focusedChild ~= newFocusChild then
        getFocusedChild[self] = newFocusChild
        if self._hasFocus then
            if focusedChild then
                focusedChild:_handleFocusOut()
            end
            if newFocusChild then
                newFocusChild:_handleFocusIn()
            end
        end
    end
end

function FocusHandler:hasActionMethod(actionMethodName)
    local focusedChild = getFocusedChild[self]
    if focusedChild then
        local childHasActionMethod = focusedChild.hasActionMethod
        if childHasActionMethod and childHasActionMethod(focusedChild, actionMethodName) then
            return true
        end
    end
    return Super.hasActionMethod(self, actionMethodName)
end

function FocusHandler:invokeActionMethod(actionMethodName)
    local focusedChild = getFocusedChild[self]
    if focusedChild then
        local childInvokeActionMethod = focusedChild.invokeActionMethod
        if childInvokeActionMethod and childInvokeActionMethod(focusedChild, actionMethodName) then
            return true
        end
    end
    return Super.invokeActionMethod(self, actionMethodName)
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

local function handleHotkey(self, key)
    local allHotkeys = getHotkeys[self]
    if allHotkeys then
        local list = allHotkeys[key]
        if list then
            local n = #list
            if n > 0 then
                local w = list[n]
                local onHotkeyDown = w.onHotkeyDown
                if onHotkeyDown then
                    onHotkeyDown(w)
                    return true
                end
            end
        end
    end
end


function FocusHandler:onKeyDown(key, modifier, ...)
    local focusedChild = getFocusedChild[self]
    local handled 
    if focusedChild then
        local onKeyDown = focusedChild.onKeyDown 
        if onKeyDown then
            handled = onKeyDown(focusedChild, key, modifier, ...)
        end
    end
    if not handled and modifier == 0 then
        handled = handleHotkey(self, key)
    end
    return handled
end

function FocusHandler:registerHotkeys(widget, hotkeys)
    local allHotkeys = getHotkeys[self]
    if not allHotkeys then
        allHotkeys = {}
        getHotkeys[self] = allHotkeys
    end
    for hotkey, flag in pairs(hotkeys) do
        local list = allHotkeys[hotkey]
        if not list then
            list = { widget }
            allHotkeys[hotkey] = list
        else 
            local n = #list
            if n > 0 then
                list[n]:onHotkeyDisabled(hotkey)
            end
            list[n + 1] = widget
        end
    end
end

function FocusHandler:deregisterHotkeys(widget, hotkeys)
    local allHotkeys = getHotkeys[self]
    if allHotkeys then
        for hotkey, flag in pairs(hotkeys) do
            local list = allHotkeys[hotkey]
            if list then
                local n = #list 
                if n > 0 then
                    if list[n] == widget then
                        list[n] = nil
                        n = n - 1
                        if n > 0 and self._hasFocus then
                            list[n]:onHotkeyEnabled(hotkey)
                        end
                    else
                        for i = 1, n-1 do
                            if list[i] == widget then
                                table.remove(list, i)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

function FocusHandler:filterKeyDown(key, modifier, ...)
    if modifier == MOD_ALT then
        return handleHotkey(self, key)
    end
end


return FocusHandler
