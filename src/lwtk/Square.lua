local lwtk = require("lwtk")

local getOuterMargins = lwtk.layout.getOuterMargins
local setOuterMargins = lwtk.layout.setOuterMargins

local Super  = lwtk.Group
local Square = lwtk.newClass("lwtk.Square", Super)

function Square.override:addChild(child, index)
    if self[1] or index then
        lwtk.errorf("object of type %s can only have one child", lwtk.type(self))
    end
    return Super.addChild(self, child)
end

function Square.implement:getMeasures()
    local child = self[1]
    local topMargin, rightMargin, bottomMargin, leftMargin
    if child then
        topMargin    = child:getStyleParam("topMargin")    
        rightMargin  = child:getStyleParam("rightMargin")  
        bottomMargin = child:getStyleParam("bottomMargin") 
        leftMargin   = child:getStyleParam("leftMargin")   
    end
    local minS = self:getStyleParam("MinSize")
    local    S = self:getStyleParam("Size")    or minS
    local maxS = self:getStyleParam("MaxSize") or -1
    if not minS then
        minS = S
    end
    if S then
        return minS, minS, S, S, maxS, maxS, topMargin, rightMargin, bottomMargin, leftMargin
    end
    return 0, 0, 0, 0, 0, 0
end

function Square.implement:onLayout(w, h)
    local child = self[1]
    if child then
        local tM, rM, bM, lM = getOuterMargins(self)
        local s
        if w > h then
            s = h
            local dw = (w-s)/2
            setOuterMargins(child, tM, rM+dw, bM, lM+dw)
            child:setFrame(dw, 0, s, s)
        else
            s = w
            local dh = (h-s)/2
            setOuterMargins(child, tM+dh, rM, bM+dh, lM)
            child:setFrame(0, dh, s, s)
        end
    end
end

return Square
