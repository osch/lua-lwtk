local floor  = math.floor
local format = string.format

local lwtk  = require"lwtk"

local Rect  = lwtk.newClass("lwtk.Rect")

function Rect.round(x, y, w, h)
    if w < 0 then w = 0 end
    if h < 0 then h = 0 end
    local rx  = floor(x + 0.5)
    local ry  = floor(y + 0.5)
    local rw  = floor(w + 0.5)
    local rh  = floor(h + 0.5)
    return rx, ry, rw, rh
end

function Rect:new(x, y, w, h)
    self.x      = x
    self.y      = y
    self.width  = w
    self.height = h
end

function Rect:toXYWH()
    return self.x, self.y, self.width, self.height
end

function Rect.areRectsIntersected(x1, y1, w1, h1, x2, y2, w2, h2)
    if x1 >= x2 + w2 or x1 + w1 <= x2 then
        return false; -- one rectangle is on left side of other
    end
    if y1 >= y2 + h2 or y1 + h1 <= y2 then
        return false -- one rectangle is above other
    end
    return true

end

local areRectsIntersected = Rect.areRectsIntersected

function Rect:intersects(x, y, w, h)
    return areRectsIntersected(self.x, self.y, self.width, self.height,
                                    x,      y,      w,          h)
end

function Rect.doesRectContain(x1, y1, w1, h1, x2, y2, w2, h2)
    local myX0, myY0 = x1, y1
    local myX1, myY1 = myX0 + w1, myY0 + h1
    
    local otherX0, otherY0 = x2, y2
    local otherX1, otherY1 = x2 + w2, y2 + h2
    
    return myX0 <= otherX0  and  otherX0 <  myX1  
       and myY0 <= otherY0  and  otherY0 <  myY1
       
       and myX0 <  otherX1  and  otherX1 <= myX1
       and myY0 <  otherY1  and  otherY1 <= myY1
end

local doesRectContain = Rect.doesRectContain

function Rect:contains(x, y, w, h)
    return doesRectContain(self.x, self.y, self.width, self.height,
                           x, y, w, h)
end

function Rect:__eq(other)
    return self.x == other.x
       and self.y == other.y
       and self.width  == other.witdh
       and self.height == other.height
end

function Rect:__tostring()
    return format("lwtk.Rect(%d,%d,%d,%d)",  self:toXYWH())
end

function Rect.intersectRects(x1, y1, w1, h1, x2, y2, w2, h2)
    if areRectsIntersected(x1, y1, w1, h1, x2, y2, w2, h2) then
        local x = (x1 >= x2) and x1 or x2
        local y = (y1 >= y2) and y1 or y2
        local w = (x1 + w1 <= x2 + w2) and (x1 + w1 - x) or (x2 + w2 - x)
        local h = (y1 + h1 <= y2 + h2) and (y1 + h1 - y) or (y2 + h2 - y)
        return x, y, w, h
    else
        return 0, 0, 0, 0
    end
end


return Rect
