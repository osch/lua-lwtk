local lwtk = require"lwtk"

local floor = math.floor

local CairoLayoutContext = lwtk.newClass("lwtk.lpugl.CairoLayoutContext")

CairoLayoutContext:declare(
    "ctx",
    "platform",
    "adjustFamilyName"
)

function CairoLayoutContext:new(cairoCtx, platform)
    self.ctx = assert(cairoCtx)
    self.platform = assert(platform)
    if platform == "WIN" then
        self.adjustFamilyName = function(family)
            if family == "monospace" then
                return "Courier New"
            else
                return family
            end
        end
    else
        self.adjustFamilyName = function(family)
            return family
        end
    end
end

function CairoLayoutContext:selectFont(family, slant, weight, size)
    self.ctx:select_font_face(self.adjustFamilyName(family), slant, weight)
    self.ctx:set_font_size(size)
end

function CairoLayoutContext:getFontHeightMeasures()
    local ext = self.ctx:font_extents()
    return ext.height, ext.ascent
end

function CairoLayoutContext:getTextWidth(text)
    return floor(self.ctx:text_extents(text).x_advance + 0.5)
end

function CairoLayoutContext:getTextMeasures(text)
    local ext = self.ctx:text_extents(text)
    return ext.width, ext.height
end

return CairoLayoutContext
