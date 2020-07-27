local lwtk = require"lwtk"

local Color    = lwtk.Color
local get      = lwtk.StyleParamRef.get
local lighten  = lwtk.StyleParamRef.lighten
local saturate = lwtk.StyleParamRef.saturate

local function DefaultStyleRules(params)
    
    params = params or {}
    
    return {
        
        scaleFactor = (params.scaleFactor or 1) * (params.screenScale or 1),
        
        { "*TransitionSeconds",               0.05 },
        { "FrameTransitionSeconds",           0.20 },
        { "HoverTransitionSeconds:",          0.20 },
        { "HoverTransitionSeconds:hover",     0.20 },
        { "PressedTransitionSeconds:pressed", 0.20 },
        { "SimulateButtonClickSeconds",       0.10 },

        { "TextSize",                  12 },
        { "*Margin@Control",            8 },
        { "Height@Control",            24 },
        { "Width@PushButton",          80 },
        { "BorderSize@PushButton",      1 },
        { "BorderSize@PushButton:focused+*",      2 },
        { "LeftPadding@PushButton",
          "RightPadding@PushButton",   10 },

        { "BackgroundColor",           params.color      or Color"f9f9fa" },
        { "TextColor",                 params.textColor  or Color"000000" },

        { "TextOffset",                   0            },
        { "TextOffset:pressed+hover+*",   0.3            },
        
        { "BackgroundColor@PushButton:*",                 Color"e1e1e1" },
        { "BackgroundColor@PushButton:hover+*",
          "BackgroundColor@PushButton:pressed+*",         Color"c9c9ca" },
        { "BackgroundColor@PushButton:pressed+hover+*",   Color"b1b1b2" },
        { "BorderColor@PushButton:*",                     Color"adadad" },
        { "BorderColor@PushButton:focused+*",             Color"0078d7" },
        
        { "MinColumns@TextInput",                4 },
        { "Columns@TextInput",                  20 },
        { "MaxColumns@TextInput",               -1 },
        { "BorderColor@TextInput:*",            Color"adadad" },
        { "BorderColor@TextInput:focused+*",    Color"0078d7" },
        { "BorderSize@TextInput",               1 },
        { "BorderSize@TextInput:focused+*",     2 },
        { "BorderPadding@TextInput",            3 },
        { "FontFamily@TextInput",               "monospace" }, -- sans-serif
        { "CursorColor:*",                      Color"adadad" },
        { "CursorColor:focused+*",              Color"000000" },
        { "CursorWidth",                        2 },
    }
end

return DefaultStyleRules
