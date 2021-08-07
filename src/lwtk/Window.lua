local lwtk = require"lwtk"

local Area        = lwtk.Area

local ChildLookup     = lwtk.ChildLookup
local fillRect        = lwtk.draw.fillRect
local FocusHandler    = lwtk.FocusHandler
local getFocusHandler = lwtk.get.focusHandler
local getFocusedChild = lwtk.get.focusedChild
local getMeasures     = lwtk.layout.getMeasures
local callRelayout    = lwtk.layout.callRelayout
local setOuterMargins = lwtk.layout.setOuterMargins

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
local extract         = lwtk.extract

local childSizes      = lwtk.WeakKeysTable()

function Window:new(app, initParams)
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
    self.maxSizeFixed = false
    app:_addWindow(self)
    self.initParams = {
        title          = extract(initParams, "title"),
        parent         = extract(initParams, "parent"),
        size           = extract(initParams, "size"),
        minSize        = extract(initParams, "minSize"),
        maxSize        = extract(initParams, "maxSize"),
    }
    if initParams then
        local childList = {}
        for i = 1, #initParams do
            childList[i] = initParams[i]
            initParams[i] = nil
        end
        local maxSizeFixed = extract(initParams, "maxSizeFixed")
        self:setAttributes(initParams)
        if maxSizeFixed == nil then
            maxSizeFixed = self:getStyleParam("maxSizeFixed")
        end
        self.maxSizeFixed = (maxSizeFixed and true or false)
        for i = 1, #childList do
            local c = childList[i]
            self:addChild(c)
        end
    end
end

local function realize(self)
    local initParams = extract(self, "initParams")
    local app = getApp[self]
    local color = self.color
    if color == true then
        color = self:getStyleParam("BackgroundColor")
    end
    if color then
        color = math.floor(color.r * 0xff) * 0x10000
              + math.floor(color.g * 0xff) * 0x100
              + math.floor(color.b * 0xff)
    end
    self.view = app.world:newView {
        title           = initParams.title,
        parent          = initParams.parent,
        size            = initParams.size,
        minSize         = initParams.minSize,
        maxSize         = initParams.maxSize,
        resizable       = true, 
        dontMergeRects  = true,
        eventFunc       = {app._eventFunc, self},
        backgroundColor = color
    }
end


function Window:setOnClose(onClose)
    self.onClose = onClose
end

function Window:setInterceptMouseDown(interceptMouseDown)
    self.interceptMouseDown = interceptMouseDown
end

function Window:setInterceptKeyDown(interceptKeyDown)
    self.interceptKeyDown = interceptKeyDown
end

function Window:byId(id)
    return getChildLookup[self][id]
end

local function handleChildSizes(child, minW, minH, bestW, bestH, maxW, maxH,
                                       childTop, childRight, childBottom, childLeft)
    if minW then
        if maxW < -1 then
            maxW = bestW
        end
        if maxH < -1 then
            maxH = bestH
        end
    
        childTop    = childTop    or 0
        childRight  = childRight  or 0
        childBottom = childBottom or 0
        childLeft   = childLeft   or 0
    
        childSizes[child] = { minW, minH, bestW, bestH, maxW, maxH,
                              childTop, childRight, childBottom, childLeft }
    end
    return minW, minH, bestW, bestH, maxW, maxH,
           childTop, childRight, childBottom, childLeft
end


local function getChildSizes(self, child)
    local ms = childSizes[child]
    if ms then
        return ms[1], ms[2], ms[3], ms[4], ms[5], ms[6], ms[7], ms[8], ms[9], ms[10]
    else
        if child.getMeasures then
            return handleChildSizes(child, getMeasures(child))    -- luacheck: ignore 211/bestW 211/bestH
        end
    end
end

local function getMinMaxSizes(self, child)

    local minW, minH, _, _, maxW, maxH,
          childTop, childRight, childBottom, childLeft = getChildSizes(self, child)

    if minW then          
        minW  = childLeft + minW  + childRight  
        minH  = childTop  + minH  + childBottom 
    
        if maxW > 0 then
            maxW = childLeft  + maxW + childRight 
        end
        if maxH > 0 then
            maxH = childTop   + maxH + childBottom
        end
    end
    return minW, minH, maxW, maxH
end

local function adjustMinMaxSize(self, forceMaxSize)
    local minW, minH, maxW, maxH = 0, 0, 0, 0
    for i = 1, #self do
        local child = self[i]
        local mw, mh, MW, MH = getMinMaxSizes(self, child)
        if mw then
            if mw > minW then minW = mw end
            if mh > minH then minH = mh end
            if MW >= 0 then
                if maxW >= 0 and MW >= maxW then maxW = MW end
            else
                maxW = -1
            end
            if MH >= 0 then
                if maxH >= 0 and MH >= maxH then maxH = MH end
            else
                maxH = -1
            end
        end
    end
    self:setMinSize(minW, minH)

    if    (self.maxW and self.maxW >= 0 and minW >= self.maxW)
       or (self.maxH and self.maxH >= 0 and minH >= self.maxH)
    then
        forceMaxSize = true
    end
    if forceMaxSize or not self.maxSizeFixed then
        self:setMaxSize(maxW, maxH)
        self.maxW, self.maxH = maxW, maxH
    end
