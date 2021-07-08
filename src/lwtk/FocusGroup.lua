local lwtk = require("lwtk")

local getApp                = lwtk.get.app
local getParent             = lwtk.get.parent
local getFocusHandler       = lwtk.get.focusHandler
local getParentFocusHandler = lwtk.get.parentFocusHandler
local getFocusableChildren  = lwtk.get.focusableChildren
local FocusHandler          = lwtk.FocusHandler

local Super      = lwtk.Focusable(lwtk.Control(lwtk.Group))
local FocusGroup = lwtk.newClass("lwtk.FocusGroup", Super)

FocusGroup.getMeasures = lwtk.Control.extra.getMeasures

function FocusGroup:new(...)
    Super.new(self, ...)
    getFocusHandler[self] = FocusHandler(self)
end

function FocusGroup:_setApp(app)
    getApp[getFocusHandler[self]] = app
    Super._setApp(self, app)
    local parentHandler = getParent[self]:getFocusHandler()
    getParentFocusHandler[self] = parentHandler
    local focusableChildren = getFocusableChildren[parentHandler]
    focusableChildren[#focusableChildren + 1] = self    
    getFocusHandler[self]:_setParentFocusHandler(parentHandler)
    if self._wantsFocus then
        getParentFocusHandler[self]:setFocus(self)
        self._wantsFocus = false
    end
end

function FocusGroup:_handleFocusIn()
    Super._handleFocusIn(self)
    if self.entered then
        getFocusHandler[self]:_handleFocusIn()
    end
end

function FocusGroup:_handleFocusOut(reallyLostFocus)
    Super._handleFocusOut(self)
    getFocusHandler[self]:_handleFocusOut()
    if reallyLostFocus then
        self.entered = false
        self:setState("entered", false)
    end
end

function FocusGroup:_processMouseDown(mx, my, button, modState)
    if button == 1 and not self.disabled then
        getParentFocusHandler[self]:setFocus(self)
    end
    return Super._processMouseDown(self, mx, my, button, modState)
end

function FocusGroup:_handleChildRequestsFocus()
    if not self.entered then
        self.entered = true
        self:setState("entered", true)
        if self.hasFocus then
            getFocusHandler[self]:_handleFocusIn()
        else
            local parentHandler = getParentFocusHandler[self]
            if parentHandler then
                parentHandler:setFocus(self)
            else
                self._wantsFocus = true
            end
        end
    end
end

function FocusGroup:setFocus(flag)
    if not self.disabled and (flag == nil or flag) then
        local focusHandler = getParentFocusHandler[self]
        if focusHandler then
            focusHandler:setFocus(self)
        else
            self._wantsFocus = true
        end
    end
end

function FocusGroup:onKeyDown(key, modifier, ...)
    local handled
    if self.entered then
        handled = getFocusHandler[self]:onKeyDown(key, modifier, ...)
    end
    return handled
end

function FocusGroup:handleHotkey(key, modifier, ...)
    local handled
    if self.entered then
        handled = getFocusHandler[self]:handleHotkey(key, modifier, ...)
    end
    return handled
end

function FocusGroup:invokeActionMethod(actionMethodName)
    local handled
    if self.entered then
        handled = getFocusHandler[self]:invokeActionMethod(actionMethodName)
    end
    if not handled then
        handled = Super.invokeActionMethod(self, actionMethodName)
    end
    return handled
end

function FocusGroup:onActionEnterFocusGroup()
    if not self.entered then
        self.entered = true
        self:setState("entered", true)
        if self.hasFocus then
            getFocusHandler[self]:_handleFocusIn()
        else
            local parentHandler = getParentFocusHandler[self]
            if parentHandler then
                parentHandler:setFocus(self)
            else
                self._wantsFocus = true
            end
        end
        return true
    end
end

function FocusGroup:onActionExitFocusGroup()
    if self.entered then
        self.entered = false
        self:setState("entered", false)
        getFocusHandler[self]:_handleFocusOut()
        return true
    end
end

return FocusGroup
