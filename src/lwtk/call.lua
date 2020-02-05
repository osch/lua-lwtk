local function call(methodName, obj, ...)
    local method = obj[methodName]
    if method then
        return method(obj, ...)
    end
end
return call
