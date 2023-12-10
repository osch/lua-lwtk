local lwtk = require"lwtk"

local Rect                = lwtk.Rect
local intersectRects      = Rect.intersectRects

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


function Compound.implement:addChild(child)
    rawset(self, #self + 1, child)
    child:_setParent(self)
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
