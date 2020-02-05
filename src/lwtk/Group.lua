local lwtk = require"lwtk"

local call        = lwtk.call
local Object      = lwtk.Object
local Rect        = lwtk.Rect
local Styleable   = lwtk.Styleable
local Super       = lwtk.Widget
local ChildLookup = lwtk.ChildLookup
local Group       = lwtk.newClass("lwtk.Group", Super)

local intersectRects      = Rect.intersectRects

local getParent = lwtk.get.parent
    
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
        self:newChild(childList[i])
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

function Group:newChild(child)
    self[#self + 1] = child
    child:_setParent(self)
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

local function processMouseMove(self, entered, mx, my)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        local x, y, w, h = bChild.x, bChild.y, bChild.w, bChild.h
        if     x <= mx and mx < x + w 
           and y <= my and my < y + h 
        then
            if self.mouseHoverChild == bChild then
                bChild:_processMouseMove(mx - bChild.x, my - bChild.y)
            else
                self.mouseHoverChild = bChild
                bChild:_processMouseEnter(mx - bChild.x, my - bChild.y)
            end
        else
            if self.mouseHoverChild == bChild then
                self.mouseHoverChild = nil
                bChild:_processMouseLeave(mx - bChild.x, my - bChild.y)
            else
                bChild:_processMouseMove(mx - bChild.x, my - bChild.y)
            end
        end
    else
        for i = #self, 1, -1 do
            local child = self[i]
            if child.visible then
                local x, y, w, h = child.x, child.y, child.w, child.h
                if     x <= mx and mx < x + w 
                   and y <= my and my < y + h 
                then
                    local hChild = self.mouseHoverChild
                    if hChild ~= child then
                        if hChild then
                            if hChild ~= self then
                                hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
                            else
                                call("onMouseLeave", self, mx, my)
                            end
                        end
                        self.mouseHoverChild = child
                        local mcx, mcy = mx - x, my - y
                        self.mouseHoverChildX = mcx
                        self.mouseHoverChildY = mcy
                        child:_processMouseEnter(mx - x, my - y)
                    else
                        local mcx, mcy = mx - x, my - y
                        if self.mouseHoverChildX ~= mcx or self.mouseHoverChildY ~= mcy then
                            self.mouseHoverChildX = mcx
                            self.mouseHoverChildY = mcy
                            child:_processMouseMove(mcx, mcy)
                        end
                    end
                    return
                end
            end
        end
        local hChild = self.mouseHoverChild
        if hChild ~= self then
            entered = true
            if hChild then
                hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
            end
            self.mouseHoverChild = self
        end
        if entered then
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

function Group:_processMouseEnter(mx, my)
    processMouseMove(self, true, mx, my)
end

function Group:_processMouseMove(mx, my)
    processMouseMove(self, false, mx, my)
end

function Group:_processMouseLeave(mx, my)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        bChild:_processMouseLeave(mx - bChild.x, my - bChild.y)
    else
        local hChild = self.mouseHoverChild
        if hChild then
            self.mouseHoverChild = nil
            if hChild ~= self then
                hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
            else
                call("onMouseLeave", hChild, my, my)
            end
        end
    end
end

function Group:_processMouseDown(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        local handled = bChild:_processMouseDown(mx - bChild.x, my - bChild.y,
                                                 button, modState)
        if handled then
            self.mouseChildButtons[button] = true
        end
        return handled
    else
        local onMouseDown = self.onMouseDown
        if onMouseDown then
            onMouseDown(self, mx, my, button, modState)
            return true
        else
            for i = #self, 1, -1 do
                local child = self[i]
                if child.visible then
                    local x, y, w, h = child.x, child.y, child.w, child.h
                    if     x <= mx and mx < x + w
                       and y <= my and my < y + h
                    then
                        if child:_processMouseDown(mx - x, my - y, button, modState) then
                            self.mouseChildButtons[button] = true
                            self.mouseButtonChild = child
                            return true
                        else
                            return false
                        end
                    end
                end
            end
        end
    end
end

local function hasButtons(buttons)
    for k, v in pairs(buttons) do
        if v then return true end
    end
end

function Group:_processMouseUp(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        local buttons = self.mouseChildButtons
        buttons[button] = false
        bChild:_processMouseUp(mx - bChild.x, my - bChild.y, button, modState)
        if not hasButtons(buttons) then
            self.mouseButtonChild = nil
        end
        self:_processMouseMove(mx, my)
    end
end

return Group
