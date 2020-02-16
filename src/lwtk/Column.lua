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
        
        local topMargin    = 0
        local bottomMargin = 0
        local leftMargin   = nil
        local rightMargin  = nil
    
        local n = #self
        for i = 1, n do
            local child = self[i]
            local minW, minH, bestW, bestH, maxW, maxH,
                  childTop, childRight, childBottom, childLeft = getChildMeasures(child, isRow)
            if i == 1 then 
                topMargin = childTop
            end
            if i == n then
                bottomMargin = childBottom
            end
            if not leftMargin  or childLeft  < leftMargin  then leftMargin  = childLeft  end
            if not rightMargin or childRight < rightMargin then rightMargin = childRight end
        end
        leftMargin  = leftMargin or 0
        rightMargin = rightMargin or 0
        
        local flexCount = 0
        local unlmCount = 0
        
        local minHeight = 0
        local bestHeight = 0
        local maxHeight = 0
        
        local minWidth = 0
        local bestWidth = 0
        local maxWidth = 0
        
        local prevBottom
        
        for i = 1, n do
            local child = self[i]
            local minW, minH, bestW, bestH, maxW, maxH,
                  childTop, childRight, childBottom, childLeft = getChildMeasures(child, isRow)
            
            local dw = 0
            if childLeft > leftMargin then
                dw = childLeft - leftMargin
            end
            if childRight > rightMargin then
                dw = dw + childRight - rightMargin
            end
            if dw > 0 then 
                minW = minW + dw
                bestW = bestW + dw
                if maxW then maxW = maxW + dw end
            end
            

            if minW  > minWidth  then minWidth  = minW  end
            if bestW > bestWidth then bestWidth = bestW end
            if maxWidth then
                if maxW then
                    if maxW > maxWidth then maxWidth = maxW end
                else
                    maxWidth = false
                end
            end
            if i > 1 then
                if childTop > prevBottom then 
                    minHeight  =  minHeight + childTop - prevBottom
                    bestHeight = bestHeight + childTop - prevBottom
                    maxHeight  =  maxHeight + childTop - prevBottom
                end
            end
            if i < n then
                minHeight  =  minHeight + childBottom
                bestHeight = bestHeight + childBottom
                maxHeight  =  maxHeight + childBottom
            end
            prevBottom = childBottom
            minHeight  = minHeight  + minH
            bestHeight = bestHeight + bestH
            if maxH then
                maxHeight = maxHeight + maxH
                if maxH > bestH then flexCount = flexCount + 1 end
            else
                maxHeight = maxHeight + bestH
                unlmCount = unlmCount + 1
            end
        end
        bottomMargin = prevBottom or 0
        
        return minWidth, minHeight, bestWidth, bestHeight, maxWidth, maxHeight, 
               topMargin, rightMargin, bottomMargin, leftMargin, 
               flexCount, unlmCount
    end
    
    function class:getMeasures()
        local minWidth, minHeight, bestWidth, bestHeight, maxWidth, maxHeight,
              topMargin, rightMargin, bottomMargin, leftMargin, flexCount, unlmCount = getMeasures(self)
        if unlmCount > 0 then
            maxHeight = false
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
              myTop, myRight, myBottom, myLeft, flexCount, unlmCount = getMeasures(self)

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
        local unlmAdd = 0
        local s = 0
        local t = 0
        if height > minHeight then
            if height > maxHeight then
                if unlmCount > 0 then
                    local d0 = maxHeight - bestHeight
                    local d1 = height - maxHeight
                    if flexCount / unlmCount >= d0 / d1 then
                        unlmAdd = floor(d1/unlmCount + 0.5)
                        t = 1
                    else
                        local d2a = (unlmCount * (d1 + d0))/(unlmCount + flexCount)
                        local d2b = (flexCount * (d1 + d0))/(unlmCount + flexCount)
                        unlmAdd = floor(d2a/unlmCount + 0.5)
                        t = (d2b)/(maxHeight - bestHeight)
                    end
                else
                    t = 1
                end
            elseif height > bestHeight and maxHeight > bestHeight then
                if unlmCount > 0 then
                    local d0a = unlmCount * (height - bestHeight)/(unlmCount + flexCount)
                    local d0b = flexCount * (height - bestHeight)/(unlmCount + flexCount)
                    unlmAdd = floor(d0a/unlmCount + 0.5)
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
                if maxH then 
                    childH = bestH + floor(t * (maxH - bestH) + 0.5)
                else 
                    childH = bestH + unlmAdd
                end
            else
                childH = minH
            end
            local dy = 0
            if childTop > prevBottom then
                dy = childTop - prevBottom
            end
            local childX
            if childLeft > myLeft then childX = dLeft + childLeft - myLeft 
                                  else childX = dLeft end
            local childW = width - childX - dRight
            if childRight > myRight then 
                childW = childW - (childRight - myRight)
            end
            if childW < minW then
                childW = minW
            end
            if maxW and childW > maxW then
                childW = maxW
            end                    
            prevBottom = childBottom
            local childY = y + dy
            y = y + dy + childBottom + childH
            local ncTop, ncRight, ncBottom, ncLeft = dy + prevBottom, 
                                                     width - childX + childW + rightMargin,
                                                     childBottom, 
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
