local inspect    = require"inspect"
local lwtk       = require"lwtk"
local StyleParams= lwtk.StyleParams
local Color      = lwtk.Color
local Timer      = lwtk.Timer

local c = Color"ffa0b0"
print(c)
print(0.01 * c)

local get      = lwtk.StyleParamRef.get
local lighten  = lwtk.StyleParamRef.lighten
local saturate = lwtk.StyleParamRef.saturate

local styleParams = lwtk.StyleParams(lwtk.DefaultStyleTypes(), lwtk.StyleRules {
    { "backgroundColor",                      Color"ffffff" },
    
    { "textColor",                            Color"000000" },
    { "textColor@Button",                     Color"0000f1" },
    { "textColor@PushButton",                 Color"a08080" },
    { "textColor@PushButton:hover+selected:", Color"a0a0a0" },

    { "borderColor@*",                           get"textColor" },
    { "borderColor@PushButton",          Color"808081" },
    { "borderColor@PushButton:active", get"textColor" },
    { "borderColor@PushButton:hover",  lighten(0.2, get"textColor") },
    { "borderColor@PushButton:hover2", saturate(0.5, get"textColor") }
})

local selector = "textColor@<Widget><Button><PushButton>:<focus><hover>"

print(styleParams:getStyleParam("borderColor", "<xxx>", "<active><hover>"))
print(styleParams:getStyleParam("borderColor", "<Widget><Button><PushButton>", ""))
print(styleParams:getStyleParam("borderColor", "<Widget><Button><PushButton>", "<active>"))
print(styleParams:getStyleParam("borderColor", "<Widget><Button><PushButton>", "<active><hover>"))
print(styleParams:getStyleParam("borderColor", "<Widget><Button><PushButton>", "<active><hover2>"))

local Button     = lwtk.Button
local PushButton = lwtk.PushButton
local Group      = lwtk.Group

local app  = lwtk.Application("test01.lua", lwtk.StyleRules {
        { "TextSize",                  13            },
        { "BackgroundColor",           Color"ffffff" },
        { "TextColor",                 Color"000000" },
        { "BorderColor",               Color"000000" },
        { "*TransitionSeconds",        0.5 },
        
        { "TextColor@Button",          Color"0000f1" },
        { "TextColor@PushButton",      Color"a08080" },
        { "TextColor@PushButton:hover+selected", Color"a0a0a0" },
    
        { "BorderColor",                             get"TextColor" },
        { "BorderColor@PushButton",                  Color"808081" },
        { "BorderColor@PushButton:active",           get"TextColor" },
        { "BorderColor@PushButton:hover",            lighten(0.2, get"TextColor") },
        { "BorderColor@PushButton:hover2",           saturate(0.5, get"TextColor") },
        { "Color",                                   Color"808080" },
        { "Color@MyBox",                             Color"aa0000" },
        { "Color@MyBox:hover",                       lighten(0.1, get"Color") }
})

local MyGroup = lwtk.newClass("MyGroup", lwtk.Group)

local MyBox = lwtk.newClass("MyBox", lwtk.Widget)

function MyBox:setColor(color)
    self.color = color
end

function MyBox:onDraw(ctx)
    local c = self:getStyleParam("Color")
    if self.id == "mb1" then
    --do
        --print(self.id, "color", c, self.state.hover)
        --print(self.id, "draw", self.x, self.y, self.w, self.h, c)
    end
    ctx:set_source_rgb(c:toRGB())
    ctx:rectangle(0, 0, self.w, self.h)
    ctx:fill()
end

MyGroup.setColor = MyBox.setColor
MyGroup.onDraw = MyBox.onDraw

function MyBox:onMouseEnter(x, y)
--    print(self.id, "move", x, y)
    self:setState("hover", true)
end

function MyBox:onMouseLeave(x, y)
--    print(self.id, "leave", x, y)
    self:setState("hover", false)
end

local win1 = app:newWindow {
    title = "test01-1",
    MyGroup {
        id = "group",
        color = Color"a0a0a0",
        MyBox {
            id = "mb1",
            frame = { 30, 20, 100, 30 },
            color = Color"ff0000"
        },
        MyBox {
            id = "mb2",
            frame = { 150, 10, 100, 30 },
            style = {
                { "Color::",  Color"0000aa" },
              --{ "Color:hover", Color"00aa00" }
            }
        },
        Button {
            id = "b1",
        },
        PushButton {
            id = "b2",
        }
    }
}

--local b0 = win1.child.child.xxx
print(win1.child.b1)
print(win1.child.mb1)
assert(win1.child.mb1.__name == "MyBox")
assert(win1.child.b1.__name == "lwtk.Button")
assert(win1.child.b2.__name == "lwtk.PushButton")
assert(win1.child.b2:is(PushButton))
assert(win1.child.b2:is(Button))
assert(win1.child.b1:is(Button))
assert(not win1.child.b1:is(PushButton))

local g1a = Group {
    id = "g1",
    Button {
        id = "b1"
    }
}
local g1b = Group{ id = "g1"}

local g = win1.child.group:addChild(g1b)
assert(g1b == win1.child.g1)
g:addChild(g1a)
--print(win1.child.b1)
print(g:addChild(Button()))
print(g:addChild(Button()):getStyleParam"borderColor")
local b = g:addChild(PushButton())
print(b, b.__name, b.className)
b.state.xxx = true
print(b:getStyleParam"borderColor")
win1:show()
print(win1:getStyleParam"textSize")
print(win1:getCurrentTime())
print(win1.child.group:getCurrentTime())
print(win1.child.b2:getCurrentTime())


local t0 = require"mtmsg".time()
local timer
timer = Timer(function() 
    local t = require"mtmsg".time()
    t0 = t
    app:setTimer(0.020, timer)
    local x, y, w, h = win1.child.mb2:getFrame()
    win1.child.mb2:setFrame(-150 + app:getCurrentTime()*20, y, w, h)
end)
win1.child.b2:setTimer(0.015, timer)


app:runEventLoop()

