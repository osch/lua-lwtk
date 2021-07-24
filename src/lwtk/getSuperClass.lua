local lwtk = require("lwtk")

local superClass = lwtk.get.superClass

local function getSuperClass(class)
    return superClass[class]
end

return getSuperClass
