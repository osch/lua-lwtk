local lwtk   = require"lwtk"
local remove = table.remove

local MOD_ALT               = lwtk.MOD_ALT
local call                  = lwtk.call
local getFocusableChildren  = lwtk.get.focusableChildren
local getChildLookup        = lwtk.get.childLookup
local getParentFocusHandler = lwtk.get.parentFocusHandler
local getFocusedChild       = lwtk.get.focusedChild
local getApp                = lwtk.get.app
local Callback              = lwtk.Callback

local getDefault            = lwtk.WeakKeysTable()
local getHotkeys            = lwtk.WeakKeysTable()
local registeredWidgets     = lwtk.WeakKeysTable()

local Super        = lwtk.Actionable
local FocusHandler = lwtk.newClass("lwtk.FocusHandler", Super)

function FocusHandler:new(baseWidget)
    Super.new(self)
    self.baseWidget = baseWidget
    getFocusableChildren[self] = {}
end

function FocusHandler:_setParentFocusHandler(parentFocusHandler)
    getParentFocusHandler[self] = parentFocusHandler
end

function FocusHandler:childById(id)
    return getChildLookup[self.baseWidget][id]
end

local hotKeyListMeta = { __mode = "v" }

local function compactHotkeyList(list)
    local n = list.n
    for i = n, 1, -1 do
        if not list[i] then
            n = n - 1
            remove(list, i)
        end
    end
    list.n = n
    return n
end

local function appendToHotkeyList(list, widget)
    local n = list.n + 1
    list[n] = widget
    list.n = n
end

local function removeFromHotkeyList(list, i)
    remove(list, i)
    list.n = list.n - 1
end


local function setFocusedChild(self, child)
    getFocusedChild[self] = child
    local currDefault = getDefault[self]
    if currDefault then
        if currDefault ~= child and child and child.onHotkeyDown then
            call("onDefaultChanged", currDefault, false, true)
            self.defaultPostponed = true
        elseif self.defaultPostponed and not currDefault._focusDisabled and not child.onHotkeyDown then
            call("onDefaultChanged", currDefault, true, true)
            self.defaultPostponed = false
        end
    end
end

local function dist2(x1, y1, x2, y2)
    return (x1-x2)^2 + (y1-y2)^2
end

local function dist(x1, y1, w1, h1,  x2, y2, w2, h2)
    if x1+w1 <= x2 then
        if y1+h1 <= y2 then
            return dist2(x1+w1,y1+h1, x2,y2)
        elseif y1 >= y2+h2 then
            return dist2(x1+w1,y1, x2,y2+h2)
        else
            return (x1+w1 - x2)^2
        end
    elseif x1 >= x2+w2 then
        if y1+h1 <= y2 then
            return dist2(x1,y1+h1, x2+w2,y2)
        elseif y1 >= y2+h2 then
            return dist2(x1,y1, x2+w2,y2+h2)
        else
            return (x2+w2 - x1)^2
        end
    elseif y1+h1 < y2 then
        return (y1+h1 - y2)^2
    elseif y2+h2 > y1 then
        return (y2+h2 - y1)^2
    else
        return 0
    end 
end

