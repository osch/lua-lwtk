local lwtk = require"lwtk"

local Application    = lwtk.Application
local Column         = lwtk.Column
local Row            = lwtk.Row
local Space          = lwtk.Space
local PushButton     = lwtk.PushButton
local TextInput      = lwtk.TextInput
local TextLabel      = lwtk.TextLabel
local TitleText      = lwtk.TitleText
local scale          = lwtk.StyleRef.scale
local get            = lwtk.StyleRef.get

local app = Application("test06.lua")

local function printClicked(self)
    print("clicked", self.text)
end

local win = app:newWindow {
    title = "test06",
    Column {
        onInputChanged = function(self, widget)
            local fullInput = #self:childById("inp1").text > 0
                          and #self:childById("inp2").text > 0
                          and #self:childById("inp3").text > 0
                          and #self:childById("inp4").text > 0
                          and #self:childById("inp5").text > 0
            self:childById("b1"):setDisabled(not fullInput)
        end,
        Row {
            Column {
                TitleText { id = "title", text = "Please enter data" },
                Row {
                    Column {    
                        TextLabel   {   input = "inp1", text = "&First Name:" },
                        TextLabel   {   input = "inp2", text = "&Second Name:" },
                        TextLabel   {   input = "inp3", text = "S&treet:" },
                        TextLabel   {   input = "inp4", text = "Cit&y:" },
                        TextLabel   {   input = "inp5", text = "&Country:" },
                    },
                    Column {
                        style = {
                            { "Columns@TextInput", 30 }
                        },
                        TextInput   {   id = "inp1", focus = true },
                        TextInput   {   id = "inp2" },
                        TextInput   {   id = "inp3" },
                        TextInput   {   id = "inp4" },
                        TextInput   {   id = "inp5" }--, default = "b1" },
                    },
                    
                }
            },
        },
        Space {},
        Row {
            Space {},
            PushButton  {   id = "b1", text = "&OK", 
                            disabled = true,
                            default = true,
                            onClicked = function(self) 
                                self:byId("title"):setText("Hello "..self:byId("inp1").text) 
                                self:byId("title"):triggerLayout()
                            end
                        },
            PushButton { text = "&Quit",  onClicked = function() app:close() end },
            PushButton { text = "&Other",   },
            Space {},
        }
    }
}

win:show()

while app:hasWindows() do
    app:update()
end
