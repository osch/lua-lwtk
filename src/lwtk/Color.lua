local format = string.format
local floor  = math.floor

local lwtk   = require"lwtk"

local vivid    = lwtk.vivid
local RGBtoHSL = vivid.RGBtoHSL
local HSLtoRGB = vivid.HSLtoRGB

local Object = lwtk.Object
local Color  = lwtk.newClass("lwtk.Color")

local hexCharPat = "[0-9A-Fa-f]"
local hexBytePat = "("..hexCharPat..hexCharPat..")"
local rgbPat     = "^"..hexBytePat..hexBytePat..hexBytePat.."$"
local rgbaPat    = "^"..hexBytePat..hexBytePat..hexBytePat..hexBytePat.."$"

function Color:new(...)
    local nargs = select("#", ...)
    if nargs == 0 then
        self.r = 0
        self.g = 0
        self.b = 0
    else
        local r, g, b, a
        if nargs > 1 then
            r, g, b, a = ...
        else
            local arg = ...
            if type(arg) == "string" then
                r, g, b = arg:match(rgbPat)
                if not r then
                    r, g, b, a = arg:match(rgbaPat)
                end
                assert(r)
                r = tonumber(r, 16) / 0xff
                g = tonumber(g, 16) / 0xff
                b = tonumber(b, 16) / 0xff
                if a then
                    b = tonumber(a, 16) / 0xff
                end
            elseif type(arg) == "table" then
                r = arg.r or 0
                g = arg.g or 0
                b = arg.b or 0
                a = arg.a
            else
                error("invalid arg")
            end
        end
        self.r = r or 0
        self.g = g or 0
        self.b = b or 0
        if a then
            self.a = a
        end
    end
end

local function assureRange(value)
    if value < 0 then
        return 0
    elseif value > 1 then
        return 1
    else
        return value
    end
end

local function assureRanges(r,g,b,a)
    return assureRange(r),
           assureRange(g),
           assureRange(b),
           assureRange(a)
end

function Color:lighten(amount)
    return Color(assureRanges(vivid.lighten(amount, self.r, self.g, self.b, 1.0)))
end

function Color:saturate(amount)
    return Color(assureRanges(vivid.saturate(amount, self:toRGBA())))
end

function Color:toRGB()
    return self.r, self.g, self.b
end

function Color:toRGBA(a)
    return self.r, self.g, self.b, a or self.a or 1.0
end

function Color:toHex()
    return format("%02x", floor(self.r * 0xff))
         ..format("%02x", floor(self.g * 0xff))
         ..format("%02x", floor(self.b * 0xff))
         ..(self.a and format("$02x", floor(self.a * 0xff)) or "")
end

function Color:__tostring()
    return format("lwtk.Color('%s')", self:toHex())
end

function Color.__mul(factor, color) 
    assert(Object.is(color, Color))
    assert(type(factor) == "number" and 0 <= factor and factor <= 1)
    return Color(factor * color.r,
                 factor * color.g,
                 factor * color.b)
end

function Color.__add(color1, color2) 
    assert(Object.is(color1, Color))
    assert(Object.is(color2, Color))
    return Color(color1.r + color2.r,
                 color1.g + color2.g,
                 color1.b + color2.b)
end

return Color

