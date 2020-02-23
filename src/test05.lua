local lwtk = require"lwtk"

local Application = lwtk.Application
local Column      = lwtk.Column
local Row         = lwtk.Row
local Matrix      = lwtk.Matrix
local Space       = lwtk.Space
local PushButton  = lwtk.PushButton

local app = Application("test04.lua")

local win = app:newWindow {
    title = "test04",
    Row {
        Matrix {
            {
                PushButton { text = "OK" }, 
                PushButton { text = "OK" }, 
                PushButton { text = "Click now and here!" },
            },
            {
                PushButton { text = "OK" },                 
                PushButton { text = "Cancel" },
                PushButton { text = "OK" , 
                    style = {
                        {"Height",  40}
                    } 
                },
            },
            {
                PushButton { text = "OK" }, 
                PushButton { text = "OK" },
                PushButton { text = "Exit",
                             onClicked = function() app:close() end },
            }
        },
        --Space {}
    }
}

win:show()

app:runEventLoop()
