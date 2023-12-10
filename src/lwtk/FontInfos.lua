local lwtk = require"lwtk"

local FontInfo  = lwtk.FontInfo

local FontInfos = lwtk.newClass("lwtk.FontInfos")

FontInfos:declare(
    "layoutContext",
    "cache"
)

function FontInfos:new(layoutContext)
    self.layoutContext = layoutContext
    self.cache = {}
end

function FontInfos:getFontInfo(family, slant, weight, size)
    local c1 = self.cache[family]
    if not c1 then 
        c1 = {}
        self.cache[family] = c1
    end
    local c2 = c1[slant]
    if not c2 then
        c2 = {}
        c1[slant] = c2
    end
    local c3 = c2[weight]
    if not c3 then 
        c3 = setmetatable({}, { __mode = "v" })
        c2[weight] = c3
    end
    local fontInfo = c3[size]
    if not fontInfo then
        fontInfo = FontInfo(self.layoutContext, family, slant, weight, size)
        c3[size] = fontInfo
    end
    return fontInfo
end

return FontInfos
