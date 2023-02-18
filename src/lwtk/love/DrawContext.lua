local lwtk = require"lwtk"

local Super = lwtk.love.LayoutContext
local DrawContext = lwtk.newClass("lwtk.love.DrawContext", Super)

function DrawContext:new(...)
    Super.new(self, ...)
    self.opacityStack = {}
    self.scissorStack = {}
end

function DrawContext:_reset()
    Super._reset()
    local opacityStack = self.opacityStack
    for k, v in pairs(opacityStack) do
        opacityStack[k] = nil
    end
    local scissorStack = self.scissorStack
    for k, v in pairs(scissorStack) do
        scissorStack[k] = nil
    end
    love.graphics.setScissor()
end

function DrawContext:fillRect(color, x, y, w, h)
    love.graphics.setColor(color:toRGBA())
    love.graphics.rectangle("fill", x, y, w, h)
end

function DrawContext:setColor(r, g, b, a)
    if g then
        a = a or 1
        love.graphics.setColor(r, g, b, a)
    else
        love.graphics.setColor(r:toRGBA())
    end
end

function DrawContext:setLineWidth(w)
    love.graphics.setLineWidth(w-0.5)
end

function DrawContext:drawLine(x1, y1, x2, y2, ...)
    love.graphics.line(x1, y1, x2, y2, ...)
end

function DrawContext:drawText(x, y, text)
    love.graphics.print(text, x, y - self.fontAscent) --fontLineHeight)
end

function DrawContext:beginOpacity(opacity)
    local opacityStack = self.opacityStack 
    local sx, sy, sw, sh = love.graphics.getScissor()
    if sw > 0 and sh > 0 then
        local ox, oy = love.graphics.transformPoint(0, 0)
        local rx, ry = sx-ox, sy-oy
        local canvas = love.graphics.newCanvas(sw, sh)
        local prevCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(canvas)
        love.graphics.origin()
        love.graphics.translate(-rx, -ry)
        love.graphics.setScissor(0, 0, sw, sh)
--        love.graphics.setScissor()
        opacityStack[#opacityStack + 1] = { opacity, canvas, sx, sy, sw, sh, prevCanvas, rx, ry }
    else
        opacityStack[#opacityStack + 1] = false
    end
end

function DrawContext:endOpacity()
    local opacityStack = self.opacityStack 
    local entry = opacityStack[#opacityStack]
    if entry then
        local opacity, canvas, sx, sy, sw, sh, prevCanvas, ox, oy = entry[1], entry[2], entry[3], entry[4], entry[5], entry[6], entry[7], entry[8], entry[9]
        love.graphics.setCanvas(prevCanvas)
        love.graphics.setColor(1,1,1, opacity)
        love.graphics.setScissor(sx, sy, sw, sh)
        love.graphics.origin()
        love.graphics.draw(canvas, sx, sy)
        love.graphics.translate(ox, oy)
    end
    opacityStack[#opacityStack] = nil
end

function DrawContext:translate(x, y)
    love.graphics.translate(x, y)
end

function DrawContext:drawBorder(color, borderThickness, x, y, w, h)
    local d = borderThickness / 2
    self:setColor(color)
    love.graphics.setLineWidth(borderThickness-0.5)
    love.graphics.rectangle("line", x + d, y + d, w - 2*d, h - 2*d)
end

function DrawContext:intersectClip(x, y, w, h)
    local tx, ty = love.graphics.transformPoint(x, y)
    love.graphics.intersectScissor(tx, ty, w, h)
end

function DrawContext:save()
    love.graphics.push()
    local sx, sy, sw, sh = love.graphics.getScissor()
    local scissorStack = self.scissorStack
    local i = #scissorStack
    scissorStack[i + 1] = sx
    scissorStack[i + 2] = sy
    scissorStack[i + 3] = sw
    scissorStack[i + 4] = sh
end

function DrawContext:restore()
    love.graphics.pop()
    local scissorStack = self.scissorStack
    local i = #scissorStack - 4
    love.graphics.setScissor(scissorStack[i + 1],
                             scissorStack[i + 2],
                             scissorStack[i + 3],
                             scissorStack[i + 4])
    scissorStack[i + 4] = nil
    scissorStack[i + 3] = nil
    scissorStack[i + 2] = nil
    scissorStack[i + 1] = nil
end

return DrawContext
