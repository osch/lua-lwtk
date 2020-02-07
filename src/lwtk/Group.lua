local lwtk = require"lwtk"

local call        = lwtk.call
local Object      = lwtk.Object
local Rect        = lwtk.Rect
local Styleable   = lwtk.Styleable
local Super       = lwtk.Widget
local ChildLookup = lwtk.ChildLookup
local Group       = lwtk.newClass("lwtk.Group", Super)

local intersectRects      = Rect.intersectRects

local getParent         = lwtk.get.parent
local getWrappingParent = lwtk.get.wrappingParent
    
function Group:new(initParams)
    self.child = ChildLookup(self)
    local childList = {}
    self.mouseChildButtons = {}
    if initParams then
        for i = 1, #initParams do
            childList[#childList + 1] = initParams[i]
            initParams[i] = nil
        end
    end
    Super.new(self, initParams)
    for i = 1, #childList do
        self:addChild(childList[i])
    end
end

function Group:_clearChildLookup() 
    if self.child[0] then
        self.child = ChildLookup(self)
    end
    local p = getParent[self]
    if p then
        p:_clearChildLookup()
    end
end

function Group:addChild(child)
    local myChild = getWrappingParent[child] or child
    self[#self + 1] = myChild
    myChild:_setParent(self)
    self:_clearChildLookup()
    return child
end

function Group:_processChanges(x0, y0, cx, cy, cw, ch, damagedArea)
    Super._processChanges(self, x0, y0, cx, cy, cw, ch, damagedArea)
    local x, y, w, h = x0 + self.x, y0 + self.y, self.w, self.h
    local cx, cy, cw, ch = intersectRects(x, y, w, h, cx, cy, cw, ch)
    for _, child in ipairs(self) do
        if child.hasChanges then
            child.hasChanges = false
            child.positionsChanged = false 
            child:_processChanges(x, y, cx, cy, cw, ch, damagedArea)
        end
    end
end

function Group:_processDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)

    local onDraw = self.onDraw
    if onDraw then
        self:updateAnimation()
        onDraw(self, ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    end

    local cx, cy, cw, ch = intersectRects(x0, y0, self.w, self.h, cx, cy, cw, ch)
    if cw > 0 and ch > 0 then
        for _, child in ipairs(self) do
            if child.visible then
                local childX, childY = child.x, child.y
                local x, y, w, h = x0 + childX, y0 + childY, child.w, child.h
                local x1, y1, w1, h1 = intersectRects(x, y, w, h, cx, cy, cw, ch)
                if w1 > 0 and h1 > 0
                   and exposedArea:intersects(x1, y1, w1, h1) 
                then
                    ctx:save()
                    ctx:rectangle(childX, childY, w, h)
                    ctx:clip()
                    ctx:translate(childX, childY)
                    child:_processDraw(ctx, x, y, x1, y1, w1, h1, exposedArea)
                    ctx:restore()
                end
            end
        end
    end
end

local function findChildAt(self, mx, my)
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            local x, y, w, h = child.x, child.y, child.w, child.h
            if     x <= mx and mx < x + w 
               and y <= my and my < y + h 
            then
                return child
            end
        end
    end
end

local function processMouseMove(self, entered, mx, my)
    
    self.mouseX = mx
    self.mouseY = my
    
    local uChild = entered and findChildAt(self, mx, my)
    
    local bChild = self.mouseButtonChild
    if bChild then
        if bChild ~= self then
            local x, y = bChild.x, bChild.y
            if bChild == uChild then
                if self.mouseHoverChild ~= bChild then
                    self.mouseHoverChild = bChild
                    bChild:_processMouseEnter(mx - x, my - y)
                else
                    bChild:_processMouseMove(entered, mx - x, my - y)
                end
            else
                if self.mouseHoverChild == bChild then
                    self.mouseHoverChild = nil
                    bChild:_processMouseLeave(mx - x, my - y)
                else
                    bChild:_processMouseMove(false, mx - x, my - y)
                end
            end
        else
            if entered then
                if self.mouseHoverChild == self then
                    call("onMouseMove", self, mx, my)
                else
                    self.mouseHoverChild = self
                    local onMouseEnter = self.onMouseEnter
                    if onMouseEnter then
                        onMouseEnter(self, mx, my)
                    else
                        call("onMouseMove", self, mx, my)
                    end
                end
            else
                if self.mouseHoverChild == self then
                    self.mouseHoverChild = nil
                    self:_processMouseLeave(mx, my)
                else
                    call("onMouseMove", self, mx, my)
                end
            end
        end
    else
        if uChild then
            local x, y = uChild.x, uChild.y
            local hChild = self.mouseHoverChild
            if hChild ~= uChild then
                if hChild then
                    if hChild ~= self then
                        hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
                    else
                        call("onMouseLeave", self, mx, my)
                    end
                end
                self.mouseHoverChild = uChild
                local mcx, mcy = mx - x, my - y
                self.mouseHoverChildX = mcx
                self.mouseHoverChildY = mcy
                uChild:_processMouseEnter(mx - x, my - y)
            else
                local mcx, mcy = mx - x, my - y
                if self.mouseHoverChildX ~= mcx or self.mouseHoverChildY ~= mcy then
                    self.mouseHoverChildX = mcx
                    self.mouseHoverChildY = mcy
                    uChild:_processMouseMove(entered, mcx, mcy)
                end
            end
        else
            local hChild = self.mouseHoverChild
            local justEntered
            if hChild ~= self then
                justEntered = entered
                if hChild then
                    hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
                end
                self.mouseHoverChild = self
            end
            if justEntered then
                local onMouseEnter = self.onMouseEnter
                if onMouseEnter then
                    onMouseEnter(self, mx, my)
                else
                    call("onMouseMove", self, mx, my)
                end
            else
                call("onMouseMove", self, mx, my)
            end
        end
    end
end

function Group:_processMouseEnter(mx, my)
    processMouseMove(self, true, mx, my)
end

function Group:_processMouseMove(mouseEntered, mx, my)
    processMouseMove(self, mouseEntered, mx, my)
end

function Group:_processMouseLeave(mx, my)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        if bChild ~= self then
            bChild:_processMouseLeave(mx - bChild.x, my - bChild.y)
        else
            call("onMouseLeave", self, mx, my)
        end
    else
        local hChild = self.mouseHoverChild
        if hChild then
            self.mouseHoverChild = nil
            if hChild ~= self then
                hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
            else
                call("onMouseLeave", hChild, mx, my)
            end
        end
    end
end

function Group:_processMouseDown(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        self.mouseChildButtons[button] = true
        if self ~= bChild then
            return bChild:_processMouseDown(mx - bChild.x, my - bChild.y,
                                            button, modState)
        else
            return call("onMouseDown", self, mx, my, button, modState)
        end
    else
        local onMouseDown = self.onMouseDown
        if onMouseDown then
            return onMouseDown(self, mx, my, button, modState)
        else
            local uChild = findChildAt(self, mx, my)
            if uChild then
                local x, y = uChild.x, uChild.y
                self.mouseButtonChild = uChild
                self.mouseChildButtons[button] = true
                return uChild:_processMouseDown(mx - x, my - y, button, modState)
            else
                self.mouseButtonChild = self
                self.mouseChildButtons[button] = true
                return call("onMouseDown", self, mx, my, button, modState)
            end
        end
    end
end

local function hasButtons(buttons)
    for k, v in pairs(buttons) do
        if v then return true end
    end
end

function Group:_processMouseUp(mouseEntered, mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        local buttons = self.mouseChildButtons
        buttons[button] = false
        local uChild = mouseEntered and findChildAt(self, mx, my)
        if self ~= bChild then
            bChild:_processMouseUp(uChild == bChild, mx - bChild.x, my - bChild.y, button, modState)
        else
            call("onMouseUp", self, mx, my, button, modState)
        end
        if not hasButtons(buttons) then
            self.mouseButtonChild = nil
        end
        self:_processMouseMove(mouseEntered, mx, my)
    end
end

return Group
