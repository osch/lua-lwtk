local lwtk = require"lwtk"

local Rect                = lwtk.Rect
local intersectRects      = Rect.intersectRects
local getWrappingParent   = lwtk.get.wrappingParent

local Compound = lwtk.newMixin("lwtk.Compound", lwtk.Styleable.NO_STYLE_SELECTOR)

Compound.extra = {}

function Compound.initClass(Compound, Super)  -- luacheck: ignore 431/Compound

    function Compound:_processChanges(x0, y0, cx, cy, cw, ch, damagedArea)
        Super._processChanges(self, x0, y0, cx, cy, cw, ch, damagedArea)
        local x, y, w, h = x0 + self.x, y0 + self.y, self.w, self.h
        cx, cy, cw, ch = intersectRects(x, y, w, h, cx, cy, cw, ch)
        for _, child in ipairs(self) do
            if child._hasChanges then
                child._hasChanges = false
                child:_processChanges(x, y, cx, cy, cw, ch, damagedArea)
            end
        end
    end
    
end


function Compound.extra:addChild(child)
    local myChild = getWrappingParent[child] or child
    self[#self + 1] = myChild
    myChild:_setParent(self)
    return child
end

function Compound:_processDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    local opacity = self:getStyleParam("Opacity") or 1
    if opacity < 1 then
        ctx:push_group()
    end

    self:updateAnimation()

    local onDraw = self.onDraw
    if onDraw then
        onDraw(self, ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    end

    cx, cy, cw, ch = intersectRects(x0, y0, self.w, self.h, cx, cy, cw, ch)
    if cw > 0 and ch > 0 then
        for _, child in ipairs(self) do
            if not child._ignored then
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

    if opacity < 1 then
        ctx:pop_group_to_source()
        ctx:paint_with_alpha(opacity)
    end
end

return Compound
