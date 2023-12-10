local inspect    = require"inspect"
local lwtk       = require"lwtk"
local Style      = lwtk.Style
local Color      = lwtk.Color
local Timer      = lwtk.Timer

local c = Color"ffa0b0"
print(c)
print(0.01 * c)

local get      = lwtk.StyleRef.get
local lighten  = lwtk.StyleRef.lighten
local saturate = lwtk.StyleRef.saturate

local style = lwtk.Style {
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
}

local selector = "textColor@<Widget><Button><PushButton>:<focus><hover>"

print(style:_getStyleParam("borderColor", "<xxx>", "<active><hover>"))
print(style:_getStyleParam("borderColor", "<Widget><Button><PushButton>", ""))
print(style:_getStyleParam("borderColor", "<Widget><Button><PushButton>", "<active>"))
print(style:_getStyleParam("borderColor", "<Widget><Button><PushButton>", "<active><hover>"))
print(style:_getStyleParam("borderColor", "<Widget><Button><PushButton>", "<active><hover2>"))

local Button     = lwtk.Button
local PushButton = lwtk.PushButton
local Group      = lwtk.Group

local app  = lwtk.Application("test01.lua", lwtk.Style {
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

MyGroup:declare("color")

local MyBox = lwtk.newClass("MyBox", lwtk.Widget)

MyBox:declare("color")

function MyBox:setColor(color)
    self.color = color
end

function MyBox.override:onDraw(ctx)
    local c = self:getStyleParam("Color")
    if self.id == "mb1" then
    --do
        --print(self.id, "color", c, self.state.hover)
        --print(self.id, "draw", self.x, self.y, self.w, self.h, c)
    end
    ctx:fillRect(c, 0, 0, self.w, self.h)
end

MyGroup.setColor = MyBox.setColor
MyGroup.override.onDraw = MyBox.onDraw

function MyBox.override:onMouseEnter(x, y)
--    print(self.id, "move", x, y)
    self:setState("hover", true)
end

function MyBox.override:onMouseLeave(x, y)
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

print(win1:childById("b1"))
print(win1:childById("mb1"))
assert(lwtk.type(win1:childById("mb1")) == "MyBox")
assert(lwtk.type(win1:childById("b1")) == "lwtk.Button")
assert(lwtk.type(win1:childById("b2")) == "lwtk.PushButton")
assert(win1:childById("b2"):isInstanceOf(PushButton))
assert(win1:childById("b2"):isInstanceOf(Button))
assert(win1:childById("b1"):isInstanceOf(Button))
assert(not win1:childById("b1"):isInstanceOf(PushButton))

local g1a = Group {
    id = "g1",
    Button {
        id = "b1a"
    }
}
local g1b = Group{ id = "g1"}

local g = win1:childById("group"):addChild(g1b)
assert(g == g1b)
assert(g1b == win1:childById("g1"))
g:addChild(g1a)
--print(win1:childById("b1"))
print(g:addChild(Button { id = "b3" }))
print(g:addChild(Button()):getStyleParam"borderColor")
local b = g:addChild(PushButton())
print(b, lwtk.type(b), getmetatable(b).__name)
b.state.xxx = true
print(b:getStyleParam"borderColor")
win1:show()
print(win1:getStyleParam"textSize")
print(win1:getCurrentTime())
print(win1:childById("group"):getCurrentTime())
print(win1:childById("b2"):getCurrentTime())

assert(win1:childById("b3"):parentById("g1") == g1b)
assert(win1:childById("b3"):parentById("g1") == g1b)
assert(win1:childById("b1a"):parentById("g1") == g1a)
assert(win1:childById("b1a"):parentById("g1"):parentById("g1") == g1b)
assert(g1a:parentById("g1") == g1b)

local t0 = require"mtmsg".time()
local timer
timer = Timer(function() 
    local t = require"mtmsg".time()
    t0 = t
    app:setTimer(0.020, timer)
    local x, y, w, h = win1:childById("mb2"):getFrame()
    win1:childById("mb2"):setFrame(-150 + app:getCurrentTime()*20, y, w, h)
end)
win1:childById("b2"):setTimer(0.015, timer)


app:runEventLoop()

