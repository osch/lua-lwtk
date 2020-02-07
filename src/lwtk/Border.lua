local lwtk = require"lwtk"

local errorf     = lwtk.errorf
local drawBorder = lwtk.draw.drawBorder
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
        local b = self:getStyleParam("BorderWidth") or 0
        child:setFrame(b, b, w - 2*b, h - 2*b)
    end
end

function Border:onDraw(ctx)
    drawBorder(ctx, self:getStyleParam("Color"), 
                    self:getStyleParam("BorderWidth") or 0,
                    0, 0, self.w, self.h)
end

return Border
