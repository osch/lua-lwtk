local lwtk = require"lwtk"

-------------------------------------------------------------------------------------------

local function assertEq(a1, a2)
    if not (a1 == a2) then
        error("assertEq failed: "..tostring(a1).." <> "..tostring(a2), 2)
    end
end
local function PRINT(s)
    print(s.." ("..debug.getinfo(2).currentline..")")
end
local function msgh(err)
    return debug.traceback(err, 2)
end
local function pcall(f, ...)
    return xpcall(f, msgh, ...)
end

-------------------------------------------------------------------------------------------

local Group = lwtk.Group
local Style = lwtk.Style
local Color = lwtk.Color
local Timer = lwtk.Timer

-------------------------------------------------------------------------------------------

do
    assert(tostring(lwtk.Button) == "lwtk.Button")
    assert(tostring(lwtk.Button()):match("^lwtk.Button: [x0-9A-Fa-f]+$"))
    local ok, err = pcall(function() lwtk.Button()() end)
    assert(not ok and err:match("attempt to call a lwtk.Button value"))
    
    local MyButton = lwtk.newClass("MyButton", lwtk.Widget)
    do
        function MyButton:setText(text)
            self.text = text
            self:triggerRedraw()
        end
    end
    
    assertEq(tostring(MyButton), "MyButton")
    assert(tostring(MyButton()):match("^MyButton: [x0-9A-Fa-f]+$"))
    
    local g1 = Group {
        MyButton {
            id = "b1",
            text = "B1"
        },
        MyButton {
            id = "b2",
            text = "B2"
        }
    }
    
    assertEq(g1.child.b2.text, "B2")
    assertEq(g1.child.b2:getRoot(), g1)
    assertEq(g1.child.b2:getRoot(), g1)
    assertEq(g1.child.b2:getRoot().child.b1.text, "B1")
    assertEq(g1:getRoot(), g1)
    assertEq(g1:getRoot(), g1)
    
    local g2 = Group {
        g1
    }
    
    assertEq(g1.child.b2:getRoot(), g2)
    assertEq(g1.child.b2:getRoot(), g2)
    assertEq(g2.child.b2:getRoot(), g2)
    
    local BorderedButton = lwtk.Bordered(lwtk.Button)
    assert(tostring(BorderedButton) == "lwtk.Bordered(lwtk.Button)")
    assert(tostring(BorderedButton()):match("^lwtk.Bordered%(lwtk.Button%)%: [x0-9A-Fa-f]+$"))
end

PRINT("----------------------------------------------------------------------------------")
do
    local c = Color"ffa0b0"
    print(c)
    print(0.01 * c)
    
    local get      = lwtk.StyleParamRef.get
    local lighten  = lwtk.StyleParamRef.lighten
    local saturate = lwtk.StyleParamRef.saturate
    
    local style = lwtk.Style {
        { "backgroundColor",                      Color"ffffff" },

        { "aaaColor",                             Color"000002" },
        { "textColor",                            Color"000001" },
        { "textColor@Button",                     Color"0000f1" },
        { "textColor@PushButton",                 Color"a08080" },
        { "textColor@PushButton:hover+selected:", Color"a0a0a0" },
    
        { "borderColor@*",                     get"textColor" },
        { "borderColor@PushButton",            Color"808081" },
        { "borderColor@PushButton:active",     get"aaaColor" },
        { "borderColor@PushButton:hover",      lighten(0.2, get"textColor") },
        { "borderColor@PushButton:hover2",     saturate(0.5, get"textColor") },
        { "borderColor@PushButton:hover3",     get"bbbColor" },
        { "bbbColor::",                         Color"000003" },
    }
    
    local selector = "textColor@<Widget><Button><PushButton>:<focus><hover>"
    
    assertEq(Color"000001":lighten(0.2),  Color"006766")
    assertEq(Color"a08080":lighten(0.2),  Color"cbbaba")
    assertEq(Color"a08080":saturate(0.5), Color"a03030")
     
    assertEq(style:_getStyleParam("borderColor", "<xxx>", "<active><hover>"),         Color"000001")
    assertEq(style:_getStyleParam("borderColor", "<widget><button><pushbutton>", ""), Color"808081")
    assertEq(style:_getStyleParam("borderColor", "<widget><button><pushbutton>", "<active>"), Color"000002")
    print("***")
    assertEq(style:_getStyleParam("borderColor", "<widget><button><pushbutton>", "<active><hover>"), Color"cbbaba")
    assertEq(style:_getStyleParam("borderColor", "<widget><button><pushbutton>", "<active><hover2>"), Color"a03030")
    assertEq(style:_getStyleParam("borderColor", "<widget><button><pushbutton>", "<hover3>"), Color"000003")
    
    local Button     = lwtk.Button
    local PushButton = lwtk.PushButton
    local Group      = lwtk.Group
    
    local app  = lwtk.Application 
    {
        name  = "test01.lua",
    
        style = {
            { "TextSize",                    13            },
            { "BackgroundColor",             Color"ffffff" },
            { "TextColor",                   Color"000000" },
            { "BorderColor",                 Color"000000" },
            { "*TransitionSeconds",          0 },
            
            { "TextColor@Button",            Color"0000f1" },
            { "TextColor@PushButton",        Color"a08080" },
            { "TextColor@PushButton:hover+selected", Color"a0a0a0" },
        
            { "BorderColor",                             get"TextColor" },
            { "BorderColor@PushButton",                  Color"808081" },
            { "BorderColor@PushButton:active",           get"TextColor" },
            { "BorderColor@PushButton:hover",            lighten(0.2, get"TextColor") },
            { "BorderColor@PushButton:hover2",           saturate(0.5, get"TextColor") },
            { "Color",                                   Color"808080" },
            { "Color@MyBox",                             Color"aa0000" },
            { "Color@MyBox:hover",                       lighten(0.1, get"Color") }
        }
    }
    
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
            MyBox {
                id = "mb3",
                frame = { 150, 10, 100, 30 },
                style = {}
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
    
    assertEq(win1.child.mb3:getStyleParam("Color"), Color"aa0000")
    assertEq(win1.child.mb2:getStyleParam("Color"), Color"0000aa")
    
    assertEq(Color"0000aa":lighten(0.1), Color"00dddc")

    win1.child.mb2:setState("hover", true)
    
    assertEq(win1.child.mb2:getStyleParam("Color"), Color"00dddc")
    
    local g1a = Group {
        id = "g1",
        Button {
            id = "b1"
        }
    }
    local g1b = Group{ id = "g1"}
    
    local g = win1.child.group:addChild(g1b)
    assert(g1b == win1.child.g1)
end
PRINT("----------------------------------------------------------------------------------")
print("OK.")
