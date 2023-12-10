local lwtk = require("lwtk")

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

local Box = lwtk.newClass("Box", lwtk.Widget)

function Box.implement:onDraw(ctx)
    print("onDraw", self.id)
end

function Box.implement:getMeasures()
    return 0, 0, 20, 10, 200, 100
end

local function update(app)
    while app:update(0.200) do end
    print("========== updated =======")
end

PRINT("----------------------------------------------------------------------------------")
do
    local style = lwtk.Style {}
    local app = lwtk.Application("test02", { style = style })
    local b1 = Box{}
    assert(b1:getStyleParam("XXXSize") == nil)
    local b2 = Box{
        style = {
            { "XXXSize", 100 }
        }
    }
    assertEq(b2:getStyleParam("XXXSize"), 100)
    local win1 = app:newWindow {
        Box {
            id = "w3",
            style = {
                { "XXXSize", 200 }
            }
        }
    }
    local w3 = win1:childById("w3")
    assert(w3:getStyleParam("XXXSize") == app.scale(200))
end
PRINT("----------------------------------------------------------------------------------")
do
    local style = lwtk.Style {}
    local app = lwtk.Application("test02", style)
    local win = app:newWindow {
        Box {
            id = "b1",
            style = {
                { "XXXSize", 101 }
            }
        },
        Box {
            id = "b2",
            style = {
                { "XXXSize", 202 }
            }
        }
    }
    local b1 = win:childById("b1")
    local b2 = win:childById("b2")
    assert(b1:getStyleParam("XXXSize") == app.scale(101))
    assert(b2:getStyleParam("XXXSize") == app.scale(202))
end
PRINT("----------------------------------------------------------------------------------")
do
    local style = lwtk.Style {
        { "XXXSize", 1000 }
    }
    local app = lwtk.Application("test02", style)
    local scale = app.scale
    local win = app:newWindow {
        Box {
            id = "b1",
        },
        Box {
            id = "b2",
            style = {
                { "XXXSize", 2000 }
            }
        }
    }
    local b1 = win:childById("b1")
    local b2 = win:childById("b2")
    assert(b1:getStyleParam("XXXSize") == scale(1000))
    assert(b2:getStyleParam("XXXSize") == scale(2000))
