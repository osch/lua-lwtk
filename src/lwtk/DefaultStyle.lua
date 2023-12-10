local lwtk = require"lwtk"

local Color    = lwtk.Color
local get      = lwtk.StyleRef.get
local scale    = lwtk.StyleRef.scale

local Super        = lwtk.Style
local DefaultStyle = lwtk.newClass("lwtk.DefaultStyle", Super)

function DefaultStyle.override:new(initParams)
    
    local function par(name)
        local rslt = initParams and initParams[name]
        if rslt ~= nil then
            initParams[name] = nil
            return rslt
        end
    end
    
    local scaleFactor     = par"scaleFactor"       or 1
    local screenScale     = par"screenScale"       or 1
    local backgroundColor = par"backgroundColor"   or Color"f9f9fa"
    local textColor       = par"textColor"         or Color"000000"
    local accentColor     = par"accentColor"       or Color"006fc7" --"0078d7"

    local ruleList = {
        
        scaleFactor = scaleFactor * screenScale,
        
        { "*TransitionSeconds",                    0.05 },
        { "VisibilityTransitionSeconds",           0.05 },
        { "VisibilityTransitionSeconds:invisible", 0.10 },
        { "FrameTransitionSeconds",                0.05 },
        { "HoverTransitionSeconds",                0.20 },
        { "PressedTransitionSeconds",              0.05 },
        { "SimulateButtonClickSeconds",            0.10 },

        { "TextSize",                            12 },
        { "FontFamily",                "sans-serif" },
        { "ScrollBarSize",                       12 },

        { "BackgroundColor",           backgroundColor },
        { "TextColor",                 textColor   },
        { "AccentColor",               accentColor },

        { "TextOffset",                   0            },
        
        { "CursorColor",                      Color"00000000" }, -- Color"adadad" },
        { "CursorColor:focused",              Color"000000" },
        { "CursorWidth",                        2 },

        {          "Margin@Control",           8 },
        {         "*Margin@Control", get"Margin" },
        {          "Height@Control",          24 },
        {   "BorderPadding@Control",           3 },
        { "TextFullVisible@Control",        true },
        
        {    "BorderSize@Box",            1 },
        { "BorderPadding@Box",            3 },
        {   "BorderColor@Box",            Color"adadad" },

        { "BorderPadding@TextLabel",      0 },
        {    "BorderSize@TextLabel",      0 },
        {   "BorderColor@TextLabel",    nil },
        
        {        "Width@PushButton",                 80   },
        {   "BorderSize@PushButton",                  1   },
        {   "BorderSize@PushButton:focused",          2  },
        
        {  "LeftPadding@PushButton",
          "RightPadding@PushButton",                 10   },
        {   "TextOffset@PushButton:pressed+hover",    0.3 },

        { "BackgroundColor@PushButton",                 Color"e1e1e1" },
        { "BackgroundColor@PushButton:hover",           Color"c9c9ca" },
        { "BackgroundColor@PushButton:pressed",         Color"c9c9ca" },
        { "BackgroundColor@PushButton:pressed+hover",   Color"b1b1b2" },
        { "BackgroundColor@PushButton:default",         Color"e5f1fb" },
        { "BackgroundColor@PushButton:default+hover",   Color"d5e1eb" },
        { "BackgroundColor@PushButton:default+pressed", Color"c5d1db" },
        { "BackgroundColor@PushButton:focused",         Color"e5f1fb" },
        { "BackgroundColor@PushButton:focused+hover",   Color"d5e1eb" },
        { "BackgroundColor@PushButton:focused+pressed", Color"c5d1db" },

        {       "TextColor@PushButton:disabled",        Color"adadad" },
        
        {     "BorderColor@PushButton",                 Color"adadad" },
        {     "BorderColor@PushButton:focused",      get"AccentColor" },
        {     "BorderColor@PushButton:default",      get"AccentColor" },
        
        {     "MinColumns@TextInput",                        10 },
        {        "Columns@TextInput",                        20 },
        {      "MaxColumns@TextInput",                       -1 },
        {     "BorderColor@TextInput",            Color"adadad" },
        {     "BorderColor@TextInput:focused", get"AccentColor" },
        {      "BorderSize@TextInput",                        1 },
        {      "BorderSize@TextInput:focused",                2 },
        {      "FontFamily@TextInput",              "monospace" },
        { "TextFullVisible@TextInput",                    false },

        { "TextSize@TitleText",         scale(2, get"TextSize")},

        {     "BorderColor@FocusGroup",            Color"adadad" },
        {     "BorderColor@FocusGroup:focused", get"AccentColor" },
        {      "BorderSize@FocusGroup",                        1 },
        {      "BorderSize@FocusGroup:focused",                2 },
        {      "BorderSize@FocusGroup:focused+entered",        1 },
    }
    
    Super.new(self, ruleList)
end

return DefaultStyle
