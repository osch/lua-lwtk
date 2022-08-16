local lwtk = require("lwtk")

local Colored = lwtk.newMixin("lwtk.Colored", lwtk.Styleable.NO_STYLE_SELECTOR)

function Colored.initClass(Colored, Super)  -- luacheck: ignore 431/Colored

    local Super_onDraw = Super.onDraw

    function Colored:onDraw(ctx, ...)
        local background = self:getStyleParam("BackgroundColor")
        if background then
            ctx:fillRect(background, 0, 0, self.w, self.h)
        end
        if Super_onDraw then
            Super_onDraw(self, ctx, ...)
        end
    end
end

return Colored
