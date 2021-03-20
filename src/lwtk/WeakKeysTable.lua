local weakKeysMeta = { __name = "lwtk.WeakKeysTable",
                       __mode = "k" }

local function WeakKeysTable()
    return setmetatable({}, weakKeysMeta)
end

return WeakKeysTable