local function getD(x1, w1, x2, w2)
    local z1, z2 = x1 + w1, x2 + w2
    local x = (x1 > x2) and x1 or x2
    local z = (z1 > z2) and z2 or z1
    return z - x
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
        local fx, fy, fw, fh, fd -- luacheck: ignore 231/f[wh]
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if not child._hidden and child._handleFocusIn and not child._focusDisabled and child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, baseWidget)
                local nw, nh = child.w, child.h
                if direction == "right" then
                    if ny + nh > cy  and ny < cy + ch then
                        if nx >= cx and (not found or  nx - cx <  fx - cx 
                                                   or (nx - cx == fx - cx and ny < fy))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "left" then
                    if ny + nh >= cy  and ny < cy + ch then
                        if nx < cx and (not found or  cx - nx <  cx - fx
                                                  or (cx - nx == cx - fx and ny < fy))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "up" then
                    local nd = getD(nx, nw, cx, cw)
                    if nx + nw >= cx  and nx < cx + cw then
                        if ny < cy and (not found or  cy - ny  < cy - fy
                                                  or (cy - ny == cy - fy and (nd > fd or nd == fd and nx < fx)))
                        then
                            found, fx, fy, fw, fh, fd = child, nx, ny, nw, nh, nd
                        end
                    end
                elseif direction == "down" then
                    local nd = getD(nx, nw, cx, cw)
                    if nx + nw > cx  and nx < cx + cw then
                        if ny >= cy and (not found or  ny - cy <  fy - cy
                                                   or (ny - cy == fy - cy and (nd > fd or nd == fd and nx < fx)))
                        then
                            found, fx, fy, fw, fh, fd = child, nx, ny, nw, nh, nd
                        end
                    end
                end
            end
        end
    end
    if not found  then
        local fx, fy, fw, fh
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if not child._hidden and child._handleFocusIn and not child._focusDisabled and child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, baseWidget)
                local nw, nh = child.w, child.h
                if direction == "right" then
                    if     not (nx + nw >= cx  and nx < cx + cw) -- up
                       and not (nx + nw > cx  and nx < cx + cw) -- down
                    then
                        if nx > cx + cw and (not found or dist(nx,ny,nw,nh, cx,cy,cw,ch) < dist(fx,fy,fw,fh, cx,cy,cw,ch)) then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "left" then
                    if     not (nx + nw >= cx  and nx < cx + cw) -- up
                       and not (nx + nw > cx  and nx < cx + cw) -- down
                    then
                        if nx < cx and (not found or dist(nx,ny,nw,nh, cx,cy,cw,ch) < dist(fx,fy,fw,fh, cx,cy,cw,ch)) then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "up" then
                    if     not (ny + nh >= cy  and ny < cy + ch) -- left
                       and not (ny + nh > cy  and ny < cy + ch) -- right
                    then
                        if ny < cy and (not found or dist(nx,ny,nw,nh, cx,cy,cw,ch) < dist(fx,fy,fw,fh, cx,cy,cw,ch)) then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "down" then
                    if     not (ny + nh >= cy  and ny < cy + ch) -- left
                       and not (ny + nh > cy  and ny < cy + ch) -- right
                    then
                        if ny >= cy + ch and (not found or dist(nx,ny,nw,nh, cx,cy,cw,ch) < dist(fx,fy,fw,fh, cx,cy,cw,ch)) then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                end
            end
        end
    end
    return found
end

local function isFocusableChild(child)
    return not child._hidden and child._handleFocusIn and not child._focusDisabled
end

local function isFocusableInputChild(child)
    return child._isInput and not child._hidden and child._handleFocusIn and not child._focusDisabled
end

local function findNextFocusableChild2(self, focusedChild, direction, condition)
    local isForw = (direction == "next")
    local cx, cy = 0, 0
    local baseWidget = self.baseWidget
    if focusedChild then
        cx, cy = focusedChild:transformXY(0, 0, baseWidget)
    end
    local focusableChildren = getFocusableChildren[self]
    local found, fx, fy
    do
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if condition(child) and child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, baseWidget)
                if isForw then
                    if nx > cx and ny == cy and (not found or nx < fx) then
                        found = child
                        fx, fy = nx, ny
                    end
                else
                    if nx < cx and ny == cy and (not found or nx > fx) then
                        found = child
                        fx, fy = nx, ny
                    end
                end
            end
        end
    end
    if not found then
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if condition(child) and child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, baseWidget)
                if isForw then
                    if ny > cy and (not found or ny < fy or (ny == fy and nx < fx)) then
                        found = child
                        fx, fy = nx, ny
                    end
                else
                    if ny < cy and (not found or ny > fy or (ny == fy and nx > fx)) then
                        found = child
                        fx, fy = nx, ny
                    end
                end
            end
        end
    end
    return found
end

function FocusHandler:onActionFocusRight()
    local found = findNextFocusableChild1(self, "right")
    if found then
        self:setFocusTo(found)
    end
    return true
end
function FocusHandler:onActionFocusLeft()
    local found = findNextFocusableChild1(self, "left")
    if found then
        self:setFocusTo(found)
    end
    return true
end
function FocusHandler:onActionFocusUp()
    local found = findNextFocusableChild1(self, "up")
    if found then
        self:setFocusTo(found)
    end
    return true
end
function FocusHandler:onActionFocusDown()
    local found = findNextFocusableChild1(self, "down")
    if found then
        self:setFocusTo(found)
    end
    return true
end
function FocusHandler:onActionFocusNext()
    local found = findNextFocusableChild2(self, getFocusedChild[self], "next", isFocusableChild)
    if found then
        self:setFocusTo(found)
    end
    return true    
end
function FocusHandler:onActionFocusPrev()
    local found = findNextFocusableChild2(self, getFocusedChild[self], "prev", isFocusableChild)
    if found then
        self:setFocusTo(found)
    end
    return true    
end


function FocusHandler:findNextInput(child)
    return findNextFocusableChild2(self, child, "next", isFocusableInputChild)
end
function FocusHandler:findPrevInput(child)
    return findNextFocusableChild2(self, child, "prev", isFocusableInputChild)
end

function FocusHandler:setFocusToNextInput(child)
    local next = self:findNextInput(child)
    if next then
        self:setFocusTo(next)
    end
