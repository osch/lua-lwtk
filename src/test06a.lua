local lwtk = require"lwtk"

local Application = lwtk.Application
local Column      = lwtk.Column
local Row         = lwtk.Row
local Space       = lwtk.Space
local PushButton  = lwtk.PushButton
local TextInput   = lwtk.TextInput
local TextLabel   = lwtk.TextLabel
local scale       = lwtk.StyleParamRef.scale
local get         = lwtk.StyleParamRef.get

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
                    TextLabel { id = "title", text = "Please enter data", style = {{"TextSize", scale(4, get"TextSize")}} },
                    Row {
                        Column {    
                            TextLabel   {   input = "inp1", text = "&First Name:" },
                            TextLabel   {   input = "inp2", text = "&Second Name:" },
                            TextLabel   {   input = "inp3", text = "S&treet:" },
                            TextLabel   {   input = "inp4", text = "Cit&y:" },
                            TextLabel   {   input = "inp5", text = "&Country:" },
                        },
                        Column {
                            TextInput   {   id = "inp1", text = "", 
                                            focus = true, 
                                            style =  {{"Columns", 30}} },
                                                      
                            TextInput   {   id = "inp2", text = "" },
                            
                            TextInput   {   id = "inp3", text = "" },

                            TextInput   {   id = "inp4", text = "" },

                            TextInput   {   id = "inp5", text = "Country",
                                            default = "b1" },
                        },
                        
                    }
                },
                Column  {
                    PushButton  {   text = "Click no&g and here!", onClicked = printClicked },
                    --Space {},
                }
            },
            PushButton  {   id = "b1", text = "Click &now and here!", 
                            onClicked = function(self) 
                                self:getRoot().child.title:setText("Hello "..self:getRoot().child.inp1.text) 
                                self:getRoot().child.title:triggerLayout()
                            end
                        },
            PushButton { text = "&Exit",  onClicked = function() app:close() end },
            --Space {}
        },
        --Space {}
    }
}


win:show()

while app:hasWindows() do
    app:update()
end
