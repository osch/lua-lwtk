local lwtk = require"lwtk"

local get  = lwtk.get

local function undef(class)
    if type(class) == "table" then
        local objectMeta = get.objectMeta[class]
        for k, v in pairs(get) do
            v[class] = nil
            if objectMeta then
                v[objectMeta] = nil
            end
        end
        if objectMeta then
            for k, v in pairs(objectMeta) do
                objectMeta[k] = nil
            end
        end
        for k, v in pairs(class) do
            class[k] = nil
        end
    end
end
return undef
