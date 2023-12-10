local lwtk = require("lwtk")

local rawget = rawget

local getMeasures     = lwtk.layout.getMeasures
local getOuterMargins = lwtk.layout.getOuterMargins
local setOuterMargins = lwtk.layout.setOuterMargins

local Super        = lwtk.Group
local Space        = lwtk.newClass("lwtk.Space", Super)

Space:declare(
    "unlimited"
)

function Space:setUnlimited(unlimited)
    self.unlimited = unlimited
end

function Space.override:addChild(child)
    if rawget(self, 1) then
        lwtk.errorf("object of type %s can only have one child", lwtk.type(self))
    end
    return Super.addChild(self, child)
end

function Space.implement:getMeasures()
    local child = rawget(self, 1)
    local unlimited = self.unlimited and -1 or -2
    if child then
        local minW, minH, bestW, bestH, _, _, 
                  childTop, childRight, childBottom, childLeft  = getMeasures(child)
        return minW, minH, bestW, bestH, unlimited, unlimited, 
                  childTop, childRight, childBottom, childLeft
    else
        return 0, 0, 0, 0, unlimited, unlimited
    end
end

function Space.implement:onLayout(w, h)
    local child = rawget(self, 1)
    if child then
        local tM, rM, bM, lM = getOuterMargins(self)
        if child.getMeasures then
            local _, _, _, _, maxW, maxH, 
                      childTop, childRight, childBottom, childLeft  = getMeasures(child)
            local cx
            if childLeft and  childLeft > lM then
                cx = childLeft - lM
                lM = childLeft
            else
                cx = 0
            end
            local cy
            if childTop and  childTop > tM then
                cy = childTop - tM
                tM = childTop
            else
                cy = 0
            end
            local dw
            if childRight and  childRight > rM then
                dw = childRight - rM
                rM = childRight
            else
                dw = 0
            end
            local dh
            if childBottom and  childBottom > bM then
                dh = childBottom - bM
                bM = childBottom
            else
                dh = 0
            end
            local cw = w - dw - cx
            if cw < 0 then 
                cw = 0
            end
            local ch = h - dh - cy
            if ch < 0 then
                ch = 0
            end
            if maxW >= 0 and cw > maxW then
                dw = cw - maxW
                cx = cx + dw/2
                cw = cw - dw
                lM = lM + dw
                rM = rM + dw
            end
            if maxH >= 0 and ch > maxH then
                dh = ch - maxH
                cy = cy + dh/2
                ch = ch - dh
                tM = tM + dh
                bM = bM + dh
            end
            setOuterMargins(child, tM, rM, bM, lM)
            child:setFrame(cx, cy, cw, ch)
        else
            setOuterMargins(child, tM, rM, bM, lM)
            child:setFrame(0, 0, w, h)
        end
    end
end

return Space
