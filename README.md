# lwtk - Lua Widget Toolkit
[![Licence](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)

This toolkit provides a foundation for building cross platform GUI widgets in
Lua on top of [LPugl]. For now only the cairo drawing backend is supported. 
Backend abstraction and support for other backends could be possible in the
future.

#### Supported platforms: 
   * X11
   * Windows
   * Mac OS X 


#### Further reading:
   TODO

## First Example

* Simple example that shows how a simple button widget class `MyButton` can
  be implemented using lwtk. Widget classes can define arbitrary states, i.e. the state 
  names `hover` and `pressed` are not known in the lwtk base classes, they
  could have also been called `foo` or `bar`.
  

    ```lua
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
            self:changeState("hover", true)
        end
        function MyButton:onMouseLeave(x, y)
            self:changeState("hover", false)
        end
        function MyButton:onMouseDown(x, y, button, modState)
            self:changeState("pressed", true)
        end
        function MyButton:onMouseUp(x, y, button, modState)
            self:changeState("pressed", false)
            if self.state.hover and self.onClicked then
                self:onClicked()
            end
        end
        function MyButton:onDraw(ctx)
            local w, h = self:getSize()
            fillRect(ctx, self:getStyleParam("Color"), 0, 0, w, h)
            ctx:set_source_rgba(self:getStyleParam("TextColor"):toRGBA())
            if self.text then
                ctx:select_font_face("sans-serif", "normal", "normal")
                ctx:set_font_size(self:getStyleParam("TextSize"))
                local ext = ctx:text_extents(self.text)
                local tx = (w - ext.width)/2
                local ty = (h - ext.height)/2 + ext.height
                ctx:move_to(math.floor(tx+0.5), math.floor(ty+0.5))
                ctx:show_text(self.text)
            end
        end
    end
    
    local app = Application("example01.lua")
    
    app:setStyle {
        { "*TransitionSeconds:*",             0.05 },
        { "HoverTransitionSeconds:",          0.20 },
        { "HoverTransitionSeconds:hover",     0.20 },
        
        { "Color:*",                   Color"f9f9fa" },
        { "TextSize:*",                13            },
        { "TextSize:pressed+hover",    11.5            },
        { "TextColor:*",               Color"000000" },
        
        { "Color@MyButton:*",               Color"e1e1e2" },
        { "Color@MyButton:hover",           Color"c9c9ca" },
        { "Color@MyButton:pressed",         Color"c9c9ca" },
        { "Color@MyButton:pressed+hover",   Color"b1b1b2" },
    }

    local win = app:newWindow {
        title = "example01",
        Group {
            MyButton {
                frame = {  10, 10, 100, 30 },
                text  = "OK",
                onClicked = function() print("Button Clicked") end
            },
            MyButton {
                frame = { 120, 10, 100, 30 },
                text  = "Exit",
                onClicked = function() app:close() end
            }
        }
    }

    win:show()
    app:runEventLoop()
    ```

[lpugl]:                    https://github.com/osch/lua-lpugl#lpugl
