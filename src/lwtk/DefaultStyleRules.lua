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

        { "TextSize",                  12 },
        { "*Margin@Control",            5 },
        { "Height@PushButton",         20 },
        { "Width@PushButton",          80 },
        { "LeftPadding@PushButton",
          "RightPadding@PushButton",   10 },

        { "Color",                     params.color      or Color"f9f9fa" },
        { "TextColor",                 params.textColor  or Color"000000" },

        { "TextOffset",                 0            },
        { "TextOffset:pressed+hover",   0.3            },
        
        { "Color@PushButton",                 Color"e1e1e2" },
        { "Color@PushButton:hover",
          "Color@PushButton:pressed",         Color"c9c9ca" },
        { "Color@PushButton:pressed+hover",   Color"b1b1b2" },
    }
end

return DefaultStyleRules