end
PRINT("----------------------------------------------------------------------------------")
do
    local style = lwtk.Style  {
        { "*TransitionSeconds", 0.001 },
        { "XXXSize",            1000 },
        { "XXXSize:state1",     2000 },
        { "XXXSize:state2",     3000 },
    }
    local app = lwtk.Application("test02", style)
    local win = app:newWindow {
        lwtk.Column {
            Box {
                id = "b1",
            },
            Box {
                id = "b2",
                style = {
                    { "XXXSize::", 20 }
                }
            },
            Box {
                id = "b3",
                style = {
                    { "XXXSize", 20 }
                }
            },
            Box {
                id = "b4",
                style = {
                    { "XXXSize:", 20 }
                }
            }
        }
    }
    win:show()
    update(app)
    local scale = app.scale
    
    local b1 = win:childById("b1")
    local b2 = win:childById("b2")
    local b3 = win:childById("b3")
    local b4 = win:childById("b4")
    assert(b1:getStyleParam("XXXSize") == scale(1000))
    assert(b2:getStyleParam("XXXSize") == scale(20))
    assert(b3:getStyleParam("XXXSize") == scale(20))
    assert(b4:getStyleParam("XXXSize") == scale(20))
    assert(b1.state["state1"] == nil)
    b1:setState("state1", true)
    assert(b1.state["state1"] == true)
    assert(b1:getStyleParam("XXXSize") == scale(1000))
    PRINT("Updating...")
    local t0 = app:getCurrentTime()
    update(app)
    PRINT(string.format("Updated (%.3f secs)", app:getCurrentTime() - t0))
    PRINT(b1:getStyleParam("XXXSize"))
    assert(b1:getStyleParam("XXXSize") == scale(2000))
    b1:setState("state1", false)
    b1:setState("state2", true)
    b2:setState("state1", true)
    b3:setState("state1", true)
    b4:setState("state1", true)
    PRINT("Updating...")
    local t0 = app:getCurrentTime()
    update(app)
    PRINT(string.format("Updated (%.3f secs)", app:getCurrentTime() - t0))
    assertEq(b1:getStyleParam("XXXSize"), scale(3000))
    assertEq(b2:getStyleParam("XXXSize"), scale(2000))
    assertEq(b3:getStyleParam("XXXSize"), scale(20))
    assertEq(b4:getStyleParam("XXXSize"), scale(20))
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application {
        name = "test02", 
        style = {
            { "XXXSize@Box", 200 }
        }
    }
    local scale = app.scale
    local win1 = app:newWindow {
        Box { id = "b1" }
    }
    local win2 = app:newWindow {
        style = { { "XXXSize@Box", 100 } },
        Box { id = "b1" }
    }
    assertEq(win1:byId("b1"):getStyleParam("XXXSize"), scale(200))
    assertEq(win2:byId("b1"):getStyleParam("XXXSize"), scale(100))
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application {
        name = "test02", 
        style = {
            { "X1Size", 100 }
        }
    }
    local win = app:newWindow {
        style = {
            X2Size = 2,
            { "X2Size", 200 }
        },
        lwtk.Group { 
            id = "g1",
            style = {
                X2Size = 201,
                { "X1Size", 101 }
            },
            Box {
                id = "b11"
            },
            Box {
                id = "b12",
                style = {
                    X1Size = 102,
                    { "X2Size", 202 }
                }
            }
        },
        lwtk.Group { 
            id = "g2",
            style = {
                X2Size = 302,
                { "X1Size@Box", 301 }
            },
            Box {
                id = "b21"
            },
            Box {
                style = {
                    X2Size = 402
                },
                id = "b22"
            }
        }
    }
    local scale = app.scale
    
    assertEq(win:getStyleParam("X2Size"), scale(2))

    assertEq(win:byId("g1" ):getStyleParam("X1Size"), scale(101))
    assertEq(win:byId("g1" ):getStyleParam("X2Size"), scale(201))
    assertEq(win:byId("b11"):getStyleParam("X1Size"), scale(101))
    assertEq(win:byId("b11"):getStyleParam("X2Size"), scale(200))
    assertEq(win:byId("b12"):getStyleParam("X1Size"), scale(102))
    assertEq(win:byId("b12"):getStyleParam("X2Size"), scale(202))

    assertEq(win:byId("g2" ):getStyleParam("X1Size"), scale(100))
    assertEq(win:byId("g2" ):getStyleParam("X2Size"), scale(302))
    assertEq(win:byId("b21"):getStyleParam("X1Size"), scale(301))
    assertEq(win:byId("b21"):getStyleParam("X2Size"), scale(200))
    assertEq(win:byId("b22"):getStyleParam("X1Size"), scale(301))
    assertEq(win:byId("b22"):getStyleParam("X2Size"), scale(402))
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application("test02")
    local scale = app.scale
    app:addStyle { { "XXXSize", 200 } }
    local win1 = app:newWindow {
        Box { id = "b1" }
    }
    local win2 = app:newWindow {
        style = { { "XXXSize", 100 } },
        Box { id = "b1" }
    }
    assertEq(win1:byId("b1"):getStyleParam("XXXSize"), scale(200))
    assertEq(win2:byId("b1"):getStyleParam("XXXSize"), scale(100))
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application("test02")
    local scale = app.scale
    app:addStyle { XXXSize = 200 }
    local win1 = app:newWindow {
        Box { id = "b1" }
    }
    local win2 = app:newWindow {
        style = { XXXSize = 100 },
        Box { id = "b1" },
        Box { id = "b2", style = { XXXSize = 150 }},
    }
    assertEq(win1:byId("b1"):getStyleParam("XXXSize"), nil)
    assertEq(win2:byId("b1"):getStyleParam("XXXSize"), nil)
    assertEq(win2:byId("b2"):getStyleParam("XXXSize"), scale(150))
    assertEq(win2:getStyleParam("XXXSize"), scale(100))
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application("test02")
    local scale = app.scale
    local win = app:newWindow {
        style = { XXXSize = 200 },
        lwtk.Group {
            Box { id = "b1" }
        }
    }
    assertEq(win:getStyleParam("XXXSize"), scale(200))
    assertEq(win:byId("b1"):getStyleParam("XXXSize"), nil)
end
PRINT("----------------------------------------------------------------------------------")
do
    local b = Box {}
    local style = lwtk.Style { 
        { "FooWidth", 10 },
        { "BarWidth", 20 }
    }
    assertEq(style:getStyleParam(b, "FooWidth"), 10)
    assertEq(style:getStyleParam(b, "BarWidth"), 20)
    style:setScaleFactor(2)
    assertEq(style:getStyleParam(b, "FooWidth"), 20)
    assertEq(style:getStyleParam(b, "BarWidth"), 40)
