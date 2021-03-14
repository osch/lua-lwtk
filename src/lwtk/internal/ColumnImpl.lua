local lwtk = require"lwtk"

local setOuterMargins = lwtk.layout.setOuterMargins
local getOuterMargins = lwtk.layout.getOuterMargins
local getMeasures     = lwtk.layout.getMeasures

local calculateLRMeasures = lwtk.internal.LayoutImpl.calculateLRMeasures
local calculateTBMeasures = lwtk.internal.LayoutImpl.calculateTBMeasures
local applyLRLayout       = lwtk.internal.LayoutImpl.applyLRLayout
local applyTBLayout       = lwtk.internal.LayoutImpl.applyTBLayout

local lr4Caches = setmetatable({}, { __mode = "k" })
local tb4Caches = setmetatable({}, { __mode = "k" })

-------------------------------------------------------------------------------------------------

local ColumnImpl = {}

-------------------------------------------------------------------------------------------------

local function get4Cache(cache, i)
    i = (i - 1) * 4
    return cache[i + 1], cache[i + 2], cache[i + 3], cache[i + 4]
end


-------------------------------------------------------------------------------------------------

local function rotateMargins(top, right, bottom, left)
    return left, bottom, right, top
end

-------------------------------------------------------------------------------------------------

local function getChildLRMeasuresForColumn(child)
    local minW, minH, bestW, bestH, maxW, maxH,
          childTop, childRight, childBottom, childLeft = getMeasures(child)
    return minW, bestW, maxW,
           childLeft, childRight
end

local function getChildLRMeasuresForRow(child)
    local minW, minH, bestW, bestH, maxW, maxH,
          childTop, childRight, childBottom, childLeft = getMeasures(child)
    minW, bestW, maxW = minH, bestH, maxH
    childLeft, childRight  = childTop, childBottom
    return minW, bestW, maxW,
           childLeft, childRight
end

-------------------------------------------------------------------------------------------------

local function getChildTBMeasuresForColumn(child)
    local minW, minH, bestW, bestH, maxW, maxH,
          childTop, childRight, childBottom, childLeft = getMeasures(child)
    return minH, bestH, maxH,
           childTop, childBottom
end

local function getChildTBMeasuresForRow(child)
    local minW, minH, bestW, bestH, maxW, maxH,
          childTop, childRight, childBottom, childLeft = getMeasures(child)
    minH, bestH, maxH = minW, bestW, maxW
    childTop, childBottom = childLeft, childRight
    return minH, bestH, maxH,
           childTop, childBottom
end

-------------------------------------------------------------------------------------------------

function ColumnImpl.implementColumn(class, isRow)

    local getChildLRMeasures = isRow and getChildLRMeasuresForRow 
                                      or getChildLRMeasuresForColumn
    local getChildTBMeasures = isRow and getChildTBMeasuresForRow
                                      or getChildTBMeasuresForColumn
    function class:getMeasures()
        local minWidth, bestWidth, maxWidth,
              leftMargin, rightMargin = calculateLRMeasures(self, getChildLRMeasures)

        local minHeight, bestHeight, maxHeight,
              topMargin, bottomMargin, 
              flexCount, unlmCount1, unlmCount2, maxContentHeight = calculateTBMeasures(self, getChildTBMeasures)

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
        local lrCache = lr4Caches[self]; if not lrCache then lrCache = {}; lr4Caches[self] = lrCache; end
        local tbCache = tb4Caches[self]; if not tbCache then tbCache = {}; tb4Caches[self] = tbCache; end
        applyLRLayout(self, width,  leftMargin, rightMargin,  lrCache, getChildLRMeasures)
        applyTBLayout(self, height, topMargin,  bottomMargin, tbCache, getChildTBMeasures)
        for i = 1, #self do
            local child = self[i]
            if child.visible then
                local ncTop, ncRight, ncBottom, ncLeft
                local childX, childY, childW, childH
                ncLeft, ncRight,  childX, childW = get4Cache(lrCache, i)
                ncTop,  ncBottom, childY, childH = get4Cache(tbCache, i)
                if isRow then
                    ncTop, ncRight, ncBottom, ncLeft = rotateMargins(ncTop, ncRight, ncBottom, ncLeft)
                    childX, childY, childW, childH = childY, childX, childH, childW
                end
                setOuterMargins(child, ncTop, ncRight, ncBottom, ncLeft)
                child:setFrame(childX, childY, childW, childH)
            end
        end
    end
end



return ColumnImpl
