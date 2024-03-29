local lwtk = require"lwtk"

local format    = string.format
local floor     = math.floor
local type      = lwtk.type

local outerMargins = lwtk.WeakKeysTable("lwtk.layout.outerMargins")
local measureCache = lwtk.WeakKeysTable("lwtk.layout.measureCache")

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

local function round(f)
    if f and f > 0 then
        return floor(f + 0.5)
    else
        return f
    end
end

local function getMeasures2(widget)
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
        
        minW, minH, bestW, bestH, maxW, maxH = round(minW), round(minH), 
                                               round(bestW), round(bestH), 
                                               round(maxW), round(maxH)

        topMargin, rightMargin, bottomMargin, leftMargin = round(topMargin),    round(rightMargin), 
                                                           round(bottomMargin), round(leftMargin)
        
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


local function collectOldFrames(widget, oldFrames)
    for i = 1, #widget do
        local c = widget[i]
        oldFrames[c] = { c.x, c.y, c.w, c.h }
        c._isRelayouting = true
        collectOldFrames(c, oldFrames)
    end
end

local function callRelayout2(widget)
    local onLayout = widget.onLayout
    if onLayout then
        local oldFrames = {}
        collectOldFrames(widget, oldFrames)
        onLayout(widget, widget.w, widget.h)
        for c, o in pairs(oldFrames) do
            local nx, ny, nw, nh = c.x, c.y, c.w, c.h
            c.x, c.y, c.w, c.h = o[1], o[2], o[3], o[4]
            c._needsRelayout = false
            c._isRelayouting = false
            c:animateFrame(nx, ny, nw, nh, true)
        end
    end
    widget._needsRelayout = false
    if widget.getMeasures then
        return getMeasures2(widget)
    end
end

local function msgh(err)
    if type(err) == "string" then
        return debug.traceback(err, 2)
    else
        return err
    end
end

function layout.callOnLayout(widget, w, h, isLayoutTransition)
    local onLayout = widget.onLayout
    if onLayout then
        if isInLayout then
            onLayout(widget, w, h, isLayoutTransition)
        else
            isInLayout = true
            layoutCounter = layoutCounter + 1
            local ok, err
            if _VERSION == "Lua 5.1" then
                ok, err = xpcall(function() onLayout(widget, w, h, isLayoutTransition) end, msgh)
            else
                ok, err = xpcall(onLayout, msgh, widget, w, h, isLayoutTransition)
            end
            isInLayout = false
            if not ok then error(err) end
        end
    end
end

function layout.getMeasures(widget)
    if isInLayout then
        return getMeasures2(widget)
    else
        isInLayout = true
        layoutCounter = layoutCounter + 1
        local ok, minW, minH, bestW, bestH, maxW, maxH,
                  topMargin, rightMargin, bottomMargin, leftMargin
        if _VERSION == "Lua 5.1" then
            ok, minW, minH, bestW, bestH, maxW, maxH,
                topMargin, rightMargin, bottomMargin, leftMargin = xpcall(function() return getMeasures2(widget) end, msgh)
        else
            ok, minW, minH, bestW, bestH, maxW, maxH,
                topMargin, rightMargin, bottomMargin, leftMargin = xpcall(getMeasures2, msgh, widget)
        end
        isInLayout = false
        if ok then return minW, minH, bestW, bestH, maxW, maxH,
                          topMargin, rightMargin, bottomMargin, leftMargin
              else error(minW) end
    end
end


function layout.callRelayout(widget)
    isInLayout = true
    layoutCounter = layoutCounter + 1
    local ok, minW, minH, bestW, bestH, maxW, maxH,
              topMargin, rightMargin, bottomMargin, leftMargin
    if _VERSION == "Lua 5.1" then
        ok, minW, minH, bestW, bestH, maxW, maxH,
            topMargin, rightMargin, bottomMargin, leftMargin  = xpcall(function() return callRelayout2(widget) end, msgh)
    else
        ok, minW, minH, bestW, bestH, maxW, maxH,
            topMargin, rightMargin, bottomMargin, leftMargin  = xpcall(callRelayout2, msgh, widget)
    end
    isInLayout = false
    if ok then return minW, minH, bestW, bestH, maxW, maxH,
                      topMargin, rightMargin, bottomMargin, leftMargin
          else error(minW) end
end

return layout
