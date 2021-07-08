local lwtk = require"lwtk"

local Area        = lwtk.Area

local ChildLookup     = lwtk.ChildLookup
local fillRect        = lwtk.draw.fillRect
local FocusHandler    = lwtk.FocusHandler
local getFocusHandler = lwtk.get.focusHandler
local getFocusedChild = lwtk.get.focusedChild
local getMeasures     = lwtk.layout.getMeasures
local callRelayout    = lwtk.layout.callRelayout

local Super        = lwtk.MouseDispatcher(lwtk.KeyHandler(lwtk.Styleable(lwtk.Object)))
local Window       = lwtk.newClass("lwtk.Window", Super)

Window.triggerLayout = lwtk.Component.triggerLayout
Window.triggerRedraw = lwtk.Component.triggerRedraw
Window.getRoot       = lwtk.Component.getRoot
Window.childById     = lwtk.Group.childById

Window.color = true

local getParent       = lwtk.get.parent
local getStyle        = lwtk.get.style
local getApp          = lwtk.get.app
local getRoot         = lwtk.get.root
local getKeyBinding   = lwtk.get.keyBinding
local getFontInfos    = lwtk.get.fontInfos
local getChildLookup  = lwtk.get.childLookup

function Window:new(app, initParms)
    Super.new(self)
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
    getStyle[self]       = getStyle[app]
    Super.new(self)
    getChildLookup[self] = ChildLookup(self)
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

function Window:setOnClose(onClose)
    self.onClose = onClose
end

function Window:byId(id)
    return getChildLookup[self][id]
end

function Window:addChild(child)
    self[#self + 1] = child
    local focusHandler = FocusHandler(child)
    getApp[focusHandler] = getApp[self]
    getFocusHandler[child] = focusHandler
    child:_setParent(self)
    self:_clearChildLookup()
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
            self.minW, self.minH = mw, mh
        end
        if maxW > 0 or maxH > 0 then
            local mxw = maxW > 0 and ((childLeft or 0) + maxW + (childRight  or 0)) or -1
            local mxh = maxH > 0 and ((childTop  or 0) + maxH + (childBottom or 0)) or -1
            self.view:setMaxSize(mxw, mxh)
            self.maxW, self.maxH = mxw, mxh
        end
    end
    if self.w > 0 and self.h > 0 then
        child:_setFrame(0, 0, self.w, self.h)
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
        self._hasChanges = true
        local p = getParent[self]
        if p then p._hasChanges = true end
    end
end

local processRelayout

function Window:show()
    processRelayout(self)
    self.view:show()
end

function Window:hide()
    self.view:hide()
end

function Window:isClosed()
    return self.view:isClosed()
end

function Window:close()
    if not self.view:isClosed() then
        self.view:close()
        getParent[self]:_removeWindow(self)
    end
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
            if not child._ignored then
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
    self:_processMouseEnter(mx, my)
end

function Window:_handleMouseMove(mx, my)
    self.mouseX = mx
    self.mouseY = my
    self:_processMouseMove(self.mouseEntered, mx, my)
end

function Window:_handleMouseLeave(mx, my)
    self.mouseX = mx
    self.mouseY = my
    self.mouseEntered = false
    self:_processMouseLeave(mx, my)
end

function Window:_handleMouseDown(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    self:_processMouseDown(mx, my, button, modState)
end

function Window:_handleMouseUp(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    self:_processMouseUp(self.mouseEntered, mx, my, button, modState)
end

local function adjustFocusedChild(self, focusedChild)
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            if focusedChild and focusedChild ~= child then
                getFocusHandler[focusedChild]:_handleFocusOut()
            end
            getFocusedChild[self] = child
            getFocusHandler[child]:_handleFocusIn()
            break
        end
    end
end

function Window:_handleFocusIn()
    self.hasFocus = true
    self:resetKeyHandling()
    local focusedChild = getFocusedChild[self]
    adjustFocusedChild(self, focusedChild)
end

function Window:_handleFocusOut()
    self.hasFocus = false
    self:resetKeyHandling()
    local focusedChild = getFocusedChild[self]
    if focusedChild then
        getFocusHandler[focusedChild]:_handleFocusOut()
        getFocusedChild[self] = false
    end
end


function Window:requestClose()
    local onClose = self.onClose
    if onClose then
        onClose(self)
    else
        self:close()
    end
end

function Window:requestFocus()
    self.view:grabFocus()
end

function Window:_clearChildLookup() 
    ChildLookup.clear(getChildLookup[self])
end

function processRelayout(self)
    local focusedChild = getFocusedChild[self]
    if focusedChild and not focusedChild.visible and self.hasFocus then
        adjustFocusedChild(self, focusedChild)
    end
    local neededRelayout = self._needsRelayout 
    if neededRelayout then
        self._needsRelayout = false
        for i = 1, #self do
            local child = self[i]
            if child._needsRelayout then
                local minW, minH, bestW, bestH, maxW, maxH,                              -- luacheck: ignore 211/maxW 211/maxH
                      childTop, childRight, childBottom, childLeft = callRelayout(child)
                if minW then
                    local mw = (childLeft or 0) + minW  + (childRight  or 0)
                    local mh = (childTop  or 0) + minH  + (childBottom or 0)
                    local bw = (childLeft or 0) + bestW + (childRight  or 0)
                    local bh = (childTop  or 0) + bestH + (childBottom or 0)
                    if bw > 0 and bh > 0 then
                        if self.view:isVisible() then
                            if not self.minW or (mw > self.minW or mh > self.minH) then
                                self.view:setMinSize(mw, mh)
                                self.minW, self.minH = mw, mh
                            end
                        else
                            self.view:setMinSize(mw, mh)
                            self.view:setSize(bw, bh)
                            self.minW, self.minH = mw, mh
                        end
                    end
                end
            end
        end
        assert(not self._needsRelayout)
    end
    if neededRelayout or self._positionsChanged then
        self._positionsChanged = false
        if self.mouseEntered then
            local mx, my = self.mouseX, self.mouseY
            if mx then
                self:_handleMouseMove(mx, my)
            end
        end
    end
end

function Window:_processChanges()
    processRelayout(self)
    self._hasChanges = false
    for i = 1, #self do
        local child = self[i]
        if child._hasChanges then
            child._hasChanges = false
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
