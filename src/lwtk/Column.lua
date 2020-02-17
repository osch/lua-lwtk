local lwtk = require"lwtk"

local floor      = math.floor
local Super      = lwtk.Group
local Column     = lwtk.newClass("lwtk.Column", Super)

local setOuterMargins = lwtk.layout.setOuterMargins
local getOuterMargins = lwtk.layout.getOuterMargins
local getMeasures     = lwtk.layout.getMeasures

local function rotateMargins(top, right, bottom, left)
    return left, bottom, right, top
end

local function getChildMeasures(child, isRow)
    local minW, minH, bestW, bestH, maxW, maxH,
          childTop, childRight, childBottom, childLeft = getMeasures(child)
    if isRow then
        minW, minH, bestW, bestH, maxW, maxH = minH, minW, bestH, bestW, maxH, maxW
        childTop, childRight, childBottom, childLeft = rotateMargins(childTop, childRight, childBottom, childLeft)
    end
    return minW, minH, bestW, bestH, maxW, maxH,
           childTop, childRight, childBottom, childLeft
end


function Column._implementColumn(class, isRow)

    local function getMeasures(self, topMargin, rightMargin, bottomMargin, leftMargin)
        
        local n = #self
        
        local bestWidth = 0
        for i = 1, n do
            local child = self[i]
            local minW, minH, bestW, bestH, maxW, maxH,
                  childTop, childRight, childBottom, childLeft = getChildMeasures(child, isRow)
            if bestW > bestWidth then bestWidth = bestW end
        end
        
        local topMargin    = nil
        local bottomMargin = nil
        local leftMargin   = nil
        local rightMargin  = nil
    
        for i = 1, n do
            local child = self[i]
            local minW, minH, bestW, bestH, maxW, maxH,
                  childTop, childRight, childBottom, childLeft = getChildMeasures(child, isRow)
            if not topMargin and childTop and bestH > 0 then 
                topMargin = childTop
            end
            if bestH > 0 and childBottom then
                bottomMargin = childBottom
            end
            if bestW > 0 then
                local w = (childLeft or 0) + bestW + (childRight or 0)
                if w > bestWidth then
                    local dw = w - bestWidth
                    if childLeft  and (not leftMargin  or childLeft  < leftMargin)  then 
                        leftMargin  = childLeft  
                    end
                    if childRight and (not rightMargin or childRight < rightMargin) then 
                        rightMargin = childRight 
                    end
                end
            end
        end
        topMargin    = topMargin or 0
        rightMargin  = rightMargin or 0
        bottomMargin = bottomMargin or 0
        leftMargin   = leftMargin or 0
        
        local flexCount = 0
        local unlmCount1 = 0
        local unlmCount2 = 0
        
        local minHeight = 0
        local bestHeight = 0
        local maxHeight = 0
        local maxContentHeight = 0
        
        local minWidth = 0
        local maxWidth = 0
        
        local prevBottom
        
        for i = 1, n do
            local child = self[i]
            local minW, minH, bestW, bestH, maxW, maxH,
                  childTop, childRight, childBottom, childLeft = getChildMeasures(child, isRow)
            
            local dw = 0
            if childLeft and childLeft > leftMargin then
                dw = childLeft - leftMargin
            end
            if childRight and childRight > rightMargin then
                dw = dw + childRight - rightMargin
            end
            if dw > 0 then 
                minW = minW + dw
                bestW = bestW + dw
                if maxW >= 0 then maxW = maxW + dw end
            end
            if minW  > minWidth  then minWidth  = minW  end
            if bestW > bestWidth then bestWidth = bestW end
            
            if maxWidth >= 0 then
                if maxW >= 0 then
                    if maxW > maxWidth then maxWidth = maxW end
                elseif maxW == -1 then
                    maxWidth = -1
                elseif bestW > maxWidth then 
                    maxWidth = bestW 
                end
            end
            if i > 1 then
                if childTop and prevBottom and childTop > prevBottom then 
                    minHeight  =  minHeight + childTop - prevBottom
                    bestHeight = bestHeight + childTop - prevBottom
                    maxHeight  =  maxHeight + childTop - prevBottom
                end
            end
            if bestH > 0 and prevBottom then
                minHeight  =  minHeight + prevBottom
                bestHeight = bestHeight + prevBottom
                maxHeight  =  maxHeight + prevBottom
            end
            minHeight  = minHeight  + minH
            if bestH > 0 then
                prevBottom = childBottom 
                bestHeight = bestHeight + bestH
            end
            if maxH >= 0 then
                maxHeight = maxHeight + maxH
                maxContentHeight = maxContentHeight + maxH
                if maxH > bestH then flexCount = flexCount + 1 end
            else
                maxHeight = maxHeight + bestH
                maxContentHeight = maxContentHeight + bestH
                if maxH == -1 then
                    unlmCount1 = unlmCount1 + 1
                else
                    unlmCount2 = unlmCount2 + 1
                end
            end
        end
        bottomMargin = prevBottom or 0
        
        return minWidth, minHeight, bestWidth, bestHeight, maxWidth, maxHeight, 
               topMargin, rightMargin, bottomMargin, leftMargin, 
               flexCount, unlmCount1, unlmCount2, maxContentHeight
    end
    
    function class:getMeasures()
        local minWidth, minHeight, bestWidth, bestHeight, maxWidth, maxHeight,
              topMargin, rightMargin, bottomMargin, leftMargin, 
              flexCount, unlmCount1, unlmCount2, maxContentHeight = getMeasures(self)
        if unlmCount1 > 0 then
            maxHeight = -1
        end
        if isRow then
            minWidth, minHeight, bestWidth, bestHeight, maxWidth, maxHeight =
                minHeight, minWidth, bestHeight, bestWidth, maxHeight, maxWidth
    
            topMargin, rightMargin, bottomMargin, leftMargin =
                rotateMargins(topMargin, rightMargin, bottomMargin, leftMargin)
        end
        return minWidth, minHeight, bestWidth, bestHeight, maxWidth, maxHeight,
               topMargin, rightMargin, bottomMargin, leftMargin
    end
    
    
    function class:onLayout(width, height)
    
        local topMargin, rightMargin, bottomMargin, leftMargin = getOuterMargins(self)
        if isRow then
            width, height = height, width
            topMargin, rightMargin, bottomMargin, leftMargin = rotateMargins(topMargin, rightMargin, bottomMargin, leftMargin)
        end

        local minWidth, minHeight, bestWidth, bestHeight, maxWidth, maxHeight,
              myTop, myRight, myBottom, myLeft, 
              flexCount, unlmCount1, unlmCount2, maxContentHeight = getMeasures(self)

        local dLeft  = 0
        local dRight = 0
        do
            if myLeft  > leftMargin  then dLeft  = myLeft  - leftMargin  end
            if myRight > rightMargin then dRight = myRight - rightMargin end
            local dh = 0
            if myTop    > topMargin    then dh = dh + myTop    - topMargin    end
            if myBottom > bottomMargin then dh = dh + myBottom - bottomMargin end
            minHeight  =  minHeight + dh
            bestHeight = bestHeight + dh
            maxHeight  =  maxHeight + dh
        end
        local unlmAdd1 = 0
        local unlmAdd2 = 0
        local s = 0
        local t = 0
        local addStretch = nil
        if height > minHeight then
            if height > maxHeight then
                if unlmCount1 > 0 then
                    local d0 = maxHeight - bestHeight
                    local d1 = height - maxHeight
                    if flexCount / unlmCount1 >= d0 / d1 then
                        unlmAdd1 = floor(d1/unlmCount1 + 0.5)
                        t = 1
                    else
                        local d2a = (unlmCount1 * (d1 + d0))/(unlmCount1 + flexCount)
                        local d2b = (flexCount * (d1 + d0))/(unlmCount1 + flexCount)
                        unlmAdd1 = floor(d2a/unlmCount1 + 0.5)
                        t = (d2b)/(maxHeight - bestHeight)
                    end
                elseif unlmCount2 > 0 then
                    unlmAdd2 = floor((height - maxHeight) / unlmCount2 + 0.5)
                    t = 1
                else
                    addStretch = height - maxHeight
                    t = 1
                end
            elseif height > bestHeight and maxHeight > bestHeight then
                if unlmCount1 > 0 then
                    local d0a = unlmCount1 * (height - bestHeight)/(unlmCount1 + flexCount)
                    local d0b = flexCount * (height - bestHeight)/(unlmCount1 + flexCount)
                    unlmAdd1 = floor(d0a/unlmCount1 + 0.5)
                    t = (d0b)/(maxHeight - bestHeight)
                else
                    t = (height - bestHeight)/(maxHeight - bestHeight)
                end
            elseif bestHeight > minHeight then
                s = (height - minHeight)/(bestHeight - minHeight)
            end
        end
        local prevBottom = topMargin
        local y = 0
        for i = 1, #self do
            local child = self[i]
            local minW, minH, bestW, bestH, maxW, maxH,
                  childTop, childRight, childBottom, childLeft = getChildMeasures(child, isRow)
            local childH
            if s > 0 then
                childH = minH + floor(s * (bestH - minH) + 0.5)
            elseif t > 0 then
                if maxH >= 0 then 
                    if addStretch then
                        childH = maxH + floor(maxH * addStretch / maxContentHeight + 0.5)
                    else
                        childH = bestH + floor(t * (maxH - bestH) + 0.5)
                    end
                elseif maxH == -1 then
                    childH = bestH + unlmAdd1
                else
                    childH = bestH + unlmAdd2
                end
            else
                childH = minH
            end
            if factor then
                childH = floor(factor * childH + 0.5)
            end
            local dy = 0
            if childTop and prevBottom and childTop > prevBottom then
                dy = childTop - prevBottom
            end
            local childX
            if childLeft and childLeft > myLeft then childX = dLeft + childLeft - myLeft 
                                                else childX = dLeft end
            local childW = width - childX - dRight
            if childRight and childRight > myRight then 
                childW = childW - (childRight - myRight)
            end
            if childW < minW then
                childW = minW
            end
            prevBottom = childBottom
            local childY = y + dy
            y = y + dy + (childBottom or 0) + childH
            local ncTop, ncRight, ncBottom, ncLeft = dy + (prevBottom or 0), 
                                                     width - childX + childW + rightMargin,
                                                     childBottom or 0, 
                                                     childX + leftMargin
            if isRow then
                ncTop, ncRight, ncBottom, ncLeft = rotateMargins(ncTop, ncRight, ncBottom, ncLeft)
                childX, childY, childW, childH = childY, childX, childH, childW
            end
            setOuterMargins(child, ncTop, ncRight, ncBottom, ncLeft)
            child:setFrame(childX, childY, childW, childH)
        end
    end
end

Column._implementColumn(Column, false)

return Column
