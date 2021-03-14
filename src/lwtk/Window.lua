local lwtk = require"lwtk"

local Area        = lwtk.Area

local ChildLookup     = lwtk.ChildLookup
local Styleable       = lwtk.Styleable
local KeyHandler      = lwtk.KeyHandler
local fillRect        = lwtk.draw.fillRect
local FocusHandler    = lwtk.FocusHandler
local getFocusHandler = lwtk.get.focusHandler
local getMeasures     = lwtk.layout.getMeasures
local call            = lwtk.call

local Super        = lwtk.Object
local Window       = lwtk.newClass("lwtk.Window", Super)

Window:implementFrom(Styleable)
Window:implementFrom(KeyHandler)
Window.color = true

local getParent       = lwtk.get.parent
local getStyleParams  = lwtk.get.styleParams
local getApp          = lwtk.get.app
local getRoot         = lwtk.get.root
local getKeyBinding   = lwtk.get.keyBinding
local getFontInfos    = lwtk.get.fontInfos
local ignored         = lwtk.get.ignored

function Window.newClass(className, baseClass)
    local newClass = Super.newClass(className, baseClass)
    Styleable:initClass(newClass)
    return newClass
end

function Window:new(app, initParms)
    Styleable.new(self)
    self.fullRedisplayOutstanding = true
    getApp[self]  = app
    getRoot[self] = self
    getFontInfos[self] = getFontInfos[app]
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
    self.getCurrentTime  = app.getCurrentTime
    self.setTimer        = app.setTimer
    getParent[self]      = app
    getKeyBinding[self]  = getKeyBinding[app]
    getStyleParams[self] = getStyleParams[app]
    KeyHandler.new(self)
    self.child = ChildLookup(self)
    self.exposedArea = Area()
    self.damagedArea = Area() -- as cache
    self.mouseEntered = false
    app:_addWindow(self)
    self.view = app.world:newView {
        resizable      = true, 
        dontMergeRects = true,
        eventFunc      = {app._eventFunc, self}  
    }
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
    self[#self + 1] = child
    getFocusHandler[child] = FocusHandler(child)
    child:_setParent(self)
    self:_clearChildLookup()
    if self.w > 0 and self.h > 0 then
        child:_setFrame(0, 0, self.w, self.h)
    else
        if child.getMeasures then
            local minW, minH, bestW, bestH, maxW, maxH, 
                  childTop, childRight, childBottom, childLeft = getMeasures(child)
            local mw = (childLeft or 0) + minW  + (childRight  or 0)
            local mh = (childTop  or 0) + minH  + (childBottom or 0)
            local bw = (childLeft or 0) + bestW + (childRight  or 0)
            local bh = (childTop  or 0) + bestH + (childBottom or 0)
            if bw > 0 and bh > 0 then
                self.view:setMinSize(mw, mh)
                self.view:setSize(bw, bh)
            end
            if maxW > 0 or maxH > 0 then
                local mxw = maxW > 0 and ((childLeft or 0) + maxW + (childRight  or 0)) or -1
                local mxh = maxH > 0 and ((childTop  or 0) + maxH + (childBottom or 0)) or -1
                self.view:setMaxSize(mxw, mxh)
            end
        end
    end
    return child
end

function Window:setSize(...)
    local arg1, arg2 = ...
    if arg2 then
        self.view:setSize(arg1, arg2)
    else
        self.view:setSize(arg1[1], arg1[2])
    end
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

function Window:getLayoutContext()
    return self.view:getLayoutContext()
end

function Window:getFontInfo(family, slant, weight, size)
    return getFontInfos[self]:getFontInfo(family, slant, weight, size)
end

function Window:_handleConfigure(x, y, w, h)
    self.x = x
    self.y = y
    if self.w ~= w or self.h ~= h then
        self.w = w
        self.h = h
        for i = 1, #self do
            local child = self[i]
            child:_setFrame(0, 0, w, h)
        end
    end
end

function Window:_handleExpose(x, y, w, h, count)
    self.exposedArea:addRect(x, y, w, h)
    if count == 0 then
        self.fullRedisplayOutstanding = false
        local ctx = self.view:getDrawContext()
        local color = self.color
        if color == true then
            color = self:getStyleParam("BackgroundColor")
        end
        if color and self.w then
            fillRect(ctx, color, 0, 0, self.w, self.h)
        end
        for i = 1, #self do
            local child = self[i]
            if not ignored[child] then
                child:_processDraw(ctx, 0, 0, 0, 0, self.w, self.h, self.exposedArea)
            end
        end
        self.exposedArea:clear()
    end
end

function Window:_handleMouseEnter(mx, my)
    self.mouseX = mx
    self.mouseY = my
    self.mouseEntered = true
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            child:_processMouseEnter(mx, my)
            break
        end
    end
end

function Window:_handleMouseMove(mx, my)
    self.mouseX = mx
    self.mouseY = my
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            child:_processMouseMove(self.mouseEntered, mx, my)
            break
        end
    end
end

function Window:_handleMouseLeave(mx, my)
    self.mouseX = mx
    self.mouseY = my
    self.mouseEntered = false
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            child:_processMouseLeave(mx, my)
            break
        end
    end
end

function Window:_handleMouseDown(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            child:_processMouseDown(mx, my, button, modState)
            break
        end
    end
end

function Window:_handleMouseUp(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            child:_processMouseUp(self.mouseEntered, mx, my, button, modState)
            break
        end
    end
end

function Window:_handleFocusIn()
    self:resetKeyHandling()
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            getFocusHandler[child]:_handleFocusIn()
            break
        end
    end
end

function Window:_handleFocusOut()
    self:resetKeyHandling()
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            getFocusHandler[child]:_handleFocusOut()
            break
        end
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
    if self.positionsChanged then
        self.positionsChanged = false
        if self.mouseEntered then
            local mx, my = self.mouseX, self.mouseY
            if mx then
                self:_handleMouseMove(mx, my)
            end
        end
    end
    for i = 1, #self do
        local child = self[i]
        if child.hasChanges then
            child.hasChanges       = false
            child.positionsChanged = false
            if self.w then
                local damagedArea = self.damagedArea
                child:_processChanges(0, 0, 0, 0, self.w, self.h, damagedArea)
                if damagedArea.count > 0 then
                    local view = self.view
                    for _, x, y, w, h in damagedArea:iteration() do
                        if not self.fullRedisplayOutstanding then
                            view:postRedisplay(x, y, w, h)
                            if x <= 0 and y <= 0 and x + w >= self.w and y + h >= self.h then
                                self.fullRedisplayOutstanding = true
                            end
                        end
                    end
                    damagedArea:clear()
                end
            end
        end
    end
end

return Window
