local floor = math.floor

local StyleRef = {}

function StyleRef.get(paramRef)
    return function(ctx)
        return ctx:get(paramRef)
    end
end

function StyleRef.round(paramRef)
    return function(ctx)
        return floor(ctx:get(paramRef) + 0.5)
    end
end

function StyleRef.scale(factor, paramRef)
    return function(ctx)
        return factor * ctx:get(paramRef)
    end
end

function StyleRef.add(amount, paramRef)
    return function(ctx)
        return amount + ctx:get(paramRef)
    end
end

function StyleRef.lighten(amount, colorRef)
    return function(ctx)
        local c = ctx:get(colorRef)
        return c and c:lighten(amount)
    end
end

function StyleRef.saturate(amount, colorRef)
    return function(ctx)
        return ctx:get(colorRef):saturate(amount)
    end
end

return StyleRef
