local lwtk = require("lwtk")

local WeakKeysTable = lwtk.newMeta("lwtk.WeakKeysTable")

WeakKeysTable.__mode = "k"

return WeakKeysTable
