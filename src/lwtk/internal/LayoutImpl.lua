local LayoutImpl = {}

local floor      = math.floor

-------------------------------------------------------------------------------------------------

local function set4Cache(cache, i, v1, v2, v3, v4)
    i = (i - 1) * 4
    cache[i + 1] = v1
    cache[i + 2] = v2
    cache[i + 3] = v3
    cache[i + 4] = v4
end

-------------------------------------------------------------------------------------------------

local function calculateLRMeasures(childList, getChildLRMeasures)
    
    local n = #childList
    
    local bestWidth = 0
    for i = 1, n do
        local child = childList[i]
        if child.visible then
            local minW, bestW, maxW,                                  -- luacheck: ignore 211/minW 211/maxW
                  childLeft, childRight  = getChildLRMeasures(child)  -- luacheck: ignore 211/childLeft 211/childRight
            if bestW > bestWidth then bestWidth = bestW end
        end
    end
    
    local leftMargin   = nil
    local rightMargin  = nil

    for i = 1, n do
        local child = childList[i]
        if child.visible then
            local minW, bestW, maxW,                                   -- luacheck: ignore 211/minW 211/maxW
                  childLeft, childRight  = getChildLRMeasures(child)
            if bestW > 0 then
                local w = (childLeft or 0) + bestW + (childRight or 0)
                if w > bestWidth then
                    if childLeft  and (not leftMargin  or childLeft  < leftMargin)  then 
                        leftMargin  = childLeft  
                    end
                    if childRight and (not rightMargin or childRight < rightMargin) then 
                        rightMargin = childRight 
                    end
                end
            end
        end
    end
    rightMargin  = rightMargin or 0
    leftMargin   = leftMargin or 0
    
    local minWidth = 0
    local maxWidth = 0
    
    for i = 1, n do
        local child = childList[i]
        if child.visible then
            local minW, bestW, maxW,
                  childLeft, childRight  = getChildLRMeasures(child)
            
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
        end
    end
    
    return minWidth, bestWidth, maxWidth, 
           leftMargin, rightMargin
end

-------------------------------------------------------------------------------------------------


local function calculateTBMeasures(childList, getChildTBMeasures)
    
    local n = #childList
    
    local topMargin    = nil

    for i = 1, n do
        local child = childList[i]
        if child.visible then
            local minH, bestH, maxH,                                  -- luacheck: ignore 211/minH 211/maxH
                  childTop, childBottom = getChildTBMeasures(child)   -- luacheck: ignore 211/childBottom
            if not topMargin and childTop and bestH > 0 then 
                topMargin = childTop
            end
        end
    end
    topMargin    = topMargin or 0
    
    local flexCount = 0
    local unlmCount1 = 0
    local unlmCount2 = 0
    
    local minHeight = 0
    local bestHeight = 0
    local maxHeight = 0
    local maxContentHeight = 0
    
    local prevBottom
    
    for i = 1, n do
        local child = childList[i]
        if child.visible then
            local minH, bestH, maxH,
                  childTop, childBottom = getChildTBMeasures(child)
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
    end
    local bottomMargin = prevBottom or 0
    
    return minHeight, bestHeight, maxHeight, 
           topMargin, bottomMargin, 
           flexCount, unlmCount1, unlmCount2, maxContentHeight
end

-------------------------------------------------------------------------------------------------

function LayoutImpl.applyLRLayout(childList, width, leftMargin, rightMargin, rsltCache, getChildLRMeasures)

    local minWidth, bestWidth, maxWidth,                                         -- luacheck: ignore 211/minWidth 211/bestWidth 211/maxWidth
          myLeft, myRight = calculateLRMeasures(childList, getChildLRMeasures)

    local dLeft  = 0
    local dRight = 0
    do
        if myLeft  > leftMargin  then dLeft  = myLeft  - leftMargin  end
        if myRight > rightMargin then dRight = myRight - rightMargin end
    end
    
    for i = 1, #childList do
        local child = childList[i]
        if child.visible then
            local minW, bestW, maxW,                                  -- luacheck: ignore 211/bestW 211/maxW
                  childLeft, childRight = getChildLRMeasures(child)
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
            local ncLeft, ncRight = childX + leftMargin,
                                    width - childX + childW + rightMargin
            set4Cache(rsltCache, i, ncLeft, ncRight, childX, childW)
        else
            set4Cache(rsltCache, i, 0, 0, 0, 0)
        end
    end
