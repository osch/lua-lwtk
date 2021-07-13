local lwtk = require"lwtk"

local SCALABLE   = lwtk.StyleTypeAttributes.SCALABLE
local ANIMATABLE = lwtk.StyleTypeAttributes.ANIMATABLE

local function BuiltinStyleTypes()
    return {
        { "*Family",
          "*Align",   "string" },
        
        { "*Seconds", 
          "*Columns", "number"  },
          
        { "*Visible",
          "*Fixed",   "boolean" },
        
        { "*Opacity", "number",     ANIMATABLE },
        
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