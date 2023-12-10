local lwtk = require"lwtk"

local Timer = lwtk.newClass("lwtk.Timer")

Timer:declare(
    "n",
    "func",
    "time"
)

function Timer:new(func, ...)
    local n = select("#", ...)
    for i = 1, n do
        rawset(self, i, select(i, ...))
    end
    self.n    = n
    self.func = func
    self.time = false
end

return Timer
