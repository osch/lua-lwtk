local draw = {}

function draw.fillRect(ctx, color, x, y, w, h)
    ctx:set_source_rgba(color:toRGBA())
    ctx:rectangle(x, y, w, h)
    ctx:fill()
end

return draw
