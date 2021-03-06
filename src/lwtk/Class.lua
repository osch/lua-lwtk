local Class = {
    __name = "lwtk.Class",
    __call = function(class, ...)
        local obj = setmetatable({}, class)
        local new = class.new
        if new then new(obj, ...) end
        return obj
    end,
    __tostring = function(class)
        return class.__name
    end
}
return Class
