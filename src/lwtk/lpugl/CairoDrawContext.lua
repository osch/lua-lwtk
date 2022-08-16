local lwtk = require"lwtk"

local Super = lwtk.lpugl.CairoLayoutContext
local CairoDrawContext = lwtk.newClass("lwtk.lpugl.CairoDrawContext", Super)

function CairoDrawContext:new(...)
    Super.new(self, ...)
    self.opacityStack = {}
end

function CairoDrawContext:_setCairoContext(cairoCtx)
    self.ctx = cairoCtx
    local opacityStack = self.opacityStack
    for k, v in pairs(opacityStack) do
        opacityStack[k] = nil
    end
end

function CairoDrawContext:fillRect(color, x, y, w, h)
    local ctx = self.ctx
    ctx:set_source_rgba(color:toRGBA())
    ctx:rectangle(x, y, w, h)
    ctx:fill()
end

function CairoDrawContext:intersectClip(x, y, w, h)
    local ctx = self.ctx
    ctx:rectangle(x, y, w, h)
    ctx:clip()
end

function CairoDrawContext:setColor(r, g, b, a)
    if g then
        a = a or 1
        self.ctx:set_source_rgba(r, g, b, a)
    else
        self.ctx:set_source_rgba(r:toRGBA())
    end
end

function CairoDrawContext:setLineWidth(w)
    self.ctx:set_line_width(w)
end

function CairoDrawContext:drawLine(x1, y1, x2, y2, ... )
    local ctx = self.ctx
    ctx:move_to(x1, y1)
    ctx:line_to(x2, y1)
    for i = 1, select("#", ...), 2 do
        local x, y = select(i, ...)
        if y then
            ctx:line_to(x, y)
        end
    end
    ctx:stroke()
end

function CairoDrawContext:drawText(x, y, text)
    local ctx = self.ctx
    ctx:move_to(x, y)
    ctx:show_text(text)
end

function CairoDrawContext:beginOpacity(opacity)
    local opacityStack = self.opacityStack 
    opacityStack[#opacityStack + 1] = opacity
    self.ctx:push_group()
end

function CairoDrawContext:endOpacity()
    local ctx = self.ctx
    local opacityStack = self.opacityStack 
    local opacity = opacityStack[#opacityStack]
    opacityStack[#opacityStack] = nil
    ctx:pop_group_to_source()
    ctx:paint_with_alpha(opacity)
end

function CairoDrawContext:translate(x, y)
    self.ctx:translate(x, y)
end

function CairoDrawContext:drawBorder(color, borderThickness, x, y, w, h)
    local ctx = self.ctx
    local d = borderThickness / 2
    ctx:rectangle(x + d, y + d, w - 2*d, h - 2*d)
    ctx:set_line_width(borderThickness)
    ctx:set_source_rgba(color:toRGBA())
    ctx:stroke()
end

function CairoDrawContext:save()
    self.ctx:save()
end

function CairoDrawContext:restore()
    self.ctx:restore()
end

return CairoDrawContext
