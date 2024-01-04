local lwtk = require"lwtk"

local Rect                = lwtk.Rect
local intersectRects      = Rect.intersectRects

--[[
    Base for components that can have children.
]]
local Compound = lwtk.newMixin("lwtk.Compound", lwtk.Styleable.NO_STYLE_SELECTOR,

    function(Compound, Super)

        function Compound.override:_processChanges(x0, y0, cx, cy, cw, ch, damagedArea)
            Super._processChanges(self, x0, y0, cx, cy, cw, ch, damagedArea)
            local x, y, w, h = x0 + self.x, y0 + self.y, self.w, self.h
            cx, cy, cw, ch = intersectRects(x, y, w, h, cx, cy, cw, ch)
            for i = 1, #self do
                local child = self[i]
                if child._hasChanges then
                    child._hasChanges = false
                    child:_processChanges(x, y, cx, cy, cw, ch, damagedArea)
                end
            end
        end
        
    end
)


--[[
    Adds child.

    * *child*  - child object
    * *index*  - optional integer
    
    The *index* denotes the position where the child is inserted in the list.
    Negative values are possible, 1 means the last position of the current list.

    If *index* is not given or 0, the child is inserted at the end of the list.
    
    Returns the removed child object.
]]
function Compound.implement:addChild(child, index)
    if index then
        if index <= 0 then
            index = #self + index + 1
        end
        for i = #self, index, -1 do
            rawset(self, i + 1, rawget(self, i))
        end
    else
        index = #self + 1
    end
    rawset(self, index, child)
    child:_setParent(self)
    return child
end

--[[
    Removes child.

    * *child*  - child object or child index.
    
    Returns the removed child object.
]]
function Compound.implement:removeChild(child)
    if type(child) == "number" then
        local n = child
        if n <= 0 then
            n = #self + n + 1
        end
        child = rawget(self, n)
        for i = n, #self do
            rawset(self, i, rawget(self, i + 1))
        end
    else
        local found = false
        for i = 1, #self do
            if not found and rawget(self, i) == child then
                found = i
            end
            if found then
                rawset(self, i, rawget(self, i + 1))
            end
        end
    end
    if child then        
        child:_setParent(nil)
    end
    return child
end

--[[
    Discard child that should no longer be used.
    
    This function could be useful under Lua 5.1 which does not have ephemeron tables.
]]
function Compound.implement:discardChild(child)
    child = self:removeChild(child)
    if child then
        child:discard()
    end
    return child
end

function Compound.override:_processDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    local opacity = self:getStyleParam("Opacity") or 1
    if opacity < 1 then
        ctx:beginOpacity(opacity)
    end

    self:updateAnimation()

    local onDraw = self.onDraw
    if onDraw then
        onDraw(self, ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    end

    cx, cy, cw, ch = intersectRects(x0, y0, self.w, self.h, cx, cy, cw, ch)
    if cw > 0 and ch > 0 then
        for i = 1, #self do
            local child = self[i]
            if not child._ignored then
                local childX, childY = child.x, child.y
                local x, y, w, h = x0 + childX, y0 + childY, child.w, child.h
                local x1, y1, w1, h1 = intersectRects(x, y, w, h, cx, cy, cw, ch)
                if w1 > 0 and h1 > 0
                   and exposedArea:intersects(x1, y1, w1, h1) 
                then
                    ctx:save()
                    ctx:intersectClip(childX, childY, w, h)
                    ctx:translate(childX, childY)
                    child:_processDraw(ctx, x, y, x1, y1, w1, h1, exposedArea)
                    ctx:restore()
                end
            end
        end
    end

    if opacity < 1 then
        ctx:endOpacity()
    end
end

return Compound
