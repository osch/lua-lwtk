local lwtk = require"lwtk"

local Application = lwtk.Application
local Column      = lwtk.Column
local Row         = lwtk.Row
local Space       = lwtk.Space
local PushButton  = lwtk.PushButton

local app = Application("test04.lua")

local function printClicked(self)
    print("clicked", self.text)
end

local win = app:newWindow {
    title = "test04",
    Row { id = "g1",
        Column { id = "g2",
            Row { id = "g3",
                Column { id = "g4",
                    PushButton { text = "&OK",     onClicked = printClicked, id = "b1"},
                    PushButton { text = "C&ancel", id = "b2",
                                 onClicked = function(self)
                                    printClicked(self)
                                    local c = self:getRoot().child.b4
                                    c:setVisible(not c:isVisible())
                                 end },
                },
                Column {
                    PushButton { text = "Click no&g and here!", id = "b3",
                                 onClicked = function(self)
                                    printClicked(self)
                                    local c = self:getRoot().child.b2
                                    c:setVisible(not c:isVisible())
                                 end },
                    --Space {},
                }
            },
            PushButton { text = "Click &now and here!", id = "b4", 
                         onClicked = printClicked },
            
            PushButton { text = "&Exit",  id = "b5", 
                         onClicked = function() app:close() end },
            --Space {}
        },
        --Space {}
    }
}

win:show()

app:runEventLoop()
