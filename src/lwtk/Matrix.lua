local lwtk = require"lwtk"

local type       = lwtk.type
local Super      = lwtk.Group
local Matrix     = lwtk.newClass("lwtk.Matrix", Super)

local setOuterMargins = lwtk.layout.setOuterMargins
local getOuterMargins = lwtk.layout.getOuterMargins
local getMeasures     = lwtk.layout.getMeasures

local calculateLRMeasures = lwtk.internal.LayoutImpl.calculateLRMeasures
local calculateTBMeasures = lwtk.internal.LayoutImpl.calculateTBMeasures
local applyTBLayout       = lwtk.internal.LayoutImpl.applyTBLayout

local getRowAdapters    = lwtk.WeakKeysTable()
local getColumnAdapters = lwtk.WeakKeysTable()

local col4Caches        = lwtk.WeakKeysTable()
local row4Caches        = lwtk.WeakKeysTable()

local ColumnAdapter = lwtk.newClass("lwtk.Matrix.ColumnAdapter")
local RowAdapter    = lwtk.newClass("lwtk.Matrix.RowAdapter")

-------------------------------------------------------------------------------------------------

ColumnAdapter:declare("visible")

RowAdapter:declare("visible")

function ColumnAdapter:new()
    self.visible = true
end

function RowAdapter:new()
    self.visible = true
end

-------------------------------------------------------------------------------------------------

local function get4Cache(cache, i)
    i = (i - 1) * 4
    return cache[i + 1], cache[i + 2], cache[i + 3], cache[i + 4]
end

-------------------------------------------------------------------------------------------------

Matrix:declare("columnCount",
               "rowCount")

function Matrix.override:new(initParams)
    local columnCount = 0
    local rows = {}
    for i = 1, #initParams do
        local row = initParams[i]
        assert(type(row) == "table", 'Object of type "lwtk.Matrix" must have row elements of type "table"')
        if i == 1 then
            columnCount = #row
        else
            assert(columnCount == #row, 'All rows for object of type "lwtk.Matrix" must have the same number of columns')
        end
        rows[i] = row
        initParams[i] = nil
    end
    Super.new(self, initParams)
    local rowCount = #rows
    local rowAdapters = {}
    for r = 1, rowCount do
        rowAdapters[r] = RowAdapter()
    end
    local columnAdapters = {}
    for c = 1, columnCount do
        columnAdapters[c] = ColumnAdapter()
    end
    for r = 1, rowCount do
        local row = rows[r]
        local rowAdapter = rowAdapters[r]
        for c = 1, #row do
            local child = row[c]
            self:addChild(child)
            rowAdapter[c] = child
            columnAdapters[c][r] = child
        end
    end
    self.columnCount = columnCount
    self.rowCount = rowCount
    getRowAdapters[self]    = rowAdapters
    getColumnAdapters[self] = columnAdapters
end

-------------------------------------------------------------------------------------------------

local function getRowLRMeasures(child)
    local minW, minH, bestW, bestH, maxW, maxH,                              -- luacheck: ignore 211/minW 211/bestW 211/maxW
          childTop, childRight, childBottom, childLeft = getMeasures(child)  -- luacheck: ignore 211/childRight 211/childLeft
    return minH, bestH, maxH,
           childTop, childBottom
end
local function getColumnLRMeasures(child)
    local minW, minH, bestW, bestH, maxW, maxH,                              -- luacheck: ignore 211/minH 211/bestH 211/maxH
          childTop, childRight, childBottom, childLeft = getMeasures(child)  -- luacheck: ignore 211/childTop 211/childBottom
    return minW, bestW, maxW,
           childLeft, childRight
end
local function getRowTBMeasures(rowAdapter)
    return calculateLRMeasures(rowAdapter, getRowLRMeasures)
end
local function getColumnTBMeasures(columnAdapter)
    return calculateLRMeasures(columnAdapter, getColumnLRMeasures)
end

-------------------------------------------------------------------------------------------------

function Matrix.implement:getMeasures()
    local rowAdapters    = getRowAdapters[self]
    local columnAdapters = getColumnAdapters[self]

    local minHeight, bestHeight, maxHeight,
          topMargin, bottomMargin, 
          flexCount1, rowUnlmCount = calculateTBMeasures(rowAdapters, getRowTBMeasures) -- luacheck: ignore 211/flexCount1
    if rowUnlmCount > 0 then
        maxHeight = -1
    end

    local minWidth, bestWidth, maxWidth,
          leftMargin, rightMargin, 
          flexCount2, colUnlmCount = calculateTBMeasures(columnAdapters, getColumnTBMeasures) -- luacheck: ignore 211/flexCount2
    if colUnlmCount > 0 then
        maxWidth = -1
    end
    
    return minWidth, minHeight, bestWidth, bestHeight, maxWidth, maxHeight,
           topMargin, rightMargin, bottomMargin, leftMargin
end

-------------------------------------------------------------------------------------------------

function Matrix.implement:onLayout(width, height, isLayoutTransition)
    if not isLayoutTransition then
        local topMargin, rightMargin, bottomMargin, leftMargin = getOuterMargins(self)
        local rowAdapters    = getRowAdapters[self]
        local columnAdapters = getColumnAdapters[self]
        local rowCache = row4Caches[self]; if not rowCache then rowCache = {}; row4Caches[self] = rowCache; end
        local colCache = col4Caches[self]; if not colCache then colCache = {}; col4Caches[self] = colCache; end
        applyTBLayout(rowAdapters,    height, topMargin,  bottomMargin, rowCache, getRowTBMeasures)
        applyTBLayout(columnAdapters, width,  leftMargin, rightMargin,  colCache, getColumnTBMeasures)
        for r = 1, #rowAdapters do
            local rowAdapter = rowAdapters[r]
            local ncTop,  ncBottom, childY, childH = get4Cache(rowCache, r)
            for c = 1, #columnAdapters do
                local child = rowAdapter[c]
                local ncLeft, ncRight,  childX, childW = get4Cache(colCache, c)
                setOuterMargins(child, ncTop, ncRight, ncBottom, ncLeft)
                child:setFrame(childX, childY, childW, childH)
            end
        end
    end
end

-------------------------------------------------------------------------------------------------

return Matrix
