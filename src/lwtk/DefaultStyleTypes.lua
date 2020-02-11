local lwtk = require"lwtk"

local TypeRule = lwtk.TypeRule

local SCALED   = TypeRule.SCALED
local ANIMATED = TypeRule.ANIMATED

local function DefaultStyleTypes()
    return {
        { "*Seconds", "number" },
        { "*Color",   "lwtk.Color", ANIMATED },
        { "*Size",
          "*Offset",  "number",     SCALED, ANIMATED },
    }
end
return DefaultStyleTypes