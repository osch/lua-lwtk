local lwtk = require"lwtk"

local Application = lwtk.Application
local call        = lwtk.call
local Rect        = lwtk.Rect
local Animatable  = lwtk.Animatable

local intersectRects      = Rect.intersectRects
local roundRect           = Rect.round

local getApp               = lwtk.get.app
local getRoot              = lwtk.get.root
local getParent            = lwtk.get.parent
local getStyleParams       = lwtk.get.styleParams
local getFocusHandler      = lwtk.get.focusHandler
local getFocusableChildren = lwtk.get.focusableChildren
local getActions           = lwtk.get.actions
local wantsFocus           = lwtk.get.wantsFocus
local callOnLayout         = lwtk.layout.callOnLayout

local Super       = lwtk.Actionable
local Widget      = lwtk.newClass("lwtk.Widget", Super)

Widget:implement(Animatable)

function Widget.newClass(className, baseClass, additionalStyleSelector, ...)
    local newClass = Super.newClass(className, baseClass)
    Animatable:initClass(newClass, additionalStyleSelector, ...)
    return newClass
end

function Widget:new(initParams)
    Super.new(self, initParams)
    Animatable.new(self)
    getApp[self]  = false
    getRoot[self] = self
    self.state = {}
    self.visible = true
    self.opacity = 1
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
    if initParams then
        local id = initParams.id
        if id then
            assert(type(id) == "string", "id must be string")
            self.id = id
            initParams.id = nil
        end
        local style = initParams.style
        if style then
            initParams.style = nil
            self.style = style
        end
        assert(initParams[1] == nil, "child objects are not supported")
        self:setAttributes(initParams)
    end
end

function Widget:setTimer(seconds, func, ...)
    local p = getParent[self]
    assert(p, "widget not connected to parent")
    p:setTimer(seconds, func, ...)
    self.setTimer = p.setTimer
end

function Widget:getCurrentTime()
    local p = getParent[self]
    assert(p, "widget not connected to parent")
    local rslt = p:getCurrentTime()
    self.getCurrentTime = p.getCurrentTime
    return rslt
end

function Widget:getLayoutContext()
    local ctx
    local root = getRoot[self]
    if root then ctx = root:getLayoutContext() end
    assert(ctx, "Widget not connected to Window")
    return ctx
end

