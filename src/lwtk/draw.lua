local draw = {}

function draw.fillRect(ctx, color, x, y, w, h)
    ctx:set_source_rgba(color:toRGBA())
    ctx:rectangle(x, y, w, h)
    ctx:fill()
end

function draw.drawBorder(ctx, color, borderThickness, x, y, w, h)
    local d = borderThickness / 2
    ctx:rectangle(x + d, y + d, w - 2*d, h - 2*d)
    ctx:set_line_width(borderThickness)
    ctx:set_source_rgba(color:toRGBA())
    ctx:stroke()
end

return draw
