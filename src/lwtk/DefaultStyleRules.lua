local lwtk = require"lwtk"

local Color    = lwtk.Color
local get      = lwtk.StyleParamRef.get
local lighten  = lwtk.StyleParamRef.lighten
local saturate = lwtk.StyleParamRef.saturate

local function DefaultStyleRules(params)
    
    params = params or {}
    
    return {
        
        scaleFactor = params.scaleFactor or 1,
        
        { "*TransitionSeconds",               0.05 },
        { "FrameTransitionSeconds",           0.20 },
        { "HoverTransitionSeconds:",          0.20 },
        { "HoverTransitionSeconds:hover",     0.20 },
        { "PressedTransitionSeconds:pressed", 0.20 },
        { "SimulateButtonClickSeconds",       0.10 },

        { "TextSize",                  12 },
        { "*Margin@Control",            8 },
        { "Height@PushButton",         22 },
        { "Width@PushButton",          80 },
        { "BorderSize@PushButton",      1 },
        { "BorderSize@PushButton:focused+*",      2 },
        { "LeftPadding@PushButton",
          "RightPadding@PushButton",   10 },

        { "Color",                     params.color      or Color"f9f9fa" },
        { "TextColor",                 params.textColor  or Color"000000" },

        { "TextOffset",                   0            },
        { "TextOffset:pressed+hover+*",   0.3            },
        
        { "Color@PushButton:*",                 Color"e1e1e1" },
        { "Color@PushButton:hover+*",
          "Color@PushButton:pressed+*",         Color"c9c9ca" },
        { "Color@PushButton:pressed+hover+*",   Color"b1b1b2" },
        { "BorderColor@PushButton:*",           Color"adadad" },
        { "BorderColor@PushButton:focused+*",   Color"0078d7" },
    }
end

return DefaultStyleRules
