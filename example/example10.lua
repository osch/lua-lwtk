local lwtk = require("lwtk")

local Application = lwtk.Application
local Group       = lwtk.Group
local Widget      = lwtk.Widget
local Color       = lwtk.Color
local newClass    = lwtk.newClass
local fillRect    = lwtk.draw.fillRect

local MyButton = newClass("MyButton", Widget)
do
    function MyButton:setOnClicked(onClicked)
        self.onClicked = onClicked
    end
    function MyButton:setText(text)
        self.text = text
        self:triggerRedraw()
    end
    function MyButton:onMouseEnter(x, y)
        self:setState("hover", true)
    end
    function MyButton:onMouseLeave(x, y)
        self:setState("hover", false)
    end
    function MyButton:onMouseDown(x, y, button, modState)
        self:setState("pressed", true)
    end
    function MyButton:onMouseUp(x, y, button, modState)
        self:setState("pressed", false)
        if self.state.hover and self.onClicked then
            self:onClicked()
        end
    end
    function MyButton:onDraw(ctx)
        local w, h = self:getSize()
        fillRect(ctx, self:getStyleParam("BackgroundColor"), 0, 0, w, h)
        ctx:set_source_rgba(self:getStyleParam("TextColor"):toRGBA())
        if self.text then
            ctx:select_font_face("sans-serif", "normal", "normal")
            ctx:set_font_size(self:getStyleParam("TextSize"))
            local ext = ctx:text_extents(self.text)
            local offs = self:getStyleParam("TextOffset")
            local tx = (w - ext.width)/2
            local ty = (h - ext.height)/2 + ext.height
            ctx:move_to(offs + math.floor(tx+0.5), offs + math.floor(ty+0.5))
            ctx:show_text(self.text)
        end
    end
end

local app = Application {
    name  = "example10.lua", 
    style = {
        { "*TransitionSeconds",               0.05 },
        { "HoverTransitionSeconds:",          0.20 },
        { "HoverTransitionSeconds:hover",     0.20 },
        { "PressedTransitionSeconds:pressed", 0.20 },
        
        { "TextSize",                  13            },
        { "TextOffset",                 0            },
        { "TextOffset:pressed+hover",   1            },
        
        { "BackgroundColor",           Color"f9f9fa" },
        { "TextColor",                 Color"000000" },
    
        { "BackgroundColor@MyButton",                 Color"e1e1e2" },
        { "BackgroundColor@MyButton:hover",
          "BackgroundColor@MyButton:pressed",         Color"c9c9ca" },
        { "BackgroundColor@MyButton:pressed+hover",   Color"b1b1b2" },
    }
}

local scale = app.scale

local win = app:newWindow {
    title = "example10",
    size =  scale { 240, 50 },
    Group {
        MyButton {
            frame = scale {  10, 10, 100, 30 },
            text  = "OK",
            onClicked = function() print("Button Clicked") end
        },
        MyButton {
            frame = scale { 120, 10, 100, 30 },
            text  = "Exit",
            onClicked = function() app:close() end
        }
    }
}

win:show()

app:runEventLoop()
