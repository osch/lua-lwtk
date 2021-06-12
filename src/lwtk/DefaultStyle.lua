local lwtk = require"lwtk"

local Color    = lwtk.Color
local get      = lwtk.StyleParamRef.get
local lighten  = lwtk.StyleParamRef.lighten
local saturate = lwtk.StyleParamRef.saturate

local Super        = lwtk.Style
local DefaultStyle = lwtk.newClass("lwtk.DefaultStyle", Super)

function DefaultStyle:new(initParams)
    
    local function par(name)
        local rslt = initParams and initParams[name]
        if rslt ~= nil then
            initParams[name] = nil
            return rslt
        end
    end
    
    local scaleFactor = par"scaleFactor" or 1
    local screenScale = par"screenScale" or 1
    local color       = par"color"       or Color"f9f9fa"
    local textColor   = par"textColor"   or Color"000000"
    
    local ruleList = {
        
        scaleFactor = scaleFactor * screenScale,
        
        { "*TransitionSeconds",                    0.05 },
        { "VisibilityTransitionSeconds",           0.05 },
        { "VisibilityTransitionSeconds:invisible", 0.40 },
        { "FrameTransitionSeconds",                0.10 },
        { "HoverTransitionSeconds",                0.20 },
        { "PressedTransitionSeconds",              0.05 },
        { "SimulateButtonClickSeconds",            0.10 },

        { "TextSize",                            12 },
        { "FontFamily",                "sans-serif" },

        { "BackgroundColor",           color       },
        { "TextColor",                 textColor   },

        { "TextOffset",                   0            },
        
        { "CursorColor",                      Color"00000000" }, -- Color"adadad" },
        { "CursorColor:focused",              Color"000000" },
        { "CursorWidth",                        2 },

        {         "*Margin@Control",       8 },
        {          "Height@Control",      24 },
        {   "BorderPadding@Control",       3 },
        { "TextFullVisible@Control",    true },
        
        { "BorderPadding@TextLabel",      0 },
        {    "BorderSize@TextLabel",      0 },
        {   "BorderColor@TextLabel",    nil },

        {        "Width@PushButton",                 80   },
        {   "BorderSize@PushButton",                  1   },
        {   "BorderSize@PushButton:focused",          2  },
        {   "BorderSize@PushButton:default",          1   },
        
        {  "LeftPadding@PushButton",
          "RightPadding@PushButton",                 10   },
        {   "TextOffset@PushButton:pressed+hover",    0.3 },

        { "BackgroundColor@PushButton",                 Color"e1e1e1" },
        { "BackgroundColor@PushButton:default",         Color"e5f1fb" },
        { "BackgroundColor@PushButton:hover",           Color"c9c9ca" },
        { "BackgroundColor@PushButton:pressed",         Color"c9c9ca" },
        { "BackgroundColor@PushButton:pressed+hover",   Color"b1b1b2" },
        { "BackgroundColor@PushButton:focused",         Color"e5f1fb" },
        { "BackgroundColor@PushButton:focused+hover",   Color"d5e1eb" },
        { "BackgroundColor@PushButton:focused+pressed", Color"c5d1db" },
        
        {     "BorderColor@PushButton",                 Color"adadad" },
        {     "BorderColor@PushButton:focused",         Color"0078d7" },
        {     "BorderColor@PushButton:default",         Color"0078d7" },
        
        {     "MinColumns@TextInput",                        10 },
        {        "Columns@TextInput",                        20 },
        {      "MaxColumns@TextInput",                       -1 },
        {     "BorderColor@TextInput",            Color"adadad" },
        {     "BorderColor@TextInput:focused",    Color"0078d7" },
        {      "BorderSize@TextInput",                        1 },
        {      "BorderSize@TextInput:focused",                2 },
        {      "FontFamily@TextInput",              "monospace" }, -- sans-serif
        { "TextFullVisible@TextInput",                    false },
    }
    
    Super.new(self, ruleList)
end

return DefaultStyle
