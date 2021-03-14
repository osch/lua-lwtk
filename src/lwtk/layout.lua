local lwtk = require"lwtk"

local format = string.format
local type   = lwtk.type

local outerMargins = setmetatable({}, { __mode = "k" })
local measureCache = setmetatable({}, { __mode = "k" })

local isInLayout = false
local layoutCounter = 0


local layout = {}

function layout.setOuterMargins(widget, top, right, bottom, left)
    local m = outerMargins[widget]
    if not m then
        m = {}
        outerMargins[widget] = m
    end
    m[1] = top
    m[2] = right
    m[3] = bottom
    m[4] = left
end

function layout.getOuterMargins(widget)
    local m = outerMargins[widget]
    if m then
        return m[1], m[2], m[3], m[4]
    else
        return 0, 0, 0, 0
    end
end

local function getMeasures(widget)
    if not widget.visible then
        return 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    end
    local cached = measureCache[widget]
    if not cached then 
        cached = {}
        measureCache[widget] = cached
    end
    if cached[0] ~= layoutCounter then
        cached[0] = layoutCounter
        local getMeasures = widget.getMeasures
        assert(getMeasures, format('Widget of type %q cannot be part of layout: missing "getMeasures" method.', type(widget)))

        local minW, minH, bestW, bestH, maxW, maxH,
          topMargin, rightMargin, bottomMargin, leftMargin = getMeasures(widget)

        topMargin    = topMargin    or widget:getStyleParam("topMargin")    or false
        rightMargin  = rightMargin  or widget:getStyleParam("rightMargin")  or false
        bottomMargin = bottomMargin or widget:getStyleParam("bottomMargin") or false
        leftMargin   = leftMargin   or widget:getStyleParam("leftMargin")   or false

        if not bestW then
            bestW = minW
            maxW  = minW
        elseif not maxW then
            maxW = bestW
        end
        if not bestH then
            bestH = minH
            maxH  = minH
        elseif not maxH then
            maxH = bestH
        end

        cached[1], cached[2], cached[3], cached[4], cached[5], cached[6],
        cached[7], cached[8], cached[9], cached[10]  = minW, minH, bestW, bestH, maxW, maxH,
                                                       topMargin, rightMargin, bottomMargin, leftMargin
        return minW, minH, bestW, bestH, maxW, maxH,
               topMargin, rightMargin, bottomMargin, leftMargin
    else
        return cached[1], cached[2], cached[3], cached[4], cached[5], cached[6],
               cached[7], cached[8], cached[9], cached[10]
    end
end

local function msgh(err)
    if type(err) == "string" then
        return debug.traceback(err, 2)
    else
        return err
    end
end

function layout.callOnLayout(widget, w, h)
    local onLayout = widget.onLayout
    if onLayout then
        if isInLayout then
            onLayout(widget, w, h)
        else
            isInLayout = true
            layoutCounter = layoutCounter + 1
            local ok, err
            if _VERSION == "Lua 5.1" then
                ok, err = xpcall(function() onLayout(widget, w, h) end, msgh)
            else
                ok, err = xpcall(onLayout, msgh, widget, w, h)
            end
            isInLayout = false
            if not ok then error(err) end
        end
    end
end

function layout.getMeasures(widget)
    if isInLayout then
        return getMeasures(widget)
    else
        isInLayout = true
        layoutCounter = layoutCounter + 1
        local ok, minW, minH, bestW, bestH, maxW, maxH,
                  topMargin, rightMargin, bottomMargin, leftMargin
        if _VERSION == "Lua 5.1" then
            ok, minW, minH, bestW, bestH, maxW, maxH,
                topMargin, rightMargin, bottomMargin, leftMargin = xpcall(function() return getMeasures(widget) end, msgh)
        else
            ok, minW, minH, bestW, bestH, maxW, maxH,
                topMargin, rightMargin, bottomMargin, leftMargin = xpcall(getMeasures, msgh, widget)
        end
        isInLayout = false
        if not ok then error(minW) end
        return minW, minH, bestW, bestH, maxW, maxH,
               topMargin, rightMargin, bottomMargin, leftMargin
    end
end


return layout
