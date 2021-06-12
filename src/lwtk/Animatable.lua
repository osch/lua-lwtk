local lwtk = require("lwtk")

local floor = math.floor

local Super       = lwtk.Styleable
local Animatable  = lwtk.newClass("lwtk.Animatable", Super)

local getApp       = lwtk.get.app
local getStyle     = lwtk.get.style

local callOnLayout       = lwtk.layout.callOnLayout

local paramTransitions = lwtk.WeakKeysTable()
local stateTransitions = lwtk.WeakKeysTable()
local currentValues    = lwtk.WeakKeysTable()

function Animatable:new()
    Super.new(self)
    paramTransitions[self]    = {}
    stateTransitions[self]    = {}
    currentValues[self]       = {}
    
    self._animationActive     = false
    self._animationTriggered  = false
    self._animationUpdated    = false
end

local getStyleParam = Super.getStyleParam

local function addToAnimations(self)
    local app = assert(getApp[self], "widget not connected to application")
    app._animations:add(self)
end

function Animatable:animateFrame(newX, newY, newW, newH, isLayoutTransition)
    if    self.x ~= newX or self.y ~= newY 
       or self.w ~= newW or self.h ~= newH
    then
        local duration = self:getStyleParam("FrameTransitionSeconds") or 0
        if duration > 0 then
            local trans = self._frameTransition
            if not trans then
                trans = {}
                self._frameTransition = trans
                if not self._animationTriggered then
                    self._animationTriggered = true
                    addToAnimations(self)
                end
            end
            local now = self:getCurrentTime()
            trans.oldX = self.x
            trans.oldY = self.y
            trans.oldW = self.w
            trans.oldH = self.h
            trans.newX = newX
            trans.newY = newY
            trans.newW = newW
            trans.newH = newH
            trans.startTime = now
            trans.endTime   = now + duration
            trans.isLayoutTransition = isLayoutTransition
        else
            self._frameTransition = false
            self:_setFrame(newX, newY, newW, newH)
        end
    end
end

local function assureActiveAnimation(self)
    if not self._animationTriggered then
        self._animationTriggered = true
        self._animationUpdated   = false
        addToAnimations(self)
    end
    self._animationActive = true
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
            local currentValues = currentValues[self]
            local isIgnored = self._ignored
            local duration  = getStyleParam(self, durationParamName) or 0 
            if invisibleState then
                if duration > 0 then
                    self._ignored = false
                    isIgnored = false
                end
            elseif isIgnored then
                duration = 0
            end
            Super.setState(self, name, flag)
            local now = self:getCurrentTime()

            local stateTrans = stateTransitions[self][name]
            if not stateTrans and not isIgnored then
                stateTrans = {
                    targetValue = flag,
                    startTime   = now,
                    endTime     = now + duration
                }
                stateTransitions[self][name] = stateTrans
            else
                if not isIgnored then
                    local newD
                    if stateTrans.endTime and now < stateTrans.endTime and stateTrans.targetValue ~= flag then
                        local T = stateTrans.endTime - stateTrans.startTime
                        if T > 0 then
                            local t = (now - stateTrans.startTime) / T
                            newD = duration * t
                        end
                    end
                    stateTrans.targetValue = flag
                    stateTrans.startTime   = newD and (now + newD -  duration) or now
                    stateTrans.endTime     = now + (newD or duration)
                    if newD then duration  = newD end
                else
                    stateTrans.endTime = false
                end
            end
            local endTime = now + duration
            local hasTrans = false
            for paramName, trans in pairs(paramTransitions[self]) do
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
                            paramTransitions[self][paramName] = trans
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
                if duration == 0 and not flag then
                    for paramName, trans in pairs(paramTransitions[self]) do
                        if trans and trans ~= true then
                            currentValues[paramName] = trans.endValue
                            trans.endTime = false
                        end
                    end
                    for stateName2, stateTrans2 in pairs(stateTransitions[self]) do
                        stateTrans2.endTime = false
                    end
                end
                self:triggerLayout()
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
                self._ignored = flag
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

function Animatable:_setStyleFromParent(parentStyle)
    currentValues[self] = {}
    Super._setStyleFromParent(self, parentStyle)
end

function Animatable:setStyle(style)
    currentValues[self] = {}
    Super.setStyle(self, style)
end

function Animatable:getStyleParam(paramName)
    local value = currentValues[self][paramName]
    local wasInCache = value
    if value == nil then
        value = getStyleParam(self, paramName)
        if value ~= nil then
            currentValues[self][paramName] = value
            local animatable = getStyle[self].animatable[paramName]
            if animatable or paramName:match("^.*Opacity") then
                paramTransitions[self][paramName] = true
            else
                paramTransitions[self][paramName] = false
            end
        end
    end
    return value
end


function Animatable:updateAnimation()
    if self._animationUpdated then
        return
    end
    self._animationUpdated = true
    
    local now          = self:getCurrentTime()
    local currentValues= currentValues[self]
    local isIgnored    = self._ignored
    local hasActive    = false

    for paramName, trans in pairs(paramTransitions[self]) do
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
                        self._ignored = true
                    end
                end
            end
        end
    end
    if not isIgnored and self._ignored then
        for paramName, trans in pairs(paramTransitions[self]) do
            if trans and trans ~= true then
                currentValues[paramName] = trans.endValue
                trans.endTime = false
            end
        end
        for stateName, stateTrans in pairs(stateTransitions[self]) do
            stateTrans.endTime = false
        end
    end
    if hasActive then
        self._animationActive = true
        if not self._animationTriggered then
            self._animationTriggered = true
            addToAnimations(self)
        end
    else
        self._animationActive = false
    end
end

return Animatable
