local tryrequire = require("lwtk.tryrequire")

local lpugl = tryrequire("lpugl")

--[[
    @function(...)
    
    Returns *true* if bitwise AND of its operands is different from zero.
]]
local btest = lpugl and lpugl.btest

if not btest then
    local bit = tryrequire("bit")
    if bit then
        btest = function(...)
            return bit.band(...) ~= 0
        end
    end
end

if not btest then
    if not lpugl then
        require("lpugl") -- let require produce error message
    end
    error("no bitoperations found")
end

return btest
