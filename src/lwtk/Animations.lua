local lwtk = require("lwtk")

local remove = table.remove

local UPDATE_INTERVAL = 0.015 -- seconds
local processAnimations

local Animations = lwtk.newClass("lwtk.Animations")


function Animations:new(app)
    self.app      = app
    self.setTimer = app.setTimer
    self.timer    = lwtk.Timer(processAnimations, self)
end

function Animations:add(animatable)
    self[#self + 1] = animatable
    local timer = self.timer
    if not timer.time then
        self:setTimer(UPDATE_INTERVAL, timer)
    end
end


function Animations:hasActive()
    return #self > 0
end

processAnimations = function(self)
    for i = #self, 1, -1 do
        local a = self[i]
        if a.animationActive then
            a.animationActive = false
            a:triggerRedraw()
        else
            remove(self, i)
            a.animationTriggered = false
        end
    end
    if #self > 0 then
        local timer = self.timer
        if not timer.time then
            self:setTimer(UPDATE_INTERVAL, timer)
        end
    end
end

return Animations

