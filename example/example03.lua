local lwtk = require"lwtk"

local Application    = lwtk.Application
local Column         = lwtk.Column
local Row            = lwtk.Row
local Space          = lwtk.Space
local PushButton     = lwtk.PushButton
local TextInput      = lwtk.TextInput
local TextLabel      = lwtk.TextLabel
local TitleText      = lwtk.TitleText
local FocusGroup     = lwtk.FocusGroup

local app = Application("example03.lua")

local confirmCloseWindows = lwtk.WeakKeysTable()

local function confirmClose(callback)
    return function(widget)
        local winToBeClosed = widget:getRoot()
        local confirmWin = confirmCloseWindows[winToBeClosed]
        if not callback then
            callback = function() winToBeClosed:close() end
        end
        if not confirmWin or confirmWin:isClosed() then
            confirmWin = app:newWindow {
                Column {
                    TextLabel { text = "Are you sure?" },
                    Row {
                        PushButton { text = "&Yes", onClicked = function() callback()
                                                                           confirmWin:close() end },
                        PushButton { text = "&No",  onClicked = function() confirmWin:close() end },
                    }
                }
            }
            confirmCloseWindows[winToBeClosed] = confirmWin
            confirmWin:show()
        else
            confirmWin:show()
            confirmWin:requestFocus()
        end
    end
end

local winCounter = 0

local function newWin(rows, columns)

    local column = lwtk.Column {}    
    
    for i = 1, rows  do
        local row = lwtk.Row {}
        column:addChild(row)
        for j = 1, columns do
            row:addChild(FocusGroup { id="focusGroup_"..i.."_"..j,
              Column {
                id = "form",
                onInputChanged = function(widget, input)
                    local fullInput = #widget:childById("inp1").text > 0
                                  and #widget:childById("inp2").text > 0
                                  and #widget:childById("inp3").text > 0
                                  and #widget:childById("inp4").text > 0
                                  and #widget:childById("inp5").text > 0
                    widget:childById("b1"):setDisabled(not fullInput)
                end,
                Row {
                    Column {
                        TitleText { id = "title", text = "Please enter data ("..i.."|"..j..")" },
                        Row {
                            Column {    
                                TextLabel   {   input = "form/inp1", text = "&First Name:" },
                                TextLabel   {   input = "form/inp2", text = "&Last Name:" },
                                TextLabel   {   input = "form/inp3", text = "S&treet:" },
                                TextLabel   {   input = "form/inp4", text = "Cit&y:" },
                                TextLabel   {   input = "form/inp5", text = "&Country:" },
                            },
                            Column {
                                style = {
                                    { "Columns@TextInput", 30 }
                                },
                                TextInput   {   id = "inp1" }, -- focus = true ,
                                TextInput   {   id = "inp2" },
                                TextInput   {   id = "inp3" },
                                TextInput   {   id = "inp4" },
                                TextInput   {   id = "inp5" }--, default = "b1"
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
                                    onClicked = function(widget) 
                                        widget:byId("form/title"):setText("Hello "..widget:byId("form/inp1").text) 
                                        widget:byId("form/title"):triggerLayout()
                                    end
                                },
                    PushButton { text = "&Quit",  onClicked = confirmClose() },
                    PushButton { text = "&Other",   },
                    Space {},
                }
              }
            })
        end
    end
    winCounter = winCounter + 1
    local win = app:newWindow {
        title = "example03 - "..winCounter,
        onClose = confirmClose(),
        column
    }
    local c = win:childById("focusGroup_1_2/inp1")
    if c then c:setFocus() end
    win:show()
end

local function filterNumeric(widget, input)
    if input:match("^%d+$") then 
        return input
    end
end

local mainWin = app:newWindow {
    title = "example03",
    onClose = confirmClose(),
    Column {
        TitleText { text = "Welcome to lwtk!" },
        onInputChanged = function(widget)
            widget:childById("newWindow"):setDisabled(  #widget:childById("columns").text == 0
                                                     or #widget:childById("rows").text == 0)
        end,
        Row {
            style = {
                { "MaxColumns@TextInput", 3 }
            },
            TextLabel { text = "Rows:" },
            TextInput { id = "rows",    text = "3", focus = true, filterInput = filterNumeric,
                                                                  initActions = {"CursorToEndOfLine"} },
            TextLabel { text = "Columns:" },
            TextInput { id = "columns", text = "4",               filterInput = filterNumeric,
                                                                  initActions = {"CursorToEndOfLine"} },
            Space {}
        },
        Row {
            PushButton { id = "newWindow",
                         text = "&New Window", default = true,  onClicked = function(widget)
                                                                    newWin(tonumber(widget:byId"rows".text), 
                                                                           tonumber(widget:byId"columns".text))
                                                                end },
            PushButton { text = "&Quit",    onClicked  = confirmClose(function() app:close() end) },
        }
    }
}
mainWin:show()

app:runEventLoop()
