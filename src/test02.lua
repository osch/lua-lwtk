local lwtk = require("lwtk")

local Application = lwtk.Application
local Group       = lwtk.Group
local Widget      = lwtk.Widget
local Border      = lwtk.Border
local Bordered    = lwtk.Bordered
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
            local offs = self:getStyleParam("TextOffset")
            local tx = (w - ext.width)/2
            local ty = (h - ext.height)/2 + ext.height
            ctx:move_to(offs + math.floor(tx+0.5), offs + math.floor(ty+0.5)) -- sharper text
            ctx:show_text(self.text)
        end
    end
end
local MyGroup = newClass("MyGroup", Group)
do
    function MyGroup:onDraw(ctx)
        local w, h = self:getSize()
        fillRect(ctx, self:getStyleParam("Color"), 0, 0, w, h)
    end    
end

local app = Application("example01.lua")

app:setStyle {
    { "*TransitionSeconds:*",             0.05 },
    { "HoverTransitionSeconds:",          0.20 },
    { "HoverTransitionSeconds:hover",     0.20 },
    { "PressedTransitionSeconds:pressed", 0.20 },
    
    { "Color:*",                   Color"f9f9fa" },
    { "TextColor:*",               Color"000000" },
    { "TextSize:*",                13            },
    { "TextOffset:*",               0            },
    { "TextOffset:pressed+hover",   1            },

    { "BorderWidth:*",                       10  },
    { "BorderWidth@*MyGroup*:*",              3  },
    { "BorderWidth@Bordered(MyButton):*",     1  },

    { "Color@Border:*",                 Color"ff0000" },
    { "Color@Bordered*:*",              Color"0000ff" },
    
    { "Color@MyGroup:*",                Color"e1e1ff" },
    { "Color@MyButton:*",               Color"e1e1e2" },
    { "Color@MyButton:hover",           Color"c9c9ca" },
    { "Color@MyButton:pressed",         Color"c9c9ca" },
    { "Color@MyButton:pressed+hover",   Color"b1b1b2" },
}

local counter = 0

local win = app:newWindow {
    title = "example01",
    Group {
        id = "g0",
        MyButton {
            id = "b1",
            frame = {  10, 10, 100, 30 },
            text  = "OK",
            onClicked = function() print("Button Clicked") end
        },
        MyButton {
            id = "b2",
            frame = { 120, 10, 100, 30 },
            text  = "Exit",
            onClicked = function(self) 
                            self:getRoot():close()
                            --app:close() 
                        end
        },
        Bordered(MyGroup) {
            id = "g1",
            frame = {  10, 80, 200, 100 },
            MyButton {
                id = "b3",
                frame = { -40, -10, 100, 30 },
                text = "test",
                onClicked = function(self)
                                counter = counter + 1
                                local root = self:getRoot()
                                root.child.b1:setText("Clicked "..counter) 
                                local g2 = root.child.g2
                                local x, y, w, h = g2:getFrame()
                                g2:setFrame(x + 5, y, w + 5, h)
                                local x, y, w, h = self:getFrame()
                                self:setFrame(x + 2, y + 2, w, h)
                                local b5 = root.child.b5
                                local x, y, w, h = b5:getFrame()
                                b5:setFrame(x, y + 5, w + 5, h)
                            end
            }
        },
        Border {
            id = "g2",
            frame = { 230, 80, 200, 100 },
            MyButton {
                id = "b4",
                frame = { -40, -10, 100, 30 },
                text = "test",
            }
        },
        Bordered(MyButton) {
            id = "b5",
            frame = { 440, 80, 100, 50 },
            text = "test",
        }
    }
}

win:show()

app:runEventLoop()
