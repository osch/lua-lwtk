local lwtk = require"lwtk"

local Area        = lwtk.Area

local Super       = lwtk.Object
local ChildLookup = lwtk.ChildLookup
local Styleable   = lwtk.Styleable
local Window      = lwtk.newClass("lwtk.Window", Super)
local fillRect    = lwtk.draw.fillRect

Window:implement(Styleable)
Window.color = true

local getParent      = lwtk.get.parent
local getStyleParams = lwtk.get.styleParams
local getApp         = lwtk.get.app
local getRoot        = lwtk.get.root


function Window.newClass(className, baseClass)
    local newClass = Super.newClass(className, baseClass)
    Styleable:initClass(newClass)
    return newClass
end

function Window:new(app, initParms)
    getApp[self]  = app
    getRoot[self] = self
    self.getCurrentTime  = app.getCurrentTime
    self.setTimer        = app.setTimer
    getParent[self]      = app
    getStyleParams[self] = app:getStyleParams()
    self.child = ChildLookup(self)
    self.view  = app.world:newView { resizable = true }
    self.view:setEventFunc(app.eventFunc, self)
    self.exposedArea = Area()
    self.damagedArea = Area() -- as cache
    self.mouseEntered = false
    app:_addWindow(self)
    if initParms then
        local childList = {}
        for i = 1, #initParms do
            childList[i] = initParms[i]
            initParms[i] = nil
        end
        self:setAttributes(initParms)
        for i = 1, #childList do
            local c = childList[i]
            self:addChild(c)
        end
    end
end

function Window:addChild(child)
    assert(not self[1], "Window can only have one child widget")
    self[1] = child
    child:_setParent(self)
    self:_clearChildLookup()
    if self.w then
        child:_setFrame(0, 0, self.w, self.h)
    end
    return child
end

function Window:setTitle(title)
    self.view:setTitle(title)
end

function Window:setColor(color)
    if self.color ~= color then
        self.color = color
        self.hasChanges = true
        local p = getParent[self]
        if p then p.hasChanges = true end
    end
end

function Window:show()
    self.view:show()
end

function Window:hide()
    self.view:hide()
end

function Window:close()
    self.view:close()
    getParent[self]:_removeWindow(self)
end

function Window:_handleConfigure(x, y, w, h)
    self.x = x
    self.y = y
    if self.w ~= w or self.h ~= h then
        self.w = w
        self.h = h
        local child = self[1]
        if child then
            child:_setFrame(0, 0, w, h)
        end
    end
end

function Window:_handleExpose(x, y, w, h, count)
    self.exposedArea:addRect(x, y, w, h)
    if count == 0 then
        local child = self[1]
        if child and child.visible then
            local ctx = self.view:getDrawContext()
            for _, ax, ay, aw, ah in self.exposedArea:iteration() do
                ctx:rectangle(ax, ay, aw, ah)
            end
            ctx:clip()
            local color = self.color
            if color == true then
                color = self:getStyleParam("Color")
            end
            if color and self.w then
                fillRect(ctx, color, 0, 0, self.w, self.h)
            end
            child:_processDraw(ctx, 0, 0, 0, 0, self.w, self.h, self.exposedArea)
        end
        self.exposedArea:clear()
    end
end

function Window:_handleMouseEnter(mx, my)
    self.mouseX = mx
    self.mouseY = my
    self.mouseEntered = true
    local child = self[1]
    if child and child.visible then
        child:_processMouseEnter(mx, my)
    end
end

function Window:_handleMouseMove(mx, my)
    self.mouseX = mx
    self.mouseY = my
    self.mouseEntered = true
    local child = self[1]
    if child and child.visible then
        child:_processMouseMove(mx, my)
    end
end

function Window:_handleMouseLeave(mx, my)
    self.mouseX = mx
    self.mouseY = my
    self.mouseEntered = false
    local child = self[1]
    if child and child.visible then
        child:_processMouseLeave(mx, my)
    end
end

function Window:_handleMouseDown(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    local child = self[1]
    if child and child.visible then
        child:_processMouseDown(mx, my, button, modState)
    end
end

function Window:_handleMouseUp(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    local child = self[1]
    if child and child.visible then
        child:_processMouseUp(mx, my, button, modState)
    end
end

function Window:_handleClose()
    local onClose = self.onClose
    if onClose then
        onClose(self)
    else
        self:close()
    end
end

function Window:_clearChildLookup() 
    if self.child[0] then
        self.child = ChildLookup(self)
    end
end

function Window:_processChanges()
    local child = self[1]
    if self.positionsChanged then
        self.positionsChanged = false
        if self.mouseEntered then
            local mx, my = self.mouseX, self.mouseY
            if mx then
                self:_handleMouseMove(mx, my)
            end
        end
    end
    if child and child.hasChanges then
        child.hasChanges       = false
        child.positionsChanged = false
        if self.w then
            local damagedArea = self.damagedArea
            child:_processChanges(0, 0, 0, 0, self.w, self.h, damagedArea)
            if damagedArea.count > 0 then
                local view = self.view
                for _, x, y, w, h in damagedArea:iteration() do
                    view:postRedisplayRect(x, y, w, h)
                end
                damagedArea:clear()
            end
        end
    end
end

return Window