end
function FocusHandler:setFocusToPrevInput(child)
    local prev = self:findPrevInput(child)
    if prev then
        self:setFocusTo(prev)
    end
end

function FocusHandler:_handleFocusIn()
    if not self._hasFocus then
        self._hasFocus = true
        local focusedChild = getFocusedChild[self]
        local default = getDefault[self]
        if focusedChild then
            focusedChild:_handleFocusIn()
        elseif default and not default._hidden and not default._focusDisabled then
            focusedChild = default
            setFocusedChild(self, default)
            default:_handleFocusIn()
        else
            local baseWidget = self.baseWidget
            local found, foundX, foundY
            local focusableChildren = getFocusableChildren[self]
            for i = 1, #focusableChildren do
                local child = focusableChildren[i]
                if isFocusableChild(child) then
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
                focusedChild = found
                setFocusedChild(self, found)
                found:_handleFocusIn()
            end
        end
        local allHotkeys = getHotkeys[self]
        if allHotkeys then
            for hotkey, list in pairs(allHotkeys) do
                local n = compactHotkeyList(list)
                if n > 0 then
                    list[n]:onHotkeyEnabled(hotkey)
                end
            end
        end
        if default and self.defaultPostponed 
                   and not default._focusDisabled 
                   and (not focusedChild or not focusedChild.onHotkeyDown or focusedChild == default)
        then
            self.defaultPostponed = false
            call("onDefaultChanged", default, true, true)
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
        local default = getDefault[self]
        if default and not self.defaultPostponed then
            self.defaultPostponed = true
            call("onDefaultChanged", default, false, true)
        end
        local allHotkeys = getHotkeys[self]
        if allHotkeys then
            for hotkey, list in pairs(allHotkeys) do
                local n = compactHotkeyList(list)
                if n > 0 then
                    list[n]:onHotkeyDisabled(hotkey)
                end
            end
        end
    end
end

local function releaseFocus(self, child)
    local default = getDefault[self]
    if default and default ~= child and not default._hidden and not default._focusDisabled then
        self:setFocusTo(default)
    elseif child == getFocusedChild[self] then
        local found = findNextFocusableChild2(self, child, "next", isFocusableChild)
        if found then
            self:setFocusTo(found)
        end
    end
end

function FocusHandler:releaseFocus(child)
    local app = getApp[self]
    if app then
        app:deferChanges(Callback(releaseFocus, self, child))
    else
        releaseFocus(self, child)
    end
end

function FocusHandler:setFocusTo(newFocusChild)
    if newFocusChild then
        local hasFocus = self._hasFocus
        local focusedChild = getFocusedChild[self]
        if focusedChild ~= newFocusChild then
            setFocusedChild(self, newFocusChild)
            if hasFocus then
                if focusedChild then
                    focusedChild:_handleFocusOut(true)
                end
                if newFocusChild then
                    newFocusChild:_handleFocusIn()
                end
            end
        end
        if not hasFocus then
            call("_handleChildRequestsFocus", self.baseWidget)
        end
    else
        local focusedChild = getFocusedChild[self]
        if focusedChild then
            setFocusedChild(self, nil)
            focusedChild:_handleFocusOut(true)
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


local function handleHotkey(self, key)
    local allHotkeys = getHotkeys[self]
    if allHotkeys then
        local list = allHotkeys[key]
        if list then
            local n = compactHotkeyList(list)
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


function FocusHandler:onKeyDown(key, modifier, keyText, hotKeyName)
    local focusedChild = getFocusedChild[self]
    local handled 
    if focusedChild then
        local onKeyDown = focusedChild.onKeyDown 
        if onKeyDown then
            handled = onKeyDown(focusedChild, key, modifier, keyText)
        end
    end
    if not handled and modifier == 0 and hotKeyName then
        handled = handleHotkey(self, hotKeyName)
    end
    return handled
end

function FocusHandler:registerHotkeys(widget, hotkeys)
    assert(not registeredWidgets[widget])
    registeredWidgets[widget] = true
    local allHotkeys = getHotkeys[self]
    if not allHotkeys then
        allHotkeys = {}
        getHotkeys[self] = allHotkeys
    end
    for hotkey, flag in pairs(hotkeys) do
        local list = allHotkeys[hotkey]
        if not list then
            list = setmetatable({ n = 1, widget }, hotKeyListMeta)
            allHotkeys[hotkey] = list
        else 
            local n = compactHotkeyList(list)
            if n > 0 and self._hasFocus then
                list[n]:onHotkeyDisabled(hotkey)
            end
            appendToHotkeyList(list, widget)
        end
        if self._hasFocus then
            widget:onHotkeyEnabled(hotkey)
        end
    end
end

