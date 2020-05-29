local lwtk = require"lwtk"

local errorf     = lwtk.errorf
local drawBorder = lwtk.draw.drawBorder
local fillRect   = lwtk.draw.fillRect
local Super      = lwtk.Group
local Border     = lwtk.newClass("lwtk.Border", Super)

function Border:new(initParams)
    Super.new(self, initParams)
end

function Border:addChild(child)
    if self[1] then
        errorf("object of type %s can only have one child", Border)
    end
    Super.addChild(self, child)
end

function Border:onLayout(w, h)
    local child = self[1]
    if child then
        local p = self:getStyleParam("BorderPadding") or 0
        child:setFrame(p, p, w - 2*p, h - 2*p)
    end
end

function Border:onDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    local background = self:getStyleParam("BackgroundColor")
    local color      = self:getStyleParam("BorderColor")
    local b          = self:getStyleParam("BorderSize") or 0
    local p          = self:getStyleParam("BorderPadding") or 0
    local w, h = self.w, self.h
    if p > 0 and exposedArea:intersectsBorder(x0, y0, w, h, p) then
        if background then
            --fillRect(ctx, background, b, b, w - 2*b, h - 2*b)
            fillRect(ctx, background, 0, 0, w, h)
        end
        if b > 0 and color then
            drawBorder(ctx, color, 
                            b,
                            0, 0, w, h)
        end
    end
end

return Border
