local tryrequire = require("lwtk.tryrequire")

local lpugl = tryrequire("lpugl")

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
    error("no bitoperations found")
end

return btest
