local lwtk = require"lwtk"

local Color    = lwtk.Color
local get      = lwtk.StyleParamRef.get
local lighten  = lwtk.StyleParamRef.lighten
local saturate = lwtk.StyleParamRef.saturate

local function DefaultStyleRules(params)
    
    params = params or {}
    
    return {
        { "TextSize:*",                  params.textSize        or 13            },
        { "BackgroundColor:*",           params.backgroundColor or Color"ffffff" },
        { "TextColor:*",                 params.textColor       or Color"000000" },
        { "BorderColor:*",               params.borderColor     or Color"000000" },
        { "*TransitionSeconds:*",        0.5 },
        
        { "TextColor@Button:*",          Color"0000f1" },
        { "TextColor@PushButton:*",      Color"a08080" },
        { "TextColor@PushButton:hover+selected+*", Color"a0a0a0" },
    
        { "BorderColor:*",                             get"TextColor" },
        { "BorderColor@PushButton:*",                  Color"808081" },
        { "BorderColor@PushButton:active+*",           get"TextColor" },
        { "BorderColor@PushButton:hover+*",            lighten(0.2, get"TextColor") },
        { "BorderColor@PushButton:hover2+*",           saturate(0.5, get"TextColor") },
        { "Color:*",                                   Color"808080" },
        { "Color@MyBox:*",                             Color"aa0000" },
        { "Color@MyBox:hover+*",                       lighten(0.1, get"Color") }
    }
end

return DefaultStyleRules
