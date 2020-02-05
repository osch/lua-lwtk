local lwtk = require"lwtk"

local Timer       = lwtk.Timer
local Transition  = lwtk.Transition
local Super       = lwtk.Styleable
local Animateable = lwtk.newClass("lwtk.Animateable", Super)

function Animateable:new()
    Super.new(self)
    self.animationTransitions = {}
    self.animationValues      = {}
    self.animationActive      = false
    self.animationTimer       = false
    self.isAnimateable        = {}
end

function Animateable:changeState(name, flag)
    flag = flag and true or false
    local oldFlag = self.state[name]
    if oldFlag ~= flag then
        self:setState(name, flag)
        local trans = self.animationTransitions[name]
        local duration = self:getStyleParam(name.."TransitionSeconds") or 0
        if duration > 0 then
            if not trans then
                trans = Transition()
                self.animationTransitions[name] = trans
            end
            if flag then
                trans:startForward(self:getCurrentTime(), duration)
            else
                trans:startBackward(self:getCurrentTime(), duration)
            end
            if not self.animationActive then
                self.animationActive = true
                local timer = self.animationTimer
                if not timer then
                    timer = Timer(self.triggerRedraw, self)
                    self.animationTimer = timer
                end
                self:setTimer(0.000, timer)
            end
        else
            if trans then
                self.animationTransitions[name] = false
            end
            self:triggerRedraw()
        end
    end
end

function Animateable:getStyleParam(paramName)
    local value = self.animationValues[paramName]
    if value == nil then
        value = Super.getStyleParam(self, paramName)
        if value ~= nil then
            local animateable = self.isAnimateable[paramName]
            if animateable == nil then
                local t = type(value)
                animateable =     t ~= "string"
                              and t ~= "boolean"
                              and not paramName:match("Seconds$")
                self.isAnimateable[paramName] = animateable
            end
            if animateable then
                self.animationValues[paramName] = value
            end
        end
    end
    return value
end

local isActive = Transition.isActive

function Animateable:updateAnimation()
    local now = self:getCurrentTime()
    local values = self.animationValues
    local transitions = self.animationTransitions
    local stateFlags = self.state
    local hasActive = false
    for _, trans in pairs(transitions) do
        if trans then
            trans.state0 = trans.state
            local isActive = trans:update(now)
            hasActive = hasActive or isActive
        end
    end
    self.isAnimationActive = hasActive
    for paramName, currentValue in pairs(values) do
        local targetValue = Super.getStyleParam(self, paramName)
        if targetValue ~= currentValue then
            local value
            local count = 0
            for stateName, stateFlag in pairs(stateFlags) do
                local trans = transitions[stateName]
                if trans and isActive(trans) then
                    local t0 = trans.state0
                    local t  = trans.state
                    if trans.forward then
                        if t0 < 1 then
                            local v = ((t-1)/(t0-1))*currentValue + ((t0-t)/(t0-1))*targetValue
                            if value then value = value + v
                                     else value = v end
                        else
                            if value then value = value + targetValue
                                     else value = targetValue end
                        end
                    else
                        if t0 > 0 then
                            local v = (t/t0)*currentValue + ((t0-t)/t0)*targetValue
                            if value then value = value + v
                                     else value = v end
                        else
                            if value then value = value + targetValue
                                     else value = targetValue end
                        end
                    end
                    count = count + 1
                end
            end
            if count > 0 then
                values[paramName] = (1/count) * value
            else
                values[paramName] = targetValue
            end
        end
    end
    if hasActive then
        self:setTimer(0.020, self.animationTimer)
    else
        self.animationActive = false
    end
end


return Animateable