function FocusHandler:deregisterHotkeys(widget, hotkeys)
    assert(registeredWidgets[widget])
    registeredWidgets[widget] = nil
    local allHotkeys = getHotkeys[self]
    if allHotkeys then
        for hotkey, flag in pairs(hotkeys) do
            local list = allHotkeys[hotkey]
            if list then
                local n = compactHotkeyList(list)
                if n > 0 then
                    if list[n] == widget then
                        removeFromHotkeyList(list, n)
                        n = n - 1
                        if n > 0 and self._hasFocus then
                            list[n]:onHotkeyEnabled(hotkey)
                        end
                        if self._hasFocus then
                            widget:onHotkeyDisabled(hotkey)
                        end
                    else
                        for i = 1, n-1 do
                            if list[i] == widget then
                                removeFromHotkeyList(list, i)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

function FocusHandler:handleHotkey(key, modifier, ...)
    if modifier == MOD_ALT then
        local handled = handleHotkey(self, key)
        if not handled then
            local focusedChild = getFocusedChild[self]
            if focusedChild then
                local childHotKey = focusedChild.handleHotkey
                if childHotKey then
                    handled = childHotKey(focusedChild, key, modifier, ...)
                end 
            end
        end
        return handled
    end
end


function FocusHandler:setDefault(childOrId, defaultFlag)
    local newDefault   = type(childOrId) == "string" and self:childById(childOrId) or childOrId
    local oldDefault   = getDefault[self]
    if defaultFlag then
        if oldDefault and oldDefault ~= newDefault then
            call("onDefaultChanged", oldDefault, false, false)
        end
        if not newDefault._focusDisabled then
            local focusedChild = getFocusedChild[self]
            if not focusedChild or focusedChild == newDefault or not focusedChild.onHotkeyDown then
                if newDefault and oldDefault ~= newDefault then
                    call("onDefaultChanged", newDefault, true, true)
                end
                getDefault[self] = newDefault
                self.defaultPostponed = false
            else
                getDefault[self] = newDefault
                self.defaultPostponed = true
                call("onDefaultChanged", newDefault, false, true)
            end
        else
            getDefault[self] = newDefault
            self.defaultPostponed = true
            call("onDefaultChanged", newDefault, false, true)
        end
    else
        if oldDefault == newDefault then
            getDefault[self] = false
            self.defaultPostponed = false
        end
        call("onDefaultChanged", newDefault, false, false)
    end
end

local function handleDisabled(self, child)
    local default = getDefault[self]
    if default and default ~= child and not default._hidden and not default._focusDisabled then
        self:setFocusTo(default)
    elseif child == getFocusedChild[self] then
        local found = findNextFocusableChild2(self, child, "next", isFocusableChild)
        if not found then
            found = findNextFocusableChild2(self, child, "prev", isFocusableChild)
        end
        self:setFocusTo(found)
    end
--------------------
--[[    local default = getDefault[self]
    if default and default ~= child and not default._hidden and not default._focusDisabled then
        self:setFocusTo(default)
    elseif child == getFocusedChild[self] then
        local found = findNextFocusableChild2(self, child, "next", isFocusableChild)
        if found then
            self:setFocusTo(found)
        end
    end --]]
end

function FocusHandler:setFocusDisabled(child, disableFlag)
    disableFlag = disableFlag and true or false
    if child._focusDisabled ~= disableFlag then
        child._focusDisabled = disableFlag
        if not disableFlag and self.defaultPostponed and getDefault[self] == child then
            self.defaultPostponed = false
            call("onDefaultChanged", child, true, true)
        end
        if disableFlag and getDefault[self] == child and not self.defaultPostponed then
            self.defaultPostponed = true
            call("onDefaultChanged", child, false, true)
        end
        if disableFlag then
            local app = getApp[self]
            if app then
                app:deferChanges(Callback(handleDisabled, self, child))
            end
        end
    end
end


function FocusHandler:isDefault(childOrId)
    local d = (type(childOrId) == "string" and self:childById(childOrId) or childOrId)
    local isPrincipalDefault = (getDefault[self] == d)
    local isCurrentDefault   = isPrincipalDefault and not self.defaultPostponed
    return isCurrentDefault, isPrincipalDefault
end

function FocusHandler:onActionDefaultButton()
    local currDefault = getDefault[self]
    local focusedChild = getFocusedChild[self]
    if     currDefault and not currDefault._focusDisabled 
       and (not focusedChild or focusedChild == currDefault or not focusedChild.onHotkeyDown)
    then
        call("onHotkeyDown", currDefault)
        return true
    end
end

function FocusHandler:onActionCloseWindow()
    local root = self.baseWidget:getRoot()
    if root.requestClose then
        root:requestClose()
        return true
    end
end


return FocusHandler
