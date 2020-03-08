local lwtk = require"lwtk"

local abs                  = math.abs
local getFocusableChildren = lwtk.get.focusableChildren
local getFocusedChild      = lwtk.get.focusedChild
local hasFocus             = lwtk.get.hasFocus

local FocusHandler = lwtk.newClass("lwtk.FocusHandler")

function FocusHandler:new()
    getFocusableChildren[self] = {}
end



local function dist(x1, w1, x2, w2)
    local c1 = x1 + w1/2
    if x2 >= c1 then
        return x2 - c1
    elseif x2 + w2 <= c1 then
        return c1 - (x2 + w2)
    else
        return 0
    end
end

function FocusHandler:getNextFocusableChild(direction)
    local cx, cy, cw, ch = 0, 0, 0, 0
    local focusedChild = getFocusedChild[self]
    if focusedChild then
        cx, cy = focusedChild:transformXY(0, 0, self)
        cw, ch = focusedChild.w, focusedChild.h
    end
    local focusableChildren = getFocusableChildren[self]
    local found
    do
        local fx, fy, fw, fh
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, self)
                local nw, nh = child.w, child.h
                if direction == "right" then
                    if ny + nh >= cy  and ny < cy + ch then
                        if nx >= cx and (not found or  nx - cx <  fx - cx 
                                                   or (nx - cx == fx - cx and dist(cy, ch, ny, nh) < dist(cy, ch, fy, fh)))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "left" then
                    if ny + nh >= cy  and ny < cy + ch then
                        if nx < cx and (not found or  cx - nx <  cx - fx
                                                  or (cx - nx == cx - fx and dist(cy, ch, ny, nh) < dist(cy, ch, fy, fh)))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "up" then
                    if nx + nw >= cx  and nx < cx + cw then
                        if ny < cy and (not found or  cy - ny  < cy - fy
                                                  or (cy - ny == cy - fy and dist(cx, cw, nx, nw) < dist(cx, cw, fx, fw)))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                elseif direction == "down" then
                    if nx + nw >= cx  and nx < cx + cw then
                        if ny >= cy and (not found or  ny - cy <  fy - cy
                                                   or (ny - cy == fy - cy and dist(cx, cw, nx, nw) < dist(cx, cw, fx, fw)))
                        then
                            found, fx, fy, fw, fh = child, nx, ny, nw, nh
                        end
                    end
                end
            end
        end
    end
    if not found and (direction == "up" or direction == "down") then
        local fx, fy, fw, fh
        for i = 1, #focusableChildren do
            local child = focusableChildren[i]
            if child ~= focusedChild then
                local nx, ny = child:transformXY(0, 0, self)
                local nw, nh = child.w, child.h
                if direction == "up" then
                    if ny < cy and (not found or dist(cx, cw, nx, nw) < dist(cx, cw, fx, fw)) then
                        found, fx, fy, fw, fh = child, nx, ny, nw, nh
                    end
                elseif direction == "down" then
                    if ny >= cy + ch and (not found or dist(cx, cw, nx, nw) < dist(cx, cw, fx, fw)) then
                        found, fx, fy, fw, fh = child, nx, ny, nw, nh
                    end
                end
            end
        end
    end
    return found
end

function FocusHandler:moveFocusRight()
    local found = self:getNextFocusableChild("right")
    if found then
        self:setFocus(found)
    end
end
function FocusHandler:moveFocusLeft()
    local found = self:getNextFocusableChild("left")
    if found then
        self:setFocus(found)
    end
end
function FocusHandler:moveFocusUp()
    local found = self:getNextFocusableChild("up")
    if found then
        self:setFocus(found)
    end
end
function FocusHandler:moveFocusDown()
    local found = self:getNextFocusableChild("down")
    if found then
        self:setFocus(found)
    end
end

function FocusHandler:_handleFocusIn()
    if not hasFocus[self] then
        hasFocus[self] = true
        local focusedChild = getFocusedChild[self]
        if focusedChild then
            focusedChild:_handleFocusIn()
        else
            local found, foundX, foundY
            local focusableChildren = getFocusableChildren[self]
            for i = 1, #focusableChildren do
                local child = focusableChildren[i]
                if found then
                    local childX, childY = child:transformXY(0, 0, self)
                    if childY < foundY or childY == foundY and childX < foundX then
                        foundX = childX
                        foundY = childY
                        found = child
                    end
                else
                    foundX, foundY = child:transformXY(0, 0, self)
                    found = child
                end
            end
            if found then
                getFocusedChild[self] = found
                found:_handleFocusIn()
            end
        end
    end
end

function FocusHandler:_handleFocusOut()
    if hasFocus[self] then
        hasFocus[self] = false
        local focusedChild = getFocusedChild[self]
        if focusedChild then
            focusedChild:_handleFocusOut()
        end
    end
end

function FocusHandler:setFocus(newFocusChild)
    local focusedChild = getFocusedChild[self]
    if focusedChild ~= newFocusChild then
        getFocusedChild[self] = newFocusChild
        if hasFocus[self] then
            if focusedChild then
                focusedChild:_handleFocusOut()
            end
            if newFocusChild then
                newFocusChild:_handleFocusIn()
            end
        end
    end
end

function FocusHandler:_handleKeyDown(key)
    local focusedChild = getFocusedChild[self]
    if focusedChild then
        local onKeyDown = focusedChild.onKeyDown
        if onKeyDown then
            return onKeyDown(focusedChild, key)
        end
    end
end


return FocusHandler
