local lwtk = require("lwtk")

local drawBorder      = lwtk.draw.drawBorder
local fillRect        = lwtk.draw.fillRect
local getMeasures     = lwtk.layout.getMeasures
local setOuterMargins = lwtk.layout.setOuterMargins


local LayoutFrame       = lwtk.newMixin("lwtk.LayoutFrame", lwtk.Styleable.NO_STYLE_SELECTOR)
      LayoutFrame.extra = {}

function LayoutFrame.initClass(LayoutFrame, Super)  -- luacheck: ignore 431/LayoutFrame

    local Super_addChild = Super.addChild

    function LayoutFrame:addChild(child)
        if self[1] then
            lwtk.errorf("object of type %s can only have one child", lwtk.type(self))
        end
        return Super_addChild(self, child)
    end

end

function LayoutFrame.extra:getMeasures()
    local child = self[1]
    if child then
        local p = self:getStyleParam("BorderPadding") or 0
        p = 2*p
        local minW, minH, bestW, bestH, maxW, maxH, 
                  childTop, childRight, childBottom, childLeft  = getMeasures(child)


        local childHMargin  = (childLeft or 0) + (childRight or 0)
        if p > childHMargin then
            childHMargin = p
        end
        local childVMargin  = (childTop or 0) + (childBottom or 0)
        if p > childVMargin then
            childVMargin = p
        end
        
        
        minW  = minW  + childHMargin
        minH  = minH  + childVMargin
        bestW = bestW + childHMargin
        bestH = bestH + childVMargin
                  
        if maxW >= 0 then
            maxW = maxW + childHMargin
        end
        if maxH >= 0 then
            maxH = maxH + childVMargin
        end

        return minW, minH, bestW, bestH, maxW, maxH
    end
end

function LayoutFrame:onLayout(w, h)
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

function LayoutFrame:onDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)
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

return LayoutFrame

