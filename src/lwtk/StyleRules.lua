local lwtk = require("lwtk")

local StyleRules  = lwtk.newClass("lwtk.StyleRules")

function StyleRules:new(initParams)
    for i = 1, #initParams do
        self[i] = initParams[i]
        initParams[i] = nil
    end
    self.scaleFactor = initParams.scaleFactor
    initParams.scaleFactor = nil
    self:setAttributes(initParams)
end

return StyleRules
