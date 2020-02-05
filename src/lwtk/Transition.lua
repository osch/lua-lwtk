local lwtk = require"lwtk"

local Transition = lwtk.newClass("lwtk.Transition")

function Transition:new()
    self.duration = 0
    self.forward  = false
    self.startTime  = 0
    self.endTime    = 0
    self.state      = 0
end

function Transition:isActive()
    if self.forward then  return self.state < 1
                    else  return self.state > 0 end
end

function Transition:startForward(currentTime, duration)
    if not self:isActive() then
        self.duration = duration
    end
    self.startTime = currentTime - self.state * self.duration;
    self.endTime   = self.startTime + self.duration
    self.forward = true
end

function Transition:startBackward(currentTime, duration)
    if not self:isActive() then
        self.duration = duration
    end
    self.startTime = currentTime - (1 - self.state)  * self.duration;
    self.endTime   = self.startTime + self.duration;
    self.forward = false;
end

function Transition:update(currentTime)
    local t
    if self.endTime <= currentTime then 
        t = 1 
    elseif currentTime <= self.startTime then 
        t = 0 
    elseif self.startTime < self.endTime  then 
        t = (currentTime - self.startTime) / (self.endTime - self.startTime)
    else
        t = 1
    end
    local isActive
    if self.forward then          self.state = t; isActive = t < 1
                    else t = 1-t; self.state = t; isActive = t > 0 end
    return isActive
end

return Transition
