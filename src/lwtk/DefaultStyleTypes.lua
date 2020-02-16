local lwtk = require"lwtk"

local TypeRule = lwtk.TypeRule

local SCALABLE   = TypeRule.SCALABLE
local ANIMATABLE = TypeRule.ANIMATABLE

local function DefaultStyleTypes()
    return {
        { "*Seconds", "number" },
        
        { "*Color",   "lwtk.Color", ANIMATABLE },
        
        { "*Margin",  "number",     SCALABLE },
        
        { "*Size",
          "*Offset",
          "*Width",
          "*Height",  "number",     SCALABLE, ANIMATABLE },
    }
end
return DefaultStyleTypes