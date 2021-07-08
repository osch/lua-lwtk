local lwtk = require"lwtk"

local Application    = lwtk.Application
local ViewSwitcher   = lwtk.ViewSwitcher
local Column         = lwtk.Column
local Row            = lwtk.Row
local Box            = lwtk.Box
local PushButton     = lwtk.PushButton
local TextInput      = lwtk.TextInput
local TextLabel      = lwtk.TextLabel
local TitleText      = lwtk.TitleText
local Space          = lwtk.Space

local app = Application("example02.lua")

local win = app:newWindow {
    title = "example02",
    Column {
        Box {
            TextLabel { text = "This examples demonstrates a form with two input fields." },
        },
        Box {
            ViewSwitcher {
                id = "switcher",
                Column {
                    id = "c1",
                    onInputChanged = function(widget)
                        widget:childById("b1"):setDisabled(  #widget:childById("i1").text == 0
                                                          or #widget:childById("i2").text == 0)
                    end,
                    Row {
                        Column {
                            TitleText { id = "t1", text = "What's your name?" },
                            Row {
                                Column {    
                                    TextLabel   {   input = "i1", text = "&First Name:" },
                                    TextLabel   {   input = "i2", text = "&Last Name:" },
                                },
                                Column {
                                    style = {
                                        { "Columns@TextInput", 40 }
                                    },
                                    TextInput   {   id = "i1", focus = true },
                                    TextInput   {   id = "i2"  },
                                },
                                
                            }
                        }
                    },
                    Row {
                        Space {},
                        PushButton  {   id = "b1", text = "&OK", disabled = true, default = true,
                                        onClicked = function(widget) 
                                            widget:byId("c2/t1"):setText("Hello "..widget:byId("c1/i1").text.." "..widget:byId("c1/i2").text.."!") 
                                            widget:byId("switcher"):showChild("c2")
                                        end
                                    },
                        PushButton  { text = "&Quit",  onClicked = function() app:close() end },
                        Space {}
                    }
                },
                Column {
                    id = "c2",
                    visible = false,
                    Column {
                        Space {},
                        Row {
                            Space {},
                            TitleText { id = "t1" },
                            Space {},
                        },
                        Space {}
                    },
                    Row {
                        Space {},
                        PushButton  {   text = "&Again", 
                                        onClicked = function(widget) 
                                            widget:byId("c1/i1"):setText("") 
                                            widget:byId("c1/i1"):setFocus()
                                            widget:byId("c1/i2"):setText("")
                                            widget:byId("switcher"):showChild("c1")
                                        end
                                    },
                        PushButton  { text = "&Quit",  default = true, onClicked = function() app:close() end },
                        Space {}
                    }
                }
            }
        }
    }
}

win:show()

app:runEventLoop()