end

function Window:addChild(child)
    self[#self + 1] = child
    local focusHandler = FocusHandler(child)
    getApp[focusHandler] = getApp[self]
    getFocusHandler[child] = focusHandler
    child:_setParent(self)
    self:_clearChildLookup()
    local minW, minH, bestW, bestH, maxW, maxH,        -- luacheck: ignore 231/minH 231/maxW 231/maxH
          childTop, childRight, childBottom, childLeft
    if child.getMeasures then
        minW, minH, bestW, bestH, maxW, maxH, 
          childTop, childRight, childBottom, childLeft = handleChildSizes(child, getMeasures(child))
        if bestW > 0 and bestH > 0 then
            if child.visible then
                self:setSize(bestW + childLeft + childRight, bestH + childTop + childBottom)
            end
        end
    end
    if self.view and self:isVisible() then
        adjustMinMaxSize(self)
    end
    if self.w > 0 and self.h > 0 then
        if minW then
            setOuterMargins(child, childTop, childRight, childBottom, childLeft)
            child:_setFrame(childLeft, childTop, self.w - childLeft - childRight, self.h - childTop - childBottom)
        else
            child:_setFrame(0, 0, self.w, self.h)
        end
    end
    return child
end

function Window:setSize(w, h)
    if not h then
        h = w[2]
        w = w[1]
    end
    if self.view then
        self.view:setSize(w, h)
    else
        self.initParams.size = { w, h }
    end
end

function Window:getSize()
    if self.view then
        return self.view:getSize()
    else
        local s = self.initParams.size
        if s then
            return s[1], s[2]
        end 
    end
end

function Window:setMinSize(w, h)
    if not h then
        h = w[2]
        w = w[1]
    end
    if self.view then
        self.view:setMinSize(w, h)
    else
        self.initParams.minSize = { w, h }
    end
end

function Window:setMaxSize(w, h)
    if not h then
        h = w[2]
        w = w[1]
    end
    if self.view then
        self.view:setMaxSize(w, h)
    else
        self.initParams.maxSize = { w, h }
    end
end

function Window:getNativeHandle()
    if not self.view then
        realize(self)
    end
    return self.view:getNativeHandle()
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

function Window:setMaxSizeFixed(flag)
    flag = (flag and true or false)
    if flag ~= self.maxSizeFixed then
        if flag then
            processRelayout(self)
            adjustMinMaxSize(self)
            self.maxSizeFixed = true
        else
            self.maxSizeFixed = false
            processRelayout(self)
            adjustMinMaxSize(self)
        end
    end
end

function Window:show()
    processRelayout(self)
    if not self.view or not self.maxSizeFixed  then
        adjustMinMaxSize(self, self.view == nil)
    end
    if not self.view then
        realize(self)
    end
    self.view:show()
end

function Window:hide()
    if self.view then
        self.view:hide()
    end
end

function Window:isClosed()
    return self.view and self.view:isClosed()
end

function Window:close()
    if self.view and not self.view:isClosed() then
        self.view:close()
        getParent[self]:_removeWindow(self)
    end
end

function Window:getLayoutContext()
    return getApp[self]:getLayoutContext()
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
            if child.getMeasures then
                local _, _, _, _, _, _, 
                      childTop, childRight, childBottom, childLeft = getChildSizes(self, child)
                setOuterMargins(child, childTop, childRight, childBottom, childLeft)
                child:_setFrame(childLeft, childTop, w - childLeft - childRight, h - childTop - childBottom)
            else
                child:_setFrame(0, 0, w, h)
            end
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
                ctx:save()
                local cx, cy, cw, ch = child.x, child.y, child.w, child.h
                ctx:rectangle(cx, cy, cw, ch)
                ctx:clip()
                ctx:translate(cx, cy)
                child:_processDraw(ctx, cx, cy, cx, cy, cw, ch, self.exposedArea)
                ctx:restore()
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
    local interceptMouseDown = self.interceptMouseDown
    if interceptMouseDown then
        mx, my, button, modState = interceptMouseDown(self, mx, my, button, modState)
    end
    if mx then
        self.mouseX = mx
        self.mouseY = my
        self:_processMouseDown(mx, my, button, modState)
    end
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

function Window:_handleMap()
    self.mapped = true
    if self._grabFocus then
        self.view:grabFocus()
        self._grabFocus = nil
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

Window._handleClose = Window.requestClose

function Window:requestFocus()
    if self.view and self.mapped then
        self.view:grabFocus()
    else
        self._grabFocus = true
    end
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
                handleChildSizes(child, callRelayout(child))
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
    return neededRelayout
end

function Window:_processChanges()
    local neededRelayout = processRelayout(self) 
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
    return neededRelayout
end

function Window:_postProcessChanges()
    adjustMinMaxSize(self)
end

return Window
