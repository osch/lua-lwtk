local lwtk = require("lwtk")

local Application    = lwtk.Application
local Column         = lwtk.Column
local Row            = lwtk.Row
local PushButton     = lwtk.PushButton
local TextInput      = lwtk.TextInput
local TitleText      = lwtk.TitleText
local Space          = lwtk.Space

local app = Application("example01.lua")

local function quit()
    app:close()
end

local win = app:newWindow {
    title = "example01",
    Column {
        id = "c1",
        TitleText { text = "What's your name?" },
        TextInput { id = "i1", focus = true, style = { Columns = 40 } },
        Row {
            Space {},
            PushButton { id = "b1", text = "&OK",   disabled = true, 
                                                    default  = true },

            PushButton { id = "b2", text = "&Quit", onClicked = quit },
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
            PushButton { id = "b3", text = "&Again" },

            PushButton { id = "b4", text = "&Quit", default = true,
                                                    onClicked = quit },
            Space {}
        }
    }
}

win:childById("c1"):setOnInputChanged(function(widget, input)
    widget:childById("b1"):setDisabled(input.text == "")
end)

win:childById("b1"):setOnClicked(function(widget)
    win:childById("t2"):setText("Hello "..win:childById("i1").text.."!") 
    win:childById("c1"):setVisible(false)
    win:childById("c2"):setVisible(true)
end)

win:childById("b3"):setOnClicked(function(widget)
    win:childById("i1"):setText("")
    win:childById("i1"):setFocus()
    win:childById("c1"):setVisible(true)
    win:childById("c2"):setVisible(false)
end)

win:show()

app:runEventLoop()
