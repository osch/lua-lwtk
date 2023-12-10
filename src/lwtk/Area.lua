local lwtk = require"lwtk"

local Rect = lwtk.Rect


--[[
    A list of rectangle coordinates forming an area.
]]
local Area = lwtk.newClass("lwtk.Area")

local rawget              = rawget
local areRectsIntersected = Rect.areRectsIntersected
local doesRectContain     = Rect.doesRectContain

Area:declare(
    "count" -- number of rectangles in the area
)

--[[
    Creates an empty area object.
]]
function Area:new()
    self.count = 0
end

--[[
    Obtain coordinates of the i-th rectangle from the area.
       
       * *i* - index of the rectangle, *1 <= i <= area.count*
       
    Returns *x, y, w, h* rectangle coordinates
]]
function Area:getRect(i)
    local i0 = (i - 1) * 4
    return rawget(self, i0 + 1), 
           rawget(self, i0 + 2), 
           rawget(self, i0 + 3), 
           rawget(self, i0 + 4)
end

local function iterator(self, i)
    if i < self.count then
        local i0 = i * 4
        return i + 1, rawget(self, i0 + 1), 
                      rawget(self, i0 + 2), 
                      rawget(self, i0 + 3), 
                      rawget(self, i0 + 4)
    end
end

--[[
    Iterate through all rectangle coordinates. 
    
    Returns an *iterator function*, *self* and *0*, so that the construction
    ```lua
        for i, x, y, w, h in area:iteration() do ... end
    ```
    will iterate over all rectangle indices and coordinates.
]]
function Area:iteration()
    return iterator, self, 0
end

--[[
    Adds the rectangle coordinates to the area.
]]
function Area:addRect(x, y, w, h)
    if w > 0 and h > 0 then
        for i, x2, y2, w2, h2 in iterator, self, 0 do
            if doesRectContain(x2, y2, w2, h2, x, y, w, h) then
                return
            elseif doesRectContain(x, y, w, h, x2, y2, w2, h2) then
                local i0 = (i-1) * 4
                rawset(self, i0 + 1, x)
                rawset(self, i0 + 2, y)
                rawset(self, i0 + 3, w)
                rawset(self, i0 + 4, h)
                return 
            end
        end
        local count = self.count
        local i0 = count * 4
        rawset(self, i0 + 1, x)
        rawset(self, i0 + 2, y)
        rawset(self, i0 + 3, w)
        rawset(self, i0 + 4, h)
        self.count = count + 1
    end
end

--[[
    Returns *true* if the given rectangle coordinates intersect
    the area.
]]
function Area:intersects(x, y, w, h)
    for _, x2, y2, w2, h2 in iterator, self, 0 do
        if areRectsIntersected(x, y, w, h, x2, y2, w2, h2) then
            return true
        end
    end
    return false
end

--[[
    Returns *true* if the given rectangle coordinates are 
    within the area.
]]
function Area:isWithin(x, y, w, h)
    for _, x2, y2, w2, h2 in iterator, self, 0 do
        if not doesRectContain(x, y, w, h, x2, y2, w2, h2) then
            return false
        end
    end
    return true
end

function Area:intersectsBorder(x, y, w, h, borderWidth)
    local ix, iy, iw, ih = x + borderWidth,
                           y + borderWidth,
                           w - 2*borderWidth,
                           h - 2*borderWidth
    for _, x2, y2, w2, h2 in iterator, self, 0 do
        if     not doesRectContain(ix, iy, iw, ih, x2, y2, w2, h2) 
           and areRectsIntersected( x,  y,  w,  h, x2, y2, w2, h2)
        then
            return true
        end
    end
    return false
end

--[[
    Clears all rectangle coordinates. After this the
    area does not contain any rectangle, i.e. *area.count == 0*. 
]]
function Area:clear()
    self.count = 0
end

return Area
