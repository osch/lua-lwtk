local lwtk = require"lwtk"

local Application = lwtk.Application
local Column      = lwtk.Column
local Row         = lwtk.Row
local Space       = lwtk.Space
local PushButton  = lwtk.PushButton
local TextLabel   = lwtk.TextLabel

local app = Application("test04.lua")

local function printClicked(self)
    print("clicked", self.text)
end

local win = app:newWindow {
    title = "test04",
    Row { id = "g1",
        Column { id = "g2",
            PushButton { id ="tb", text = "Top Button" },
            Row {
                PushButton  {   id="B1", text = "Button1" },
                TextLabel   {   id="L1", text = "Label1", visible = false },
                PushButton  {   text = "Button2",
                                onClicked = function(self)
                                    printClicked(self)
                                    local c = self:getRoot().child.tb
                                    c:setVisible(not c:isVisible())
                                end                                 
                            },
            },
            Row { id = "g3",
                Column { id = "g4",
                    PushButton  {   text = "&OK",
                                    id = "b1",
                                    onClicked = function(self)
                                        printClicked(self)
                                        local c = self:getRoot().child.B1
                                        c:setVisible(not c:isVisible())
                                        self:getRoot().child.L1:setVisible(not c:isVisible())
                                    end 
                                },
                    PushButton  {   text = "C&ancel", id = "b2",
                                    onClicked = function(self)
                                        printClicked(self)
                                        local c = self:getRoot().child.b4
                                        c:setVisible(not c:isVisible())
                                    end 
                                },
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
