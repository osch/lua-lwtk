local format = string.format
local floor  = math.floor

local lwtk   = require"lwtk"
local vivid  = lwtk.internal.vivid

--[[
    RGBA Color value.
    
    Contains the float values *r (red)*, *g (green)*, *b (blue)* and optional
    *a (alpha value)* in the range >= 0 and <= 1.
]]   
local Color  = lwtk.newClass("lwtk.Color")

local isInstanceOf = lwtk.isInstanceOf

local hexCharPat = "[0-9A-Fa-f]"
local hexBytePat = "("..hexCharPat..hexCharPat..")"
local rgbPat     = "^"..hexBytePat..hexBytePat..hexBytePat.."$"
local rgbaPat    = "^"..hexBytePat..hexBytePat..hexBytePat..hexBytePat.."$"

Color:declare(
    "r",  -- red color float value (0 <= r <= 1)
    "g",  -- green color float value (0 <= g <= 1)
    "b",  -- blue color float value (0 <= b <= 1)
    "a"   -- alpha float value (0 <= a <= 1) or nil
)

--[[
    Creates a new RGBA color value.
    
    Possible invocations:
    
    * **`Color()`**
    
      If called without arguments, the color black is created, i.e. 
      *r = g = b = 0*.
    
    * **`Color(r,g,b,a)`**
    
      If more than one arg is given, arguments are the float color
      values *r*, *g*, *b*, *a* with the alpha value *a* being optional.
      
    * **`Color(table)`**
    
      * *table* - a table with the entries for the keys *r*, *g*, *b*
                  with optional alpha value *a*.
                  Missing entries for *r*, *g*, *b* are treated as 0.

    * **`Color(string)`**
    
      * *string* - a string in hex encoding with length 6 or 8
                   (format *"rrggbb"* or *"rrggbbaa"*). Each color value
                   consists of two hexadecimal digits and is in the range 
                   *00 <= value <= ff*, alpha value is optional.
]]
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
                    a = tonumber(a, 16) / 0xff
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
    if value then
        if value < 0 then
            return 0
        elseif value > 1 then
            return 1
        else
            return value
        end
    end
end

local function assureRanges(r,g,b,a)
    return assureRange(r),
           assureRange(g),
           assureRange(b),
           assureRange(a)
end

function Color:lighten(amount)
    return Color(assureRanges(vivid.lighten(amount, self.r, self.g, self.b, self.a)))
end

function Color:saturate(amount)
    return Color(assureRanges(vivid.saturate(amount, self.r, self.g, self.b, self.a)))
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
         ..(self.a and format("%02x", floor(self.a * 0xff)) or "")
end

function Color:__tostring()
    return format("lwtk.Color('%s')", self:toHex())
end

function Color.__mul(factor, color) 
    assert(isInstanceOf(color, Color))
    assert(type(factor) == "number" and 0 <= factor and factor <= 1)
    local a = color.a or 1
    return Color(factor * color.r,
                 factor * color.g,
                 factor * color.b,
                 factor * a)
end

function Color.__add(color1, color2) 
    assert(isInstanceOf(color1, Color))
    assert(isInstanceOf(color2, Color))
    local a1, a2 = color1.a or 1, color2.a or 1
    return Color(color1.r + color2.r,
                 color1.g + color2.g,
                 color1.b + color2.b,
                 a1 + a2)
end

function Color.__eq(color1, color2) 
    return color1.r and color2.r
       and color1.g and color2.g
       and color1.b and color2.b
       and floor(color1.r * 0xff) == floor(color2.r * 0xff)
       and floor(color1.g * 0xff) == floor(color2.g * 0xff)
       and floor(color1.b * 0xff) == floor(color2.b * 0xff)
       and (   (not color1.a and not color2.a)
            or (color1.a and color2.a
                and floor(color1.a * 0xff) == floor(color2.a * 0xff)))
end

return Color

