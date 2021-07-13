local lwtk = require("lwtk")

local getMeasures     = lwtk.layout.getMeasures
local getOuterMargins = lwtk.layout.getOuterMargins
local setOuterMargins = lwtk.layout.setOuterMargins
local fillRect        = lwtk.draw.fillRect

local Super           = lwtk.Group
local ViewSwitcher    = lwtk.newClass("lwtk.ViewSwitcher", Super)

function ViewSwitcher:onDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)
    local background = self:getStyleParam("BackgroundColor")
    if background then
        fillRect(ctx, background, 0, 0, self.w, self.h)
    end
end

function ViewSwitcher:onLayout(w, h)
    local topMargin, rightMargin, bottomMargin, leftMargin = getOuterMargins(self)
    for i = 1, #self do
        local child = self[i]
        setOuterMargins(child, topMargin, rightMargin, bottomMargin, leftMargin)
        child:setFrame(0, 0, w, h)
    end
end

function ViewSwitcher:getMeasures()

    local minW, minH, bestW, bestH, maxW, maxH, 
          childTop, childRight, childBottom, childLeft
        
    for i = 1, #self do
        local child = self[i]
        if not minW then
            minW, minH, bestW, bestH, maxW, maxH, 
              childTop, childRight, childBottom, childLeft = getMeasures(child)
        else
            local minW2, minH2, bestW2, bestH2, maxW2, maxH2, 
              childTop2, childRight2, childBottom2, childLeft2 = getMeasures(child)
            if minW2  > minW  then minW  = minW2  end
            if minH2  > minH  then minH  = minH2  end
            if bestW2 > bestW then bestW = bestW2 end
            if bestH2 > bestH then bestH = bestH2 end
            if maxW >= 0 then
                if maxW2 == -1 then 
                    maxW = -1 
                elseif maxW2 > maxW then
                    maxW = maxW2
                end
            end    
            if maxH >= 0 then
                if maxH2 == -1 then 
                    maxH = -1 
                elseif maxH2 > maxH then
                    maxH = maxH2
                end
                if childTop2    > childTop    then childTop    = childTop2    end
                if childRight2  > childRight  then childRight  = childRight2  end
                if childBottom2 > childBottom then childBottom = childBottom2 end
                if childLeft2   > childLeft   then childLeft   = childLeft2   end
            end    
        end
    end
    if minW then    
        return minW, minH, bestW, bestH, maxW, maxH, 
              childTop, childRight, childBottom, childLeft
    else
        return 0, 0, 0, 0, 0, 0, 
              0, 0, 0, 0
    end
end

function ViewSwitcher:addChild(child)
    local childVisible = child.visible
    if childVisible then
        for i = 1, #self do
            local c = self[i]
            c:setVisible(false)
        end
    end
    if childVisible then
        child:setVisible(false)
    end
    local topMargin, rightMargin, bottomMargin, leftMargin = getOuterMargins(self)
    setOuterMargins(child, topMargin, rightMargin, bottomMargin, leftMargin)
    Super.addChild(self, child)
    child:setFrame(0, 0, self.w, self.h)
    if childVisible then
        child:setVisible(true)
    end
end

function ViewSwitcher:showChild(child)
    local t = type(child)
    local index
    if t == "number" then
        index = t
    elseif t == "string" then
        for i = #self, 1, -1 do
            local c = self[i]
            if c.id == child then
                index = i
                break
            end
        end
    else
        for i = #self, 1, -1 do
            local c = self[i]
            if c == child then
                index = i
                break
            end
        end        
        if not index then
            child:setVisible(false)
            local topMargin, rightMargin, bottomMargin, leftMargin = getOuterMargins(self)
            setOuterMargins(child, topMargin, rightMargin, bottomMargin, leftMargin)
            Super.addChild(self, child)
            index = #self
        end
    end
    for i = 1, #self do
        if i == index then
            self[i]:setVisible(true)
        else
            self[i]:setVisible(false)
        end
    end
end

return ViewSwitcher
