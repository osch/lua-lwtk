local lwtk = require"lwtk"

local lower    = string.lower
local upper    = string.upper
local Color    = lwtk.Color
local get      = lwtk.StyleRef.get
local scale    = lwtk.StyleRef.scale

local Super        = lwtk.Style
local DefaultStyle = lwtk.newClass("lwtk.DefaultStyle", Super)

function DefaultStyle.override:new(initParams)
    
    local function par(name, defaultValue)
        if initParams then
            local rslt = initParams[name]
            if rslt ~= nil then
                initParams[name] = nil
                return rslt
            end
            local name2 = lower(name:sub(1,1))..name:sub(2)
            rslt = initParams[name2]
            if rslt ~= nil then
                initParams[name2] = nil
                return rslt
            end
            name2 = upper(name:sub(1,1))..name:sub(2)
            rslt = initParams[name2]
            if rslt ~= nil then
                initParams[name2] = nil
                return rslt
            end
        end
        return defaultValue
    end
    
    local function parRule(name, defaultValue)
        return { name, par(name, defaultValue) }
    end
        
    local ruleList = {
        
        scaleFactor = par("ScaleFactor", 1) * par("ScreenScale", 1),
        
        parRule( "*TransitionSeconds",                    0.05 ),
        parRule( "VisibilityTransitionSeconds",           0.05 ),
        parRule( "VisibilityTransitionSeconds:invisible", 0.10 ),
        parRule( "FrameTransitionSeconds",                0.05 ),
        parRule( "HoverTransitionSeconds",                0.20 ),
        parRule( "PressedTransitionSeconds",              0.05 ),
        parRule( "SimulateButtonClickSeconds",            0.10 ),

        parRule( "TextSize",                            12 ),
        parRule( "FontFamily",                "sans-serif" ),
        parRule( "ScrollBarSize",                       12 ),

        parRule( "BackgroundColor",           Color"f9f9fa" ),
        parRule( "TextColor",                 Color"000000"   ),
        parRule( "AccentColor",               Color"006fc7" ), --"0078d7"

        parRule( "TextOffset",                   0            ),
        
        parRule( "CursorColor",                      Color"00000000" ), -- Color"adadad" ),
        parRule( "CursorColor:focused",              Color"000000" ),
        parRule( "CursorWidth",                        2 ),

        parRule(          "Margin@Control",           8 ),
        parRule(         "*Margin@Control", get"Margin" ),
        parRule(          "Height@Control",          24 ),
        parRule(   "BorderPadding@Control",           3 ),
        parRule( "TextFullVisible@Control",        true ),
        
        parRule(    "BorderSize@Box",            1 ),
        parRule( "BorderPadding@Box",            3 ),
        parRule(   "BorderColor@Box",            Color"adadad" ),

        parRule( "BorderPadding@TextLabel",      0 ),
        parRule(    "BorderSize@TextLabel",      0 ),
        parRule(   "BorderColor@TextLabel",    nil ),
        
        parRule(        "Width@PushButton",                 80   ),
        parRule(   "BorderSize@PushButton",                  1   ),
        parRule(   "BorderSize@PushButton:focused",          2  ),
        
        parRule(   "LeftPadding@PushButton",                 10),
        parRule(   "RightPadding@PushButton",                10),
        parRule(   "TextOffset@PushButton:pressed+hover",    0.3 ),

        parRule( "BackgroundColor@PushButton",                 Color"e1e1e1" ),
        parRule( "BackgroundColor@PushButton:hover",           Color"c9c9ca" ),
        parRule( "BackgroundColor@PushButton:pressed",         Color"c9c9ca" ),
        parRule( "BackgroundColor@PushButton:pressed+hover",   Color"b1b1b2" ),
        parRule( "BackgroundColor@PushButton:default",         Color"e5f1fb" ),
        parRule( "BackgroundColor@PushButton:default+hover",   Color"d5e1eb" ),
        parRule( "BackgroundColor@PushButton:default+pressed", Color"c5d1db" ),
        parRule( "BackgroundColor@PushButton:focused",         Color"e5f1fb" ),
        parRule( "BackgroundColor@PushButton:focused+hover",   Color"d5e1eb" ),
        parRule( "BackgroundColor@PushButton:focused+pressed", Color"c5d1db" ),

        parRule(       "TextColor@PushButton:disabled",        Color"adadad" ),
        
        parRule(     "BorderColor@PushButton",                 Color"adadad" ),
        parRule(     "BorderColor@PushButton:focused",      get"AccentColor" ),
        parRule(     "BorderColor@PushButton:default",      get"AccentColor" ),
        
        parRule(     "MinColumns@TextInput",                        10 ),
        parRule(        "Columns@TextInput",                        20 ),
        parRule(      "MaxColumns@TextInput",                       -1 ),
        parRule(     "BorderColor@TextInput",            Color"adadad" ),
        parRule(     "BorderColor@TextInput:focused", get"AccentColor" ),
        parRule(      "BorderSize@TextInput",                        1 ),
        parRule(      "BorderSize@TextInput:focused",                2 ),
        parRule(      "FontFamily@TextInput",              "monospace" ),
        parRule( "TextFullVisible@TextInput",                    false ),

        parRule( "TextSize@TitleText",         scale(2, get"TextSize")),

        parRule(     "BorderColor@FocusGroup",            Color"adadad" ),
        parRule(     "BorderColor@FocusGroup:focused", get"AccentColor" ),
        parRule(      "BorderSize@FocusGroup",                        1 ),
        parRule(      "BorderSize@FocusGroup:focused",                2 ),
        parRule(      "BorderSize@FocusGroup:focused+entered",        1 ),
    }
    
    Super.new(self, ruleList)
end

return DefaultStyle
