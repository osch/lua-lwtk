local lwtk = require"lwtk"

local Group       = lwtk.Group
local Widget      = lwtk.Widget
local Color       = lwtk.Color
local Column      = lwtk.Column
local Row         = lwtk.Row
local PushButton  = lwtk.PushButton
local TextInput   = lwtk.TextInput
local TitleText   = lwtk.TitleText
local Space       = lwtk.Space
local Window      = lwtk.Window


local W, H
local objs
local app, win

function love.load()
    love.window.setTitle("example20.love")
    love.keyboard.setKeyRepeat(true)
    
    W, H = love.graphics.getDimensions()
    
    app = lwtk.love.Application     
                    {
                        style = lwtk.DefaultStyle():addRules 
                        {
                            { "Opacity@Window", 0.95 },
                        }
                    }

    win = Window(app,
                    {   onSizeRequest = function(win, minW, minH, bestW, bestH, maxW, maxH) -- if not set, window will be centered
                            local x = (W - bestW)/2
                            local y = (H - bestH)/3
                            win:setFrame(x, y, bestW, bestH)
                        end,

                        Column {
                            id = "c1",
                            onInputChanged = function(widget, input)
                                widget:childById("b1"):setDisabled(input.text == "")
                            end,
                            TitleText { text = "What's your name?" },
                            TextInput { id = "i1", focus = true, style = { Columns = 40 } },
                            Row {
                                Space {},
                                PushButton { 
                                    id = "b1", text = "&OK", disabled = true, default  = true,
                                    onClicked = function(widget)
                                        widget:byId("c2/t2"):setText("Hello "..widget:byId("c1/i1").text.."!") 
                                        widget:byId("c1"):setVisible(false)
                                        widget:byId("c2"):setVisible(true)
                                    end
                                },
                    
                                PushButton { id = "b2", text = "&Quit", onClicked = love.event.quit },
                                Space {}
                            }
                        },

                        Column {
                            id = "c2",
                            visible = false,
                            Space {},
                            TitleText { id = "t2", style = { TextAlign = "center" } },
                            Space {},
                            Row {
                                Space {},
                                PushButton { 
                                    id = "b3", text = "&Again",
                                    onClicked = function(widget)
                                        widget:byId("c1/i1"):setText("")
                                        widget:byId("c1/i1"):setFocus()
                                        widget:byId("c2/t2"):setText("")
                                        widget:byId("c1"):setVisible(true)
                                        widget:byId("c2"):setVisible(false)
                                    end
                                },
                    
                                PushButton { id = "b4", text = "&Quit", default = true,
                                                                        onClicked = love.event.quit },
                                Space {}
                            }
                        }
                    })
    objs = {}
    local speed = 60                    
    for i = 1, 500 do
        objs[i] = { x = W/2 + W/3 * (math.random()-0.5), 
                    y = H/2 + H/3 * (math.random()-0.5), 
                    r = math.random(1, 5), 
                    dx = (math.random() < 0.5 and -1 or 1) * 10 * speed * (math.random()+0.01), 
                    dy = (math.random() < 0.5 and -1 or 1) *  2 * speed * (math.random()+0.01) }
    end
    win :show()
end

function love.update(dt)
    app:update()
    if not app:hasWindows() then
        love.event.quit()
    end
    for i, obj in ipairs(objs) do
        obj.x = obj.x + obj.dx * dt
        if obj.x < obj.r     then obj.x = obj.r;     obj.dx = -obj.dx end
        if obj.x > W - obj.r then obj.x = W - obj.r; obj.dx = -obj.dx end
        obj.y = obj.y + obj.dy * dt
        if obj.y < obj.r     then obj.y = obj.r;     obj.dy = -obj.dy end
        if obj.y > H - obj.r then obj.y = H - obj.r; obj.dy = -obj.dy end
        obj.dx = obj.dx * (1 - dt * 0.4)
        obj.dy = obj.dy * (1 - dt * 0.4)
    end
end

function love.draw()
    love.graphics.setColor(1, 0.9, 0, 0.9)
    for i, obj in ipairs(objs) do
        love.graphics.circle("fill", obj.x, obj.y, obj.r)
    end
    app:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
    app:mousemoved(x, y)
end

function love.mousepressed(x, y, button, istouch, presses)
    if not app:mousepressed(x, y, button) then
        for i, obj in ipairs(objs) do
            local bdx, bdy = obj.x - x, obj.y - y
            local bd = math.sqrt(bdx^2 + bdy^2)
            local a = 5000 * (bd + 0.01)^-1.5 
            obj.dx = obj.dx + a * bdx
            obj.dy = obj.dy + a * bdy
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    app:mousereleased(x, y, button)
end

function love.focus(focus)
    app:focus(focus)
end

function love.mousefocus(focus)
    app:mousefocus(focus)
end

function love.keypressed(key, scancode, isrepeat)
    app:keypressed(key)
end

function love.keyreleased(key, scancode)
    app:keyreleased(key)
end

function love.textinput(text)
    app:textinput(text)
end

