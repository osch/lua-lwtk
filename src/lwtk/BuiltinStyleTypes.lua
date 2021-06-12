local lwtk = require"lwtk"

local SCALABLE   = lwtk.StyleTypeAttributes.SCALABLE
local ANIMATABLE = lwtk.StyleTypeAttributes.ANIMATABLE

local function BuiltinStyleTypes()
    return {
        { "*Family",  "string" },
        
        { "*Seconds", 
          "*Columns", "number"  },
          
        { "*Visible", "boolean" },
        
        { "*Opacity",               ANIMATABLE },
        
        { "*Color",   "lwtk.Color", ANIMATABLE },
        
        { "*Margin",  "number",     SCALABLE },
        
        { "*Size",
          "*Offset",
          "*Padding",
          "*Width",
          "*Height",  "number",     SCALABLE, ANIMATABLE },
    }
end
return BuiltinStyleTypes