local lwtk = require"lwtk"

local drawBorder      = lwtk.draw.drawBorder
local fillRect        = lwtk.draw.fillRect
local getMeasures     = lwtk.layout.getMeasures
local setOuterMargins = lwtk.layout.setOuterMargins

local Control     = lwtk.newMixin("lwtk.Control")
Control.extra = {}


function Control.initClass(Control, Super) -- luacheck: ignore 431/Control
    
    local Super_addChild = lwtk.Compound.extra.addChild

    function Control:addChild(child)
        if self[1] then
            lwtk.errorf("object of type %s can only have one child", lwtk.type(self))
        end
        return Super_addChild(self, child)
    end
end    

function Control.extra:getMeasures()
    local child = self[1]
    if child then
        local p = self:getStyleParam("BorderPadding") or 0
        p = 2*p
        local minW, minH, bestW, bestH, maxW, maxH, 
                  childTop, childRight, childBottom, childLeft  = getMeasures(child)

        local mw = (childLeft or 0) + minW  + (childRight  or 0) + p
        local mh = (childTop  or 0) + minH  + (childBottom or 0) + p
        local bw = (childLeft or 0) + bestW + (childRight  or 0) + p
        local bh = (childTop  or 0) + bestH + (childBottom or 0) + p
                  
        if maxW >= 0 then
            maxW = (childLeft or 0) + maxW + (childRight  or 0) + p
        end
        if maxH >= 0 then
            maxH = (childTop  or 0) + maxH + (childBottom or 0) + p
        end
        return mw, mh, bw, bh, maxW, maxH
    end
end

function Control:onLayout(w, h)
    local child = self[1]
    if child then
        local p = self:getStyleParam("BorderPadding") or 0
        if child.getMeasures then
            local minW, minH, bestW, bestH, maxW, maxH,   -- luacheck: ignore 211/minW 211/minH 211/bestW 211/bestH 211/maxW 211/maxH
                      childTop, childRight, childBottom, childLeft  = getMeasures(child)
            local cx
            if childLeft and childLeft > p then
                cx = childLeft
            else
                cx = p
            end
            local cy
            if childTop and childTop > p then
                cy = childTop
            else
                cy = p
            end
            local dw
            if childRight and childRight > p then
                dw = childRight
            else
                dw = p
            end
            local cw = w - dw - cx
            if cw < 0 then 
                cw = 0
            end
            local dh
            if childBottom and childBottom > p then
                dh = childBottom
            else
                dh = p
            end
            local ch = h - dh - cy
            if ch < 0 then
                ch = 0
            end
            setOuterMargins(child, cy, dw, dh, cx)
            child:setFrame(cx, cy, cw, ch)
        else
            child:setFrame(p, p, w - 2*p, h - 2*p)
        end
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
