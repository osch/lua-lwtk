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

function Box:onDraw(ctx)
    print("onDraw", self.id)
end

function Box:getMeasures()
    return 0, 0, 20, 10, 200, 100
end

local function update(app)
    while app:update(0.020) do end
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
    assert(w3:getStyleParam("XXXSize") == 200)
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
    assert(b1:getStyleParam("XXXSize") == 101)
    assert(b2:getStyleParam("XXXSize") == 202)
end
PRINT("----------------------------------------------------------------------------------")
do
    local style = lwtk.Style {
        { "XXXSize", 1000 }
    }
    local app = lwtk.Application("test02", style)
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
    assert(b1:getStyleParam("XXXSize") == 1000)
    assert(b2:getStyleParam("XXXSize") == 2000)
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
    local b1 = win:childById("b1")
    local b2 = win:childById("b2")
    local b3 = win:childById("b3")
    local b4 = win:childById("b4")
    assert(b1:getStyleParam("XXXSize") == 1000)
    assert(b2:getStyleParam("XXXSize") == 20)
    assert(b3:getStyleParam("XXXSize") == 20)
    assert(b4:getStyleParam("XXXSize") == 20)
    assert(b1.state["state1"] == nil)
    b1:setState("state1", true)
    assert(b1.state["state1"] == true)
    assert(b1:getStyleParam("XXXSize") == 1000)
    update(app)
    assert(b1:getStyleParam("XXXSize") == 2000)
    b1:setState("state1", false)
    b1:setState("state2", true)
    b2:setState("state1", true)
    b3:setState("state1", true)
    b4:setState("state1", true)
    update(app)
    assertEq(b1:getStyleParam("XXXSize"), 3000)
    assertEq(b2:getStyleParam("XXXSize"), 2000)
    assertEq(b3:getStyleParam("XXXSize"), 20)
    assertEq(b4:getStyleParam("XXXSize"), 20)
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application {
        name = "test02", 
        style = {
            { "XXXSize@Box", 200 }
        }
    }
    local win1 = app:newWindow {
        Box { id = "b1" }
    }
    local win2 = app:newWindow {
        style = { { "XXXSize@Box", 100 } },
        Box { id = "b1" }
    }
    assertEq(win1:byId("b1"):getStyleParam("XXXSize"), 200)
    assertEq(win2:byId("b1"):getStyleParam("XXXSize"), 100)
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application {
        name = "test02", 
        style = {
            ["XXXSize@Box"] = 200
        }
    }
    local win1 = app:newWindow {
        Box { id = "b1" }
    }
    local win2 = app:newWindow {
        style = { { "XXXSize@Box", 100 } },
        Box { id = "b1" }
    }
    assertEq(win1:byId("b1"):getStyleParam("XXXSize"), 200)
    assertEq(win2:byId("b1"):getStyleParam("XXXSize"), 100)
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application("test02")
    app:addStyle { { "XXXSize", 200 } }
    local win1 = app:newWindow {
        Box { id = "b1" }
    }
    local win2 = app:newWindow {
        style = { { "XXXSize", 100 } },
        Box { id = "b1" }
    }
    assertEq(win1:byId("b1"):getStyleParam("XXXSize"), 200)
    assertEq(win2:byId("b1"):getStyleParam("XXXSize"), 100)
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application("test02")
    app:addStyle { XXXSize = 200 }
    local win1 = app:newWindow {
        Box { id = "b1" }
    }
    local win2 = app:newWindow {
        style = { XXXSize = 100 },
        Box { id = "b1" },
        Box { id = "b2", style = { XXXSize = 150 }},
    }
    assertEq(win1:byId("b1"):getStyleParam("XXXSize"), 200)
    assertEq(win2:byId("b1"):getStyleParam("XXXSize"), 100)
    assertEq(win2:byId("b2"):getStyleParam("XXXSize"), 150)
end
PRINT("----------------------------------------------------------------------------------")
do
    local app = lwtk.Application("test02")
    local win = app:newWindow {
        style = { XXXSize = 200 },
        lwtk.Group {
            Box { id = "b1" }
        }
    }
    assertEq(win:byId("b1"):getStyleParam("XXXSize"), 200)
end
PRINT("----------------------------------------------------------------------------------")
print("OK.")
