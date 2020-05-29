local lwtk = require"lwtk"

local TypeRule = lwtk.TypeRule

local SCALABLE   = TypeRule.SCALABLE
local ANIMATABLE = TypeRule.ANIMATABLE

local function DefaultStyleTypes()
    return {
        { "*Family",  "string" },
        
        { "*Seconds", 
          "*Columns", "number" },
        
        { "*Color",   "lwtk.Color", ANIMATABLE },
        
        { "*Margin",  "number",     SCALABLE },
        
        { "*Size",
          "*Offset",
          "*Padding",
          "*Width",
          "*Height",  "number",     SCALABLE, ANIMATABLE },
    }
end
return DefaultStyleTypes