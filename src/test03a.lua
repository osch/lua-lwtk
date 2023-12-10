local lwtk = require("lwtk")

local Application = lwtk.Application
local Group       = lwtk.Group
local Widget      = lwtk.Widget
local Color       = lwtk.Color
local Row         = lwtk.Row
local Column      = lwtk.Column
local Space       = lwtk.Space
local newClass    = lwtk.newClass

local MyBox = newClass("MyBox", lwtk.Widget)
do
    MyBox:declare("measures")
    
    function MyBox.implement:onDraw(ctx)
        local w, h = self:getSize()
        ctx:fillRect(self:getStyleParam("Color"), 0, 0, w, h)
    end
    function MyBox.implement:getMeasures() 
        local m = self.measures
        return m[1], m[2], m[3], m[4], m[5], m[6]
    end
    function MyBox:setMeasures(m)
        self.measures = m
    end
end

local MyColumn = newClass("MyColumn", Column)
do
    function MyColumn.override:onDraw(ctx)
        local w, h = self:getSize()
        ctx:fillRect(self:getStyleParam("Color"), 0, 0, w, h)
    end
end


local app = Application("test03.lua")

app:setStyle {
    scaleFactor = 1,
    { "*Color",                    Color"f9f9fa" },
    { "Color@MyBox",               Color"0000ff" },
    { "Color@MyColumn",            Color"f0f0ff" },
    { "*Margin@MyBox",             10 }
    
}

local win = app:newWindow {
    title = "test03",
    Row {
    Column {
    MyColumn {
        id = "mc1",
        ---[=[
        MyBox {
            id = "a1",
            style = {
                { "Color", Color"ff0000" }
            },
            measures = { 200, 20, 
                         200, 60, 
                         400, -1 }
        },
        ---[[
        MyBox {
            id = "b1",
            style = {
                { "Color", Color"dd0000" }
            },
            measures = { 200, 20, 
                         200, 60, 
                         400, -1 }
        }, --]]
        ---[[
        MyBox {
            id = "b2",
            style = {
                { "Color", Color"dd0000" }
            },
            measures = { 200, 20, 
                         200, 60, 
                         400, -1 }
        }, --]]
        --]=]
        Row {
            id = "r1",
            MyBox {
                id = "c1",
                style = {
                    { "*Margin", 20 }
                },
                measures = { 200, 30, 
                             200, 50, 
                             300, 80 }
            }, 
            Space()
        }
    }}, 
    --Space() 
    }
}

win:show()

app:runEventLoop()
