local lwtk = require"lwtk"

local Application = lwtk.Application
local Column      = lwtk.Column
local Row         = lwtk.Row
local Space       = lwtk.Space
local PushButton  = lwtk.PushButton
local TextInput   = lwtk.TextInput

local app = Application("test06.lua")

local function printClicked(self)
    print("clicked", self.text)
end

local win = app:newWindow {
    title = "test06",
    Row {
        Column {
            Row {
                Column {
                    PushButton { text = "&OK",     onClicked = printClicked },
                    TextInput  { id = "inp", text = "Enter Name iii12312312312312321321321321!" },
                },
                Column {
                    PushButton { text = "Click no&g and here!", onClicked = printClicked },
                    --Space {},
                }
            },
            PushButton { text = "Click &now and here!", onClicked = printClicked },
            PushButton { text = "&Exit",  onClicked = function() app:close() end },
            --Space {}
        },
        --Space {}
    }
}


win:show()

app:runEventLoop()
