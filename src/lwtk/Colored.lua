local lwtk = require("lwtk")

local Colored = lwtk.newMixin("lwtk.Colored", lwtk.Styleable.NO_STYLE_SELECTOR,

    function(Colored, Super)
    
        local Super_onDraw = Super.onDraw
    
        function Colored.implement:onDraw(ctx, ...)
            local background = self:getStyleParam("BackgroundColor")
            if background then
                ctx:fillRect(background, 0, 0, self.w, self.h)
            end
            if Super_onDraw then
                Super_onDraw(self, ctx, ...)
            end
        end
    end
)

return Colored