local function setAppAndRoot(self, app, root)
    getRoot[self] = root
    if app then
        getApp[self] = app
        local style = self.style
        if style then
            self.style = nil
            self:setStyle(style)
        end
    end
    for _, child in ipairs(self) do
        setAppAndRoot(child, app, root)
    end 
    if self._handleFocusIn and not getFocusHandler[self] then
        local handler = self:getFocusHandler()
        if handler then
            getFocusHandler[self] = handler
            local focusableChildren = getFocusableChildren[handler]
            focusableChildren[#focusableChildren + 1] = self
            if wantsFocus[self] then
                handler:setFocus(self)
                wantsFocus[self] = nil
            end
            local handleHasFocusHandler = self._handleHasFocusHandler
            if handleHasFocusHandler then
                handleHasFocusHandler(self, handler)
            end
        end
    end
    local w, h = self.w, self.h
    if app and w > 0 and h > 0 then
        callOnLayout(self, w, h)
    end
end

local function setStyleParams(self, styleParams)
    getStyleParams[self] = styleParams
    for _, child in ipairs(self) do
        setStyleParams(child, styleParams)
    end
end

function Widget:_setParent(parent)
    assert(not getParent[self], "widget was already added to parent")
    getParent[self] = parent
    if not getStyleParams[self] then
        local styleParams = getStyleParams[parent] or getStyleParams[app]
        if styleParams then
            setStyleParams(self, styleParams)
        end
    end
    setAppAndRoot(self, getApp[parent],
                        getRoot[parent])
    if self.hasChanges then
        local w = parent
        repeat
            if w.hasChanges then
                break
            end
            w.hasChanges = true
            w = getParent[w]
        until not w
    end
end

function Widget:getParent()
    return getParent[self]
end

function Widget:getRoot()
    return getRoot[self]
end

function Widget:getFocusHandler()
    local handler = getFocusHandler[self]
    if not handler then
        local p = getParent[self]
        while p do
            handler = getFocusHandler[p]
            if not handler then
                p = getParent[p]
            else
                getFocusHandler[self] = handler
                break
            end
                
        end
    end
    return handler
end

function Widget:transformXY(x, y, parent)
    local w = self
    repeat
        x = x + w.x
        y = y + w.y
        w = getParent[w]
        if w == parent then
            return x, y
        end
    until not w
end

function Widget:_setFrame(newX, newY, newW, newH)
    local x, y, w, h = self.x, self.y, self.w, self.h
    local needsLayout = (w ~= newW or h ~= newH)
    if x ~= newX or y ~= newY or needsLayout then
        self.needsRedraw = true
        if not self.oldX then
            self.oldX = x
            self.oldY = y
            self.oldW = w
            self.oldH = h
            local w = self
            repeat
                if w.hasChanges and w.positionsChanged then
                    break
                end
                w.hasChanges = true
                w.positionsChanged = true
                w = getParent[w]
            until not w
        end
        self.x = newX
        self.y = newY
        self.w = newW
        self.h = newH
        if needsLayout and getApp[self] then
            callOnLayout(self, newW, newH)
        end
    end
end

function Widget:getVisibility()
    local trans = self.visibilityTransition
    if trans then
        return trans.newVisibility
    else
        return self.visible
    end
end

function Widget:setVisibility(newFlag)
    if newFlag ~= self.visible then
        self.visibilityTransition = nil
        self.opacity = 1
        self.visible = newFlag
        self:triggerRedraw()
    end
end


function Widget:setFrame(...)
    self.frameTransition = nil
    local x, y, w, h = ...
    if type(x) == "number" then
        self:_setFrame(roundRect(x, y, w, h))
    else
        if x[1] then
            self:_setFrame(roundRect(x[1], x[2], x[3], x[4]))
        elseif x.w then
            self:_setFrame(roundRect(x.x, x.y, x.w, x.h))
        else
            self:_setFrame(roundRect(x.x, x.y, x.width, x.height))
        end
    end
end

function Widget:getFrame()
    return self.x, self.y, self.w, self.h
end

function Widget:getSize()
    return self.w, self.h
end

function Widget:changeFrame(...)
    local x, y, w, h = ...
    if type(x) == "number" then
        Animatable.changeFrame(self, roundRect(x, y, w, h))
    else
        if x[1] then
            Animatable.changeFrame(self, roundRect(x[1], x[2], x[3], x[4]))
        elseif x.w then
            Animatable.changeFrame(self, roundRect(x.x, x.y, x.w, x.h))
        else
            Animatable.changeFrame(self, roundRect(x.x, x.y, x.width, x.height))
        end
    end
end

function Widget:triggerRedraw()
    if not self.needsRedraw then
        self.needsRedraw = true
        local w = self
        repeat
            if w.hasChanges then
                break
            end
            w.hasChanges = true
            w = getParent[w]
        until not w
    end
end

function Widget:_processChanges(x0, y0, cx, cy, cw, ch, damagedArea)
    if self.needsRedraw then
        self.needsRedraw = false
        local x, y, w, h = self.x + x0, self.y + y0, self.w, self.h
        local x1, y1, w1, h1 = intersectRects(x, y, w, h, cx, cy, cw, ch)
        if w1 > 0 and h1 > 0 then
            damagedArea:addRect(x1, y1, w1, h1)
        end
    end
    if self.oldX then
        local x, y, w, h = self.oldX + x0, self.oldY + y0, self.oldW, self.oldH
        local x1, y1, w1, h1 = intersectRects(x, y, w, h, cx, cy, cw, ch)
        if w1 > 0 and h1 > 0 then
            damagedArea:addRect(x1, y1, w1, h1)
        end
        self.oldX = false
    end
end

function Widget:_processDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    local onDraw = self.onDraw
    if onDraw then
        self:updateAnimation()
        if self.opacity == 1 then
            onDraw(self, ctx, x0, y0, cx, cy, cw, ch, exposedArea)
        else
            ctx:push_group()
            onDraw(self, ctx, x0, y0, cx, cy, cw, ch, exposedArea)
            ctx:pop_group_to_source()
            ctx:paint_with_alpha(self.opacity)
        end
    end
end

function Widget:_processMouseEnter(x, y)
    call("onMouseEnter", self, x, y)
end

function Widget:_processMouseMove(mouseEntered, x, y)
    call("onMouseMove", self, x, y)
end

function Widget:_processMouseLeave(x, y)
    call("onMouseLeave", self, x, y)
end

function Widget:_processMouseDown(mx, my, button, modState)
    local onMouseDown = self.onMouseDown
    if onMouseDown then
        onMouseDown(self, mx, my, button, modState)
        return true
    end
end

function Widget:_processMouseUp(mouseEntered, mx, my, button, modState)
    call("onMouseUp", self, mx, my, button, modState)
end

return Widget
