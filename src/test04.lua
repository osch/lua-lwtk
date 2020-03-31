local lwtk = require"lwtk"

local Application = lwtk.Application
local Column      = lwtk.Column
local Row         = lwtk.Row
local Space       = lwtk.Space
local PushButton  = lwtk.PushButton

local app = Application("test04.lua")

local win = app:newWindow {
    title = "test04",
    Row {
        Column {
            Row {
                Column {
                    PushButton { text = "&OK" },
                    PushButton { text = "C&ancel" },
                },
                Column {
                    PushButton { text = "Click n&og and here!" },
                    --Space {},
                }
            },
            PushButton { text = "Click &now and here!" },
            PushButton { text = "&Exit",
                         onClicked = function() app:close() end },
            --Space {}
        },
        --Space {}
    }
}

win:show()

app:runEventLoop()
