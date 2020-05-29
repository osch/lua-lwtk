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
                    TextInput  { text = "Enter Name iii12312312312312321321321321!" },
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


do
    local info = app:getFontInfo("sans-serif", "normal", "normal", 20)
    local text = "t€stü!"
    local w = 0
    for p, c in utf8.codes(text) do
        local next = utf8.offset(text, 2, p)
        local char = text:sub(p, next - 1)
        print(">", p, next - p, char, c, ">>", info:getStringWidth(char), info:getCharWidth(c))
        w = w + info:getCharWidth(c)
    end
    print("=============", info:getStringWidth(text, 2, 1))
    print(">>>>>>>>>>>>>", w, info:getStringWidth(text))
end


win:show()

app:runEventLoop()
