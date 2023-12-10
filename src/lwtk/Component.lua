local lwtk = require"lwtk"

local upper  = string.upper
local sub    = string.sub

local errorf      = lwtk.errorf
local call        = lwtk.call
local Rect        = lwtk.Rect
local Animatable  = lwtk.Animatable

local intersectRects      = Rect.intersectRects
local roundRect           = Rect.round

local extract              = lwtk.extract
local getApp               = lwtk.get.app
local getRoot              = lwtk.get.root
local getParent            = lwtk.get.parent
local getFocusHandler      = lwtk.get.focusHandler
local getFocusableChildren = lwtk.get.focusableChildren
local callOnLayout         = lwtk.layout.callOnLayout
local getFontInfos         = lwtk.get.fontInfos
local getChildLookup       = lwtk.get.childLookup

local Super       = lwtk.Drawable(lwtk.Node(lwtk.Actionable()))
local Component   = lwtk.newClass("lwtk.Component", Super)

Component:declare(
    "_animationActive",
    "_animationTriggered",
    "_handleFocusIn", 
    "_handleHasFocusHandler", 
    "_hasChanges", 
    "_isRelayouting", 
    "_needsRedraw", 
    "_needsRelayout", 
    "_positionsChanged", 
    "_frameTransition",
    "_hidden",
    "_ignored",
    "initParams", 
    "oldX",  "oldY",  "oldW",  "oldH", 
    "getMeasures",
    "onDisabled", 
    "onDraw", 
    "onHotkeyEnabled", 
    "onEffectiveVisibilityChanged",
    "onLayout",
    "onRealize"
)

function Component.override:new(initParams)
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
    self.visible = true
    getApp[self]  = false
    getRoot[self] = self
    Super.new(self, initParams)
end

function Component.override:setInitParams(initParams)
    if initParams then
        local id = initParams.id
        if id then
            assert(type(id) == "string", "id must be string")
            assert(not id:match("/"), "id must not contain / character")
            self.id = id
            initParams.id = nil
        end
        local addChild = self.addChild
        if not addChild then
            assert(initParams[1] == nil, "child objects are not supported")
        else
            for i = 1, #initParams do
                addChild(self, initParams[i])
                initParams[i] = nil
            end
        end
        Super.setInitParams(self, initParams)
    end
end

function Component.override:handleRemainingInitParams(initParams)
    local hasRemaining = false
    for k, v in pairs(initParams) do
        assert(type(k) == "string", "attribute names  must be string")
        local setterName = "set"..upper(sub(k, 1, 1))..sub(k, 2)
        local setter = self[setterName]
        if type(setter) == "function" then
            setter(self, v)
            initParams[k] = nil
        else
            hasRemaining = true
        end
    end
    if hasRemaining then
        self.initParams = initParams
    end
end

function Component:setTimer(seconds, func, ...)
    local p = assert(getParent[self], "Component not connected to parent")
    p:setTimer(seconds, func, ...)
end

function Component:getCurrentTime()
    local app = assert(getApp[self], "Component not connected to Application")
    return app:getCurrentTime()
end

function Component:getFontInfo(family, slant, weight, size)
    return getFontInfos[self]:getFontInfo(family, slant, weight, size)
end

function Component:getLayoutContext()
    local ctx
    local root = getRoot[self]
    if root then ctx = root:getLayoutContext() end
    assert(ctx, "Component not connected to Window")
    return ctx
end

function Component:_setApp(app)
    assert(not getApp[self], "Component was already added to Application")
    getApp[self] = app
    getFontInfos[self] = getFontInfos[app]
end

function Component:byId(id)
    local id1, id2 = id:match("^([^/]*)/(.*)$")
    if id1 then
        local p = self:parentById(id1)
        if not p then
            p = self:getRoot():childById(id1)
        end
        if p and p.childById then 
            return p:childById(id2) 
        end
    else
        return getChildLookup[getRoot[self]][id]
    end
end

function Component:parentById(id)
    local p = getParent[self]
    while p do
        if p.id == id then
            return p
        end
        p = getParent[p]
    end
end

