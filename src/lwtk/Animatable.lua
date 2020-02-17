local lwtk = require"lwtk"

local Timer       = lwtk.Timer
local Transition  = lwtk.Transition
local Super       = lwtk.Styleable
local Animatable  = lwtk.newClass("lwtk.Animatable", Super)

local getStyleParams = lwtk.get.styleParams

local UPDATE_INTERVAL = 0.020 -- seconds

function Animatable:new()
    Super.new(self)
    self.animationTransitions = {}
    self.animationValues      = {}
    self.animationActive      = false
    self.animationTimer       = false
end

local getStyleParam = Super.getStyleParam
local isActive      = Transition.isActive

local function updateFrameTransition(self)
    local trans = self.frameTransition
    if trans then
        trans:update(self:getCurrentTime())
        local t = trans.state
        local x = (1-t) * trans.oldX + t * trans.newX
        local y = (1-t) * trans.oldY + t * trans.newY
        local w = (1-t) * trans.oldW + t * trans.newW
        local h = (1-t) * trans.oldH + t * trans.newH
        self:_setFrame(x, y, w, h)
        if isActive(trans) then
            self:setTimer(UPDATE_INTERVAL, trans.timer)
        end
    end
end

function Animatable:changeFrame(newX, newY, newW, newH)
    local duration = getStyleParam(self, "FrameTransitionSeconds") or 0
    if duration > 0 then
        local trans = self.frameTransition
        if not trans then
            trans = Transition()
            self.frameTransition = trans
            trans.timer =  Timer(updateFrameTransition, self)
        end
        trans.oldX = self.x
        trans.oldY = self.y
        trans.oldW = self.w
        trans.oldH = self.h
        trans.newX = newX
        trans.newY = newY
        trans.newW = newW
        trans.newH = newH
        trans:reset()
        trans:startForward(self:getCurrentTime(), duration)
        self:setTimer(UPDATE_INTERVAL, trans.timer)
    else
        self:_setFrame(newX, newY, newW, newH)
    end
end

local function updateVisibilityTransition(self)
    local trans = self.visibilityTransition
    if trans then
        trans:update(self:getCurrentTime())
        self.opacity = trans.state
        self:triggerRedraw()
        if isActive(trans) then
            self:setTimer(UPDATE_INTERVAL, trans.timer)
        else
            self.visible = trans.newVisibility
        end
    end
end
function Animatable:changeVisibility(newFlag)
    local trans = self.visibilityTransition
    if newFlag ~= self.visible or trans and newFlag ~= trans.newVisibility then
        local duration = getStyleParam(self, "VisibilityTransitionSeconds") or 0
        if duration > 0 then
            if not trans then
                trans = Transition()
                self.visibilityTransition = trans
                trans.timer =  Timer(updateVisibilityTransition, self)
                if not newFlag then trans:resetBackward() end
            end
            trans.newVisibility = newFlag
            self.visible = true
            if newFlag then
                trans:startForward(self:getCurrentTime(), duration)
            else
                trans:startBackward(self:getCurrentTime(), duration)
            end
            self:setTimer(UPDATE_INTERVAL, trans.timer)
        else
            self:setVisibility(newFlag)
        end
    end
end

function Animatable:changeState(name, flag)
    flag = flag and true or false
    local oldFlag = self.state[name]
    if oldFlag ~= flag then
        local duration = getStyleParam(self, name.."TransitionSeconds") or 0
        self:setState(name, flag)
        local trans = self.animationTransitions[name]
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
                self:setTimer(UPDATE_INTERVAL, timer)
            end
        else
            if trans then
                self.animationTransitions[name] = false
            end
            self:triggerRedraw()
        end
    end
end

function Animatable:getStyleParam(paramName)
    local value = self.animationValues[paramName]
    if value == nil then
        value = getStyleParam(self, paramName)
        if value ~= nil then
            local animatable = getStyleParams[self].animatable[paramName]
            if animatable then
                self.animationValues[paramName] = value
            end
        end
    end
    return value
end


function Animatable:updateAnimation()
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
        local targetValue = getStyleParam(self, paramName)
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
        self:setTimer(UPDATE_INTERVAL, self.animationTimer)
    else
        self.animationActive = false
    end
end


return Animatable
