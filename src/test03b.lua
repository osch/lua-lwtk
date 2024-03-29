local lwtk = require("lwtk")

local Application = lwtk.Application
local Group       = lwtk.Group
local Widget      = lwtk.Widget
local Color       = lwtk.Color
local Row         = lwtk.Row
local newClass    = lwtk.newClass

local MyBox = newClass("MyBox", lwtk.Widget)
do
    MyBox:declare("measures")

    function MyBox.implement:onDraw(ctx)
        local w, h = self:getSize()
        ctx:fillRect(self:getStyleParam("Color"), 0, 0, w, h)
    end
    function MyBox:setMeasures(m)
        self.measures = m
    end
    function MyBox.implement:getMeasures() 
        local m = self.measures
        return m[1], m[2], m[3], m[4], m[5], m[6]
    end
end

local MyRow = newClass("MyRow", Row)
do
    function MyRow.implement:onDraw(ctx)
        local w, h = self:getSize()
        ctx:fillRect(self:getStyleParam("Color"), 0, 0, w, h)
    end
end


local app = Application("test03.lua")

app:setStyle {
    scaleFactor = 1,
    { "*Color",                    Color"f9f9fa" },
    { "Color@MyBox",               Color"0000ff" },
    { "Color@MyRow",               Color"f0f0ff" },
    { "*Margin",                   10 }
    
}

local win = app:newWindow {
    title = "test03",
    
    MyRow {
        MyBox {
            id = "b1",
            style = {
                { "Color", Color"ff0000" }
            },
            measures = { 100, 20, 
                         150, 80,
                         200, 80 }
        },
        MyBox {
            id = "b2",
            style = {
                { "Color", Color"00dd00" }
            },
            measures = { 100, 20, 
                         150, 80,
                         -1, 400 }
        },
        MyBox {
            id = "b3",
            style = {
                { "TopMargin", 20 }
            },
            measures = { 100, 50, 
                         150, 80,
                         200, 80 }
        }
    }
}

win:show()

app:runEventLoop()
