local lua_version = _VERSION:match("[%d%.]*$")
local isOldLua = (#lua_version == 3 and lua_version < "5.3")

-------------------------------------------------------------------------------------------

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

PRINT("----------------------------------------------------------------------------------")
do
    local M1 = lwtk.newMixin("M1")
    function M1.initClass(M1, Super)   -- luacheck: ignore 431/M1
        function M1:new(value)
            Super.new(self, 1000 + value)
        end
        function M1:getValue()
            return 1000 + Super.getValue(self)
        end
    end
    function M1:getValue2()
        return 555
    end
    assert(lwtk.type(M1) == "lwtk.Mixin")
    assert(M1:is(lwtk.Mixin))
    assert(not M1:is(lwtk.Object))
    assert(not M1:is(lwtk.Class))
    assert(lwtk.Object.is(M1, lwtk.Mixin))
    assert(tostring(M1) == "lwtk.Mixin(M1)")
    local C1 = lwtk.newClass("C1")
    assert(C1:is(lwtk.Class))
    assert(not C1:is(lwtk.Object))
    assert(not C1:is(lwtk.Mixin))
    assert(lwtk.Object.is(C1, lwtk.Class))
    function C1:new(value)
        self.value = value + 1
    end
    function C1:getValue()
        return self.value + 1
    end
    assert(lwtk.type(C1) == "lwtk.Class")
    assert(tostring(C1) == "C1")

    local c1 = C1(100)

    assert(c1:is(lwtk.Object))
    assert(c1:is(C1))
    assert(not c1:is(lwtk.Class))
    assert(not c1:is(lwtk.Mixin))
    assert(lwtk.Object.is(c1, lwtk.Object))

    assert(lwtk.type(c1) == "C1")
    assert(tostring(c1):match("^C1: [0-9A-Za-z]+$"))
    assert(c1:getValue(), 102)
    assert(c1:getValue(), 102)

    local M1C1 = M1(C1)
    assertEq(lwtk.type(M1C1), "lwtk.Class")
    assertEq(tostring(M1C1), "M1")
    assertEq(M1C1.super, C1)
    
    local M1C1_2 = M1(C1)
    assertEq(lwtk.type(M1C1_2), "lwtk.Class")
    assertEq(tostring(M1C1_2), "M1")
    assertEq(M1C1_2.super, C1)
    assertEq(M1C1_2, M1C1)

    local m1c1 = M1C1(100)
    assertEq(lwtk.type(m1c1), "M1")
    assert(m1c1:getValue(), 2102)
    assert(m1c1:getValue(), 2102)
    assert(m1c1:getValue2(), 555)
    
    local C2 = lwtk.newClass("C2", M1(C1))
    assertEq(lwtk.type(C2), "lwtk.Class")
    assertEq(tostring(C2), "C2")
    assertEq(C2.super, M1C1)

    local c2 = C2(200)
    assertEq(lwtk.type(c2), "C2")
    assert(c2:getValue(), 2202)
    assert(c2:getValue(), 2202)
    
    local C3 = lwtk.newClass("C3", M1(M1(C1)))
    assertEq(lwtk.type(C3), "lwtk.Class")
    assertEq(tostring(C3), "C3")
    assertEq(lwtk.type(C3.super), "lwtk.Class")
    assertEq(tostring(C3.super),  "M1")
    assertEq(C3.super, M1(M1(C1)))

    local c3 = C3(300)
    assertEq(lwtk.type(c3), "C3")
    assert(c3:getValue(), 2304)
    assert(c3:getValue(), 2304)
end
PRINT("----------------------------------------------------------------------------------")
do
    local C1 = lwtk.newClass("C1")
    C1.a = "a1"
    C1.extra = {}
    C1.extra.b = "b1"
    function C1:m1(value)
        return value + 1
    end
    local C2 = lwtk.newClass("C2", C1)
    local c1 = C1()
    local c2 = C2()
    assert(c1:m1(1) == 2)
    assert(c2:m1(1) == 2)

    assert(C1.a == "a1")
    assert(C1.extra.b == "b1")
    assert(c1.a == "a1")
    assert(c1.extra.b == "b1")

    assert(C2.a == "a1")
    assert(C2.extra == nil)
    assert(c2.a == "a1")
    assert(c2.extra == nil)

    local C3 = lwtk.newClass("C3", C1)
    C3.extra = {}
    C3.extra.c = "c3"
    local c3 = C3()
    assert(c3:m1(2) == 3)
    assert(C3.extra.c == "c3")
    assert(c3.extra.c == "c3")
end
PRINT("----------------------------------------------------------------------------------")
do
    local M1 = lwtk.newMixin("M1")
    function M1.initClass(M1, Super)   -- luacheck: ignore 431/M1
    end
    local M2 = lwtk.newMixin("M2", M1)
    function M2.initClass(M2, Super)   -- luacheck: ignore 431/M2
    end
    assertEq(lwtk.type(M2), "lwtk.Mixin")
    assertEq(tostring(M2), "lwtk.Mixin(M2)")
    local C1 = lwtk.newClass("C1")
    assertEq(lwtk.type(C1), "lwtk.Class")
    local M2C1 = M2(C1)
    assertEq(lwtk.type(M2C1), "lwtk.Class")
    local C2 = lwtk.newClass("C2", M2C1)
    assertEq(lwtk.type(C2), "lwtk.Class")
    assertEq(tostring(C2), "C2")
    assertEq(tostring(C2.super), "M2")
    assertEq(tostring(C2.super.super), "M1")
    assertEq(tostring(C2.super.super.super), "C1")
end
PRINT("----------------------------------------------------------------------------------")
do
    local M1 = lwtk.newMixin("M1")
    function M1.initClass(M1, Super)   -- luacheck: ignore 431/M1
    end
    local M2 = lwtk.newMixin("M2")
    function M2.initClass(M2, Super)   -- luacheck: ignore 431/M2
    end
    local M3 = lwtk.newMixin("M3", M1, M2)
    function M3.initClass(M3, Super)   -- luacheck: ignore 431/M3
    end
    assertEq(lwtk.type(M3), "lwtk.Mixin")
    assertEq(tostring(M3), "lwtk.Mixin(M3)")
    local C1 = lwtk.newClass("C1")
    assertEq(lwtk.type(C1), "lwtk.Class")
    local M3C1 = M3(C1)
    assertEq(lwtk.type(M3C1), "lwtk.Class")
    local C2 = lwtk.newClass("C2", M3C1)
    assertEq(lwtk.type(C2), "lwtk.Class")
    assertEq(tostring(C2), "C2")
    assertEq(tostring(C2.super), "M3")
    assertEq(tostring(C2.super.super), "M1")
    assertEq(tostring(C2.super.super.super), "M2")
    assertEq(tostring(C2.super.super.super.super), "C1")
end
PRINT("----------------------------------------------------------------------------------")

local Group = lwtk.Group
local Color = lwtk.Color

do
    local g = Group{ Group { id = "g1" } }
    local c = lwtk.ChildLookup(g)
    assertEq(lwtk.type(c), "lwtk.ChildLookup")
    assert(tostring(c):match("^lwtk.ChildLookup: [0-9A-Za-z]+$"))
    for k, v in pairs(c) do
        assert(type(k) ~= "string")
    end
    assertEq(lwtk.type(c.g1), "lwtk.Group")
    assertEq(c.g1, g[1])
    assertEq(c.g1, g[1])
    assertEq(c.g1, g[1])
    g[1] = nil
    collectgarbage()
    assertEq(c.g1, nil)
    for k, v in pairs(c) do
        assert(type(k) ~= "string")
    end
end
PRINT("----------------------------------------------------------------------------------")
do
    local p = lwtk.PushButton()
    assertEq(lwtk.get.stylePath[p], "<lwtk.widget><lwtk.control><lwtk.button><lwtk.focusable><lwtk.pushbutton>")
    local t = lwtk.TextFragment()
    assertEq(lwtk.get.stylePath[t], nil)
end
PRINT("----------------------------------------------------------------------------------")
do
    assert(tostring(lwtk.Button) == "lwtk.Button")
    assert(tostring(lwtk.Button()):match("^lwtk.Button: [x0-9A-Fa-f]+$"))
    local ok, err = pcall(function() lwtk.Button()() end)
    
    if isOldLua then
        assert(not ok and err:match("attempt to call a .* value"))
    else
        assert(not ok and err:match("attempt to call a lwtk.Button value"))
    end
    
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
    
    assert(g1:childById("b1") ~= nil)
    assert(g1:childById("b2") ~= nil)
    assertEq(g1:childById("b2").text, "B2")
    assertEq(g1.root, nil)
    assertEq(g1:childById("b2"):getRoot(), g1)
    assertEq(g1:childById("b2"):getRoot(), g1)
    assertEq(g1:childById("b2"):getRoot():childById("b1").text, "B1")
    assertEq(g1:childById("b2"):byId("b1").text, "B1")
    assertEq(g1:getRoot(), g1)
    assertEq(g1:getRoot(), g1)
    
    local g2 = Group {
        g1
    }
    
    assertEq(g1:childById("b2"):getRoot(), g2)
    assertEq(g1:childById("b2"):getRoot(), g2)
    assert  (g2:childById("b2") ~= nil)
    assertEq(g2:childById("b2"):getRoot(), g2)
    
    local BorderedButton = lwtk.Bordered(lwtk.Button)
    assert(tostring(BorderedButton) == "lwtk.Bordered(lwtk.Button)")
    assert(tostring(BorderedButton()):match("^lwtk.Bordered%(lwtk.Button%)%: [x0-9A-Fa-f]+$"))
end
PRINT("----------------------------------------------------------------------------------")
do
    local PushButton = lwtk.PushButton
    local g = Group {
        Group {
            id = "g1",
            PushButton {
                id = "b1",
                text = "B11"
            }
        },
        Group {
            id = "g2",
            PushButton {
                id = "b1",
                text = "B21"
            }
        }
    }
    local b11 = g:childById("g1/b1")
    assertEq(b11.text, "B11")
    local b21 = b11:byId("g2/b1")
    assertEq(b21.text, "B21")
end
PRINT("----------------------------------------------------------------------------------")
do
    do
        local c = Color"ffa0b0"
        print(c)
        print(0.01 * c)
    end
    
    local get      = lwtk.StyleRef.get
    local lighten  = lwtk.StyleRef.lighten
    local saturate = lwtk.StyleRef.saturate
    
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
        ctx:set_source_rgb(c:toRGB())
        ctx:rectangle(0, 0, self.w, self.h)
        ctx:fill()
    end
    
    MyGroup.setColor = MyBox.setColor
    MyGroup.onDraw = MyBox.onDraw
    
    function MyBox:onMouseEnter(x, y)
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
    print(win1:childById("b1"))
    print(win1:childById("mb1"))
    assert(win1:childById("mb1").__name == "MyBox")
    assert(win1:childById("b1").__name == "lwtk.Button")
    assert(win1:childById("b2").__name == "lwtk.PushButton")
    assert(win1:childById("b2"):is(PushButton))
    assert(win1:childById("b2"):is(Button))
    assert(win1:childById("b1"):is(Button))
    assert(not win1:childById("b1"):is(PushButton))
    
    assertEq(win1:childById("mb3"):getStyleParam("Color"), Color"aa0000")
    assertEq(win1:childById("mb2"):getStyleParam("Color"), Color"0000aa")
    
    assertEq(Color"0000aa":lighten(0.1), Color"00dddc")

    win1:childById("mb2"):setState("hover", true)
    
    assertEq(win1:childById("mb2"):getStyleParam("Color"), Color"00dddc")
    
    local g1a = Group {
        id = "g1",
        Button {
            id = "b1"
        }
    }
    local g1b = Group{ 
        id = "g1",
        Button {
            id = "b1"
        }
    }
    
    local g = win1:childById("group"):addChild(g1b)
    assertEq(g, g1b)
    assertEq(g1b, win1:childById("g1"))
    
    assertEq(g1a:childById("b1"):parentById("g1"), g1a)
    
    assertEq(g1b:childById("b1"):parentById("g1"), g1b)
    assertEq(g1b:childById("b1"):parentById("group"), win1:childById("group"))
    assertEq(g1b:childById("b1"):parentById("group"):childById("g1"), win1:childById("g1"))
    
    win1:childById("g1"):addChild(g1a)
    local ok, err = pcall(function() win1:childById("g1") end)
    assert(not ok and err:match("ambiguous id"))
    ok, err = pcall(function() win1:byId("group"):childById("g1") end)
    assert(not ok and err:match("ambiguous id"))
    assertEq(g1a:childById("b1"):parentById("g1"), g1a)
    assertEq(g1a:childById("b1"):parentById("g1"):parentById("g1"), g1b)
    assertEq(g1a:childById("b1"):parentById("g1"):parentById("group"), win1:childById("group"))
end
PRINT("----------------------------------------------------------------------------------")
do
    local PushButton = lwtk.PushButton
    
    local g = Group {
        id = "g",
        Group {
            id = "g1",
            PushButton { id = "b1", text="g1b1" },
            PushButton { id = "b2", text="g1b2" },
        },
        Group {
            id = "g2",
            PushButton { id = "b1", text="g2b1" },
            PushButton { id = "b2", text="g2b2" },
        }
    }
    assertEq(g:childById("g1/b1").text, "g1b1")
    assertEq(g:childById("g1/b2").text, "g1b2")
    assertEq(g:childById("g2/b1").text, "g2b1")
    assertEq(g:childById("g2/b2").text, "g2b2")

    assertEq(g:childById("g1/b1"):byId("g/g2/b2").text, "g2b2")
    assertEq(g:childById("g2/b2"):byId("g/g1/b2").text, "g1b2")
    assertEq(g:childById("g2"):byId("g/g1"):childById("b1").text, "g1b1")
    assertEq(g:childById("g1"):byId("g/g2"):childById("b2").text, "g2b2")
end
PRINT("----------------------------------------------------------------------------------")
print("OK.")
