local floor = math.floor

local StyleParamRef = {}

function StyleParamRef.get(paramRef)
    return function(ctx)
        return ctx:get(paramRef)
    end
end

function StyleParamRef.round(paramRef)
    return function(ctx)
        return floor(ctx:get(paramRef) + 0.5)
    end
end

function StyleParamRef.scale(factor, paramRef)
    return function(ctx)
        return factor * ctx:get(paramRef)
    end
end

function StyleParamRef.add(amount, paramRef)
    return function(ctx)
        return amount + ctx:get(paramRef)
    end
end

function StyleParamRef.lighten(amount, colorRef)
    return function(ctx)
        local c = ctx:get(colorRef)
        return c and c:lighten(amount)
    end
end

function StyleParamRef.saturate(amount, colorRef)
    return function(ctx)
        return ctx:get(colorRef):saturate(amount)
    end
end

return StyleParamRef