end

-------------------------------------------------------------------------------------------------

function LayoutImpl.applyTBLayout(childList, height, topMargin, bottomMargin, rsltCache, getChildTBMeasures)

    local minHeight, bestHeight, maxHeight, 
          myTop, myBottom, 
          flexCount, unlmCount1, unlmCount2, maxContentHeight = calculateTBMeasures(childList, getChildTBMeasures)

    local dTop = 0
    local dBottom = 0
    do
        if myTop    > topMargin    then dTop    = myTop    - topMargin    end
        if myBottom > bottomMargin then dBottom = myBottom - bottomMargin end
        local dh = dTop + dBottom
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
                    unlmAdd1 = d1/unlmCount1
                    t = 1
                else
                    local d2a = (unlmCount1 * (d1 + d0))/(unlmCount1 + flexCount)
                    local d2b = (flexCount * (d1 + d0))/(unlmCount1 + flexCount)
                    unlmAdd1 = d2a/unlmCount1
                    t = (d2b)/(maxHeight - bestHeight)
                end
            elseif unlmCount2 > 0 then
                unlmAdd2 = (height - maxHeight) / unlmCount2
                t = 1
            else
                addStretch = height - maxHeight
                t = 1
            end
        elseif height > bestHeight and maxHeight > bestHeight then
            if unlmCount1 > 0 then
                local d0a = unlmCount1 * (height - bestHeight)/(unlmCount1 + flexCount)
                local d0b = flexCount * (height - bestHeight)/(unlmCount1 + flexCount)
                unlmAdd1 = d0a/unlmCount1
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
    local roundingError = 0
    local n = #childList
    for i = 1, n do
        local child = childList[i]
        if child.visible then
            local minH, bestH, maxH,
                  childTop, childBottom = getChildTBMeasures(child)
            local childH
            if s > 0 then
                childH = minH + s * (bestH - minH)
            elseif t > 0 then
                if maxH >= 0 then 
                    if addStretch then
                        childH = maxH + maxH * addStretch / maxContentHeight
                    else
                        childH = bestH + t * (maxH - bestH)
                    end
                elseif maxH == -1 then
                    childH = bestH + unlmAdd1
                else
                    childH = bestH + unlmAdd2
                end
            else
                childH = minH
            end
            local dy = 0
            if childTop and prevBottom and childTop > prevBottom then
                dy = childTop - prevBottom
            end
            do
                local r = floor(childH)
                roundingError = roundingError + childH - r
                if roundingError >= 1 then
                    childH = r + 1
                    roundingError = roundingError - 1
                else
                    childH = r
                end
            end
            if minH > 0 then
                prevBottom = childBottom or 0
            else
                prevBottom = (prevBottom or 0) + dy
            end
            local childY = y + dy
            y = childY + (childBottom or 0) + childH
            local ncTop, ncBottom = dy + (prevBottom or 0), 
                                    childBottom or 0
            set4Cache(rsltCache, i, ncTop, ncBottom, childY, childH)
        else
            set4Cache(rsltCache, i, 0, 0, 0, 0)
        end
    end
end

-------------------------------------------------------------------------------------------------

LayoutImpl.calculateLRMeasures = calculateLRMeasures
LayoutImpl.calculateTBMeasures = calculateTBMeasures

-------------------------------------------------------------------------------------------------
return LayoutImpl
