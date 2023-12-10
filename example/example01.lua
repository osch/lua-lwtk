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
        onInputChanged = function(widget, input)
                             widget:byId("b1"):setDisabled(input.text == "")
                         end,

        TitleText { text = "What's your name?" },

        TextInput { id = "i1", focus = true, style = { Columns = 40 } },

        Row {
            Space {},
            PushButton { id = "b1", text = "&OK",   disabled = true, 
                                                    default  = true,
                         onClicked = function(widget)
                                         local name = widget:byId("i1").text
                                         widget:byId("t2"):setText("Hello "..name.."!") 
                                         widget:byId("c1"):setVisible(false)
                                         widget:byId("c2"):setVisible(true)
                                     end },

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
            PushButton { id = "b3", text = "&Again",
                         onClicked = function(widget)
                                         widget:byId("i1"):setText("")
                                         widget:byId("i1"):setFocus()
                                         widget:byId("t2"):setText("")
                                         widget:byId("c2"):setVisible(false)
                                         widget:byId("c1"):setVisible(true)
                                     end  },

            PushButton { id = "b4", text = "&Quit", default = true,
                                                    onClicked = quit },
            Space {}
        }
    }
}

win:show()

app:runEventLoop()
