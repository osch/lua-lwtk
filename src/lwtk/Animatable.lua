local lwtk = require"lwtk"

local Timer       = lwtk.Timer
local Transition  = lwtk.Transition
local Super       = lwtk.Styleable
local Animatable  = lwtk.newClass("lwtk.Animatable", Super)

local getApp         = lwtk.get.app
local getStyleParams = lwtk.get.styleParams
local ignored        = lwtk.get.ignored
local animations     = lwtk.get.animations

local UPDATE_INTERVAL = 0.010 -- seconds

function Animatable:new()
    Super.new(self)
    self.paramTransitions     = {}
    self.stateTransitions     = {}
    self.currentValues        = {}
    self.animationActive      = false
    self.animationTriggered   = false
    self.animationUpdated     = false
end

local getStyleParam = Super.getStyleParam
local isActive      = Transition.isActive

local function getAnimations(self)
    local a = animations[self]
    if not a then
        local app = getApp[self]
        assert(app, "widget not connected to application")
        a = animations[app]
        animations[self] = a
    end
    return a
end

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

local function assureActiveAnimation(self)
    if not self.animationTriggered then
        self.animationTriggered = true
        self.animationUpdated   = false
        getAnimations(self):add(self)
    end
end

local function _setState(self, name, flag)
    local invisibleState = (name == "invisible")
    flag = flag and true or false
    local oldFlag = self.state[name]
    if oldFlag ~= flag then
        local durationParamName
        if invisibleState then
            durationParamName = "VisibilityTransitionSeconds"
            self.visible = not flag
        else
            durationParamName = name.."TransitionSeconds"
        end
        if getApp[self] then -- connected to app
            local currentValues = self.currentValues
            local isIgnored = ignored[self]
            local duration  = getStyleParam(self, durationParamName) or 0 
            if invisibleState then
                if duration > 0 then
                    ignored[self] = false
                    isIgnored = false
                end
            elseif isIgnored then
                duration = 0
            end
            Super.setState(self, name, flag)
            local now       = self:getCurrentTime()
            local endTime   = now + duration
            local hasTrans = false
            for paramName, trans in pairs(self.paramTransitions) do
                local endValue = getStyleParam(self, paramName)
                if (not trans or trans == true or not trans.endTime)
                   and (duration <= 0 or endValue == currentValues[paramName]) 
                then
                    currentValues[paramName] = endValue
                else
                    hasTrans = true
                    local currentValue
                    if not isIgnored then
                        currentValue = currentValues[paramName]
                        if trans == true then
                            trans = {
                                startValue  = currentValue,
                                endValue    = endValue,
                                startTime   = now,
                                endTime     = endTime,
                            }
                            self.paramTransitions[paramName] = trans
                        else
                            if not trans.endTime or trans.endValue ~= endValue then
                                trans.startValue  = currentValue
                                trans.endValue    = endValue
                                trans.startTime   = now
                                local tendTime = trans.endTime
                                if not tendTime or tendTime < endTime then
                                    trans.endTime = endTime
                                end
                            end
                        end
                    else
                        currentValue = endValue
                        currentValues[paramName] = endValue
                        if trans then
                            trans.endTime = false
                        end
                    end
                end
            end
            if invisibleState then
                if hasTrans then
                    assureActiveAnimation(self)
                end
                self:triggerParentLayout()
                self:triggerRedraw()
                
            elseif not isIgnored then
                if hasTrans then
                    assureActiveAnimation(self)
                end
                self:triggerRedraw()
            end
        else
            Super.setState(self, name, flag)
            if invisibleState then
                ignored[self] = flag
            end
        end
    end
end

function Animatable:isVisible()
    return self.visible
end

function Animatable:setVisible(shouldBeVisible)
    if shouldBeVisible ~= self.visible then
        _setState(self, "invisible", not shouldBeVisible)
    end
end

function Animatable:setState(name, flag)
    _setState(self, name, flag)
end

function Animatable:setStates(stateNames)
    for _, stateName in ipairs(stateNames) do
        _setState(self, stateName, true)
    end
end

function Animatable:getStyleParam(paramName)
    local value = self.currentValues[paramName]
    local wasInCache = value
    if value == nil then
        value = getStyleParam(self, paramName)
        if value ~= nil then
            self.currentValues[paramName] = value
            local animatable = getStyleParams[self].animatable[paramName]
            if animatable or paramName:match("^.*Opacity") then
                self.paramTransitions[paramName] = true
            else
                self.paramTransitions[paramName] = false
            end
        end
    end
    return value
end


function Animatable:updateAnimation()
    if self.animationUpdated then
        return
    end
    self.animationUpdated = true
    
    local now          = self:getCurrentTime()
    local currentValues= self.currentValues
    local isIgnored    = ignored[self]
    local hasActive    = false

    for paramName, trans in pairs(self.paramTransitions) do
        if trans and trans ~= true then
            local endTime = trans.endTime
            if endTime then
                local isActive = endTime > now
                if isActive then
                    if isIgnored then
                        currentValues[paramName] = trans.endValue
                        trans.endTime = false
                    else
                        hasActive = true
                        local startTime = trans.startTime
                        local T = endTime - startTime
                        if T > 0 then
                            local t = (now - startTime)/T
                            currentValues[paramName] =  (1-t) * trans.startValue + t * trans.endValue
                        else
                            currentValues[paramName] = trans.endValue
                        end
                    end
                else
                    currentValues[paramName] = trans.endValue
                    trans.endTime = false
                    if paramName == "Opacity" and not self.visible and not isIgnored then
                        ignored[self] = true
                    end
                end
            end
        end
    end
    if not isIgnored and ignored[self] then
        for paramName, trans in pairs(self.paramTransitions) do
            if trans and trans ~= true then
                currentValues[paramName] = trans.endValue
                trans.endTime = false
            end
        end
    end
    if hasActive then
        self.animationActive = true
        if not self.animationTriggered then
            self.animationTriggered = true
            getAnimations(self):add(self)
        end
    else
        self.animationActive = false
    end
end

return Animatable