end
PRINT("----------------------------------------------------------------------------------")
do
    local g = lwtk.Group {
        style = {
            { "FooWidth",  5 },
            { "BarWidth", 20 }
        },
        lwtk.Group {
            id = "g1",
            style = {
                scaleFactor = 2
            },
            Box {
                id = "b1"
            }
        },
        Box {
            id = "b"
        },
    }
    assertEq(g:getStyleParam("FooWidth"),  5)
    assertEq(g:getStyleParam("BarWidth"), 20)
    assertEq(g:childById("b"):getStyleParam("FooWidth"),  5)
    assertEq(g:childById("b"):getStyleParam("BarWidth"), 20)

    assertEq(g:childById("g1"):getStyleParam("FooWidth"), 10)
    assertEq(g:childById("g1"):getStyleParam("BarWidth"), 40)
    assertEq(g:childById("b1"):getStyleParam("FooWidth"), 10)
    assertEq(g:childById("b1"):getStyleParam("BarWidth"), 40)
    
    assertEq(g:getStyle():getScaleFactor(), 1)
    assertEq(g:childById("g1"):getStyle():getScaleFactor(), 2)

    g:getStyle():setScaleFactor(3)
    assertEq(g:getStyle():getScaleFactor(), 3)
    assertEq(g:childById("g1"):getStyle():getScaleFactor(), 6)
    
    assertEq(g:getStyleParam("FooWidth"), 15)
    assertEq(g:getStyleParam("BarWidth"), 60)
    assertEq(g:childById("b"):getStyleParam("FooWidth"), 15)
    assertEq(g:childById("b"):getStyleParam("BarWidth"), 60)

    assertEq(g:childById("g1"):getStyleParam("FooWidth"), 30)
    assertEq(g:childById("g1"):getStyleParam("BarWidth"),120)
    assertEq(g:childById("b1"):getStyleParam("FooWidth"), 30)
    assertEq(g:childById("b1"):getStyleParam("BarWidth"),120)
    
    g:setStyle {
        scaleFactor = 4,
        { "FooWidth",  6 },
        { "BarWidth", 11 }
    }

    assertEq(g:getStyleParam("FooWidth"), 4 *  6)
    assertEq(g:getStyleParam("BarWidth"), 4 * 11)
    assertEq(g:childById("b"):getStyleParam("FooWidth"),  4 *  6)
    assertEq(g:childById("b"):getStyleParam("BarWidth"),  4 * 11)

    assertEq(g:childById("g1"):getStyleParam("FooWidth"), 2 * 4 *  6)
    assertEq(g:childById("g1"):getStyleParam("BarWidth"), 2 * 4 * 11)
    assertEq(g:childById("b1"):getStyleParam("FooWidth"), 2 * 4 *  6)
    assertEq(g:childById("b1"):getStyleParam("BarWidth"), 2 * 4 * 11)
end
PRINT("----------------------------------------------------------------------------------")
do
    local g = lwtk.Group {
        style = {
            { "FooWidth",  5 },
            FooWidth = 10
        },
        lwtk.Group {
            id = "g1",
        },
    }
    assertEq(g:getStyleParam("FooWidth"), 10)
    assertEq(g:childById("g1"):getStyleParam("FooWidth"), 5)
    assertEq(lwtk.get.style[g].localParams.foowidth, 10)
    assertEq(lwtk.get.style[g].cache["foowidth@<lwtk.widget><lwtk.group>:"], 5)
end
PRINT("----------------------------------------------------------------------------------")
do
    local g = lwtk.Group {
        style = {
            { "FooWidth",  5 },
            { "xWidth",  lwtk.StyleRef.get("FooWidth") },
            { "yWidth",  lwtk.StyleRef.scale(2, "FooWidth") },
            FooWidth = 3
        },
        lwtk.Group {
            id = "g1",
        },
        lwtk.Group {
            id = "g2",
            style = {
                FooWidth = 1000
            }
        },
    }
    assertEq(g:getStyleParam("FooWidth"), 3)
    assertEq(g:getStyleParam("xWidth"),   3)
    assertEq(g:getStyleParam("yWidth"),   6)
    assertEq(g:childById("g1"):getStyleParam("FooWidth"), 5)
    assertEq(g:childById("g1"):getStyleParam("xWidth"), 5)
    assertEq(g:childById("g1"):getStyleParam("yWidth"), 10)
    assertEq(g:childById("g2"):getStyleParam("FooWidth"), 1000)
    assertEq(g:childById("g2"):getStyleParam("xWidth"), 1000)
    assertEq(g:childById("g2"):getStyleParam("yWidth"), 2000)
end
PRINT("----------------------------------------------------------------------------------")
do
    local g = lwtk.Group {
        style = {
            { "FooWidth",  5 },
            { "xWidth",  lwtk.StyleRef.get("FooWidth") },
            { "yWidth",  lwtk.StyleRef.scale(2, lwtk.StyleRef.get("FooWidth")) },
            FooWidth = 3
        },
        lwtk.Group {
            id = "g1",
        },
        lwtk.Group {
            id = "g2",
            style = {
                FooWidth = 1000
            }
        },
    }
    assertEq(g:getStyleParam("FooWidth"), 3)
    assertEq(g:getStyleParam("xWidth"),   3)
    assertEq(g:getStyleParam("yWidth"),   6)
    assertEq(g:childById("g1"):getStyleParam("FooWidth"), 5)
    assertEq(g:childById("g1"):getStyleParam("xWidth"), 5)
    assertEq(g:childById("g1"):getStyleParam("yWidth"), 10)
    assertEq(g:childById("g2"):getStyleParam("FooWidth"), 1000)
    assertEq(g:childById("g2"):getStyleParam("xWidth"), 1000)
    assertEq(g:childById("g2"):getStyleParam("yWidth"), 2000)
end
PRINT("----------------------------------------------------------------------------------")
print("OK.")