local function setAppAndRoot(self, app, root)
    local oldRoot = getRoot[self]
    if oldRoot and oldRoot._positionsChanged then
        root._positionsChanged = true
        oldRoot._positionsChanged = nil
    end
    getRoot[self] = root
    if app then
        self:_setApp(app)
    end
    for i = 1, #self do
        local child = rawget(self, i)
        setAppAndRoot(child, app, root)
    end 
    if (self._handleFocusIn or self.onHotkeyEnabled) and not getFocusHandler[self] then
        local handler = self:getFocusHandler()
        if handler then
            getFocusHandler[self] = handler
            local focusableChildren = getFocusableChildren[handler]
            focusableChildren[#focusableChildren + 1] = self
            call("_handleHasFocusHandler", self, handler)
        end
    end
    local w, h = self.w, self.h
    if app and w > 0 and h > 0 then
        callOnLayout(self, w, h)
    end
    if app then
        local initParams = extract(self, "initParams")
        if initParams then
            local extensions = app.extensions
            if extensions then
                for i = #extensions, 1, -1 do
                    local e = extensions[i]
                    local handleComponentInitParams = e.handleComponentInitParams
                    if handleComponentInitParams then
                        handleComponentInitParams(e, self, initParams)
                    end
                end
            end
            for k, v in pairs(initParams) do
                errorf("unknown init parameter %q", k)
            end
        end
    end
end

function Component:_setParent(parent)
    assert(not getParent[self], "Component was already added to parent")
    getParent[self] = parent
    local app = getApp[parent]
    setAppAndRoot(self, app,
                        getRoot[parent])
    local _needsRelayout = self._needsRelayout
    if self._hasChanges then
        local w = parent
        repeat
            if w._hasChanges and w._needsRelayout == _needsRelayout then
                break
            end
            w._hasChanges    = true
            w._needsRelayout = _needsRelayout
            w = getParent[w]
            if not w and app then
                app._hasChanges = true
            end
        until not w
    end
end

function Component:getParent()
    return getParent[self]
end

function Component:getRoot()
    return getRoot[self]
end

function Component:getFocusHandler()
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

function Component:transformXY(x, y, parent)
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

function Component:_setFrame(newX, newY, newW, newH, fromFrameAnimation)
    if not fromFrameAnimation and self._frameTransition then
        self._frameTransition = false
    end
    if not self._isRelayouting then
        local x, y, w, h = self.x, self.y, self.w, self.h
        local needsLayout = (w ~= newW or h ~= newH or self._needsRelayout)
        if x ~= newX or y ~= newY or needsLayout then
            self._needsRedraw = true
            if not self.oldX then
                self.oldX = x
                self.oldY = y
                self.oldW = w
                self.oldH = h
                local root = getRoot[self]
                if root then
                    root._positionsChanged = true
                end
                local widget = self
                repeat
                    if widget._hasChanges then
                        break
                    end
                    widget._hasChanges = true
                    widget = getParent[widget]
                    if not widget then
                        local app = getApp[self]
                        if app then
                            app._hasChanges = true
                        end
                    end
                until not widget
            end
            self.x, self.y, self.w, self.h = newX, newY, newW, newH
            local trans = self._frameTransition
            if needsLayout and getApp[self] then
                local isLayoutTransition = trans and trans.isLayoutTransition
                callOnLayout(self, newW, newH, isLayoutTransition)
            end
        end
    else
        local needsLayout = (self.w ~= newW or self.h ~= newH)
        self.x, self.y, self.w, self.h = newX, newY, newW, newH
        if needsLayout or self._needsRelayout then
            callOnLayout(self, newW, newH)
        end
    end
end

function Component:setFrame(...)
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

function Component:getFrame()
    return self.x, self.y, self.w, self.h
end

function Component:getSize()
    return self.w, self.h
end

function Component:animateFrame(...)
    local x, y, w, h, isLayoutTransition = ...
    local nx, ny, nw, nh
    if type(x) == "number" then
        nx, ny, nw, nh = roundRect(x, y, w, h)
    else
        if x[1] then
            nx, ny, nw, nh = roundRect(x[1], x[2], x[3], x[4])
            isLayoutTransition = y
        elseif x.w then
            nx, ny, nw, nh = roundRect(x.x, x.y, x.w, x.h)
            isLayoutTransition = y
        else
            nx, ny, nw, nh = roundRect(x.x, x.y, x.width, x.height)
            isLayoutTransition = y
        end
    end
    Animatable.animateFrame(self, nx, ny, nw, nh, isLayoutTransition)
end

function Component:updateFrameTransition()
    local trans = self._frameTransition
    if trans then
        local now = self:getCurrentTime()
        local T = trans.endTime - trans.startTime
        local t = now - trans.startTime
        if T > 0 and t > 0 and now < trans.endTime then
            t = t / T
            local x = (1-t) * trans.oldX + t * trans.newX
            local y = (1-t) * trans.oldY + t * trans.newY
            local w = (1-t) * trans.oldW + t * trans.newW
            local h = (1-t) * trans.oldH + t * trans.newH
            self:_setFrame(x, y, w, h, true)
        else
            self:_setFrame(trans.newX, trans.newY, trans.newW, trans.newH)
            self._frameTransition = false
        end
    end
end


function Component:triggerLayout()
    local app = getApp[self]
    if app then
        self._needsRelayout = true
        local p = getParent[self]
        while p and not p._needsRelayout do
            p._hasChanges = true
            p._needsRelayout = true
            p = getParent[p]
            if not p then
                app._hasChanges = true
            end
        end
    end
end

function Component:triggerRedraw()
    if not self._needsRedraw then
        self._needsRedraw = true
        local w = self
        repeat
            if w._hasChanges then
                break
            end
            w._hasChanges = true
            w = getParent[w]
            if not w then
                local app = getApp[self]
                if app then
                    app._hasChanges = true
                end
            end
        until not w
    end
end

function Component:_processChanges(x0, y0, cx, cy, cw, ch, damagedArea)
    if self._needsRedraw then
        self._needsRedraw = false
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

function Component:updateAnimation()
    getParent[self]:updateAnimation()
end

function Component:_processDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    local onDraw = self.onDraw
    if onDraw then
        self:updateAnimation()
        local opacity = self:getStyleParam("Opacity") or 1
        if opacity == 1 then
            onDraw(self, ctx, x0, y0, cx, cy, cw, ch, exposedArea)
        else
            ctx:beginOpacity(opacity)
            onDraw(self, ctx, x0, y0, cx, cy, cw, ch, exposedArea)
            ctx:endOpacity()
        end
    end
end

return Component
