local lwtk = require"lwtk"

local Application = lwtk.Application
local call        = lwtk.call
local Rect        = lwtk.Rect
local Super       = lwtk.Object
local Animateable = lwtk.Animateable
local Widget      = lwtk.newClass("lwtk.Widget", Super)

local intersectRects      = Rect.intersectRects
local roundRect           = Rect.round

local getApp          = lwtk.get.app
local getRoot         = lwtk.get.root
local getParent       = lwtk.get.parent

Widget:implement(Animateable)

function Widget.newClass(className, baseClass)
    local newClass = Super.newClass(className, baseClass)
    Animateable:initClass(newClass)
    return newClass
end

function Widget:new(initParams)
    Animateable.new(self)
    getApp[self]  = false
    getRoot[self] = self
    self.state = {}
    self.visible = true
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

local function setAppAndRoot(self, app, root)
    if app then
        getApp[self] = app
    end
    getRoot[self] = root
    for _, child in ipairs(self) do
        setAppAndRoot(child, app, root)
    end 
    if app then
        call("onLayout", self, self.w, self.h)
    end
end


function Widget:_setParent(parent)
    assert(not getParent[self], "widget was already added to parent")
    getParent[self] = parent
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

function Widget:_setFrame(newX, newY, newW, newH)
    local x, y, w, h = self.x, self.y, self.w, self.h
    if x ~= newX or y ~= newY or w ~= newW or h ~= newH then
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
        if getApp[self] then
            call("onLayout", self, newW, newH)
        end
    end
end

function Widget:setFrame(...)
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
        onDraw(self, ctx, x0, y0, cx, cy, cw, ch, exposedArea)
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
