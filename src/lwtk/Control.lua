local lwtk = require"lwtk"

local drawBorder = lwtk.draw.drawBorder
local fillRect   = lwtk.draw.fillRect
local Compound   = lwtk.Compound
local addChild   = Compound.addChild

local Super      = lwtk.Widget
local Control    = lwtk.newClass("lwtk.Control", Super)

Control:implementFrom(Compound)

function Control:new(initParams)
    Super.new(self, initParams)
end

function Control:addChild(child)
    if self[1] then
        errorf("object of type %s can only have one child", Control)
    end
    return Compound.addChild(self, child)
end


function Control:onLayout(w, h)
    local child = self[1]
    if child then
        local p = self:getStyleParam("BorderPadding") or 0
        child:setFrame(p, p, w - 2*p, h - 2*p)
    end
end

function Control:onDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    local background = self:getStyleParam("BackgroundColor")
    local color      = self:getStyleParam("BorderColor")
    local b          = self:getStyleParam("BorderSize") or 0
    local p          = self:getStyleParam("BorderPadding") or 0
    local w, h = self.w, self.h
    if background then
        fillRect(ctx, background, 0, 0, w, h)
    end
    local d = (p > b) and p or b
    if     b > 0 
       and color
       and (background or (p > 0 and exposedArea:intersectsBorder(x0, y0, w, h, d)))
    then
        if b > 0 and color then
            drawBorder(ctx, color, 
                            b,
                            0, 0, w, h)
        end
    end
end

return Control
