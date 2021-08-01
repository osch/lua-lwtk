local lwtk = require"lwtk"

local match       = string.match
local getActions  = lwtk.get.actions

local Super          = lwtk.Object
local Actionable     = lwtk.newClass("lwtk.Actionable", Super)

function Actionable:new(initParams)
    if initParams then
        self:setInitParams(initParams)
    end
end

function Actionable:setInitParams(initParams)
    if initParams then
        local objectActions
        local hasRemaining = false
        for k, v in pairs(initParams) do
            if type(k) == "string" and match(k, "^onAction") then
                if not objectActions then objectActions = {} end
                objectActions[k] = v
                initParams[k] = nil
            else
                hasRemaining = true
            end
        end
        if objectActions then
            getActions[self] = objectActions
        end
        if hasRemaining then
            local handleRemainingInitParams = self.handleRemainingInitParams
            if handleRemainingInitParams then
                handleRemainingInitParams(self, initParams)
            else
                Super.setAttributes(self, initParams)
            end
        end
    end
end

function Actionable:hasActionMethod(actionMethodName)
    if self[actionMethodName] then
        return true
    else
        local objectActions = getActions[self]
        return objectActions and objectActions[actionMethodName]
    end
end

function Actionable:invokeActionMethod(actionMethodName)
    local method = self[actionMethodName]
    if method then
        return method(self)
    else
        local objectActions = getActions[self]
        if objectActions  then
            method = objectActions[actionMethodName]
            if method then
                return method(self)
            end
        end
    end
end

return Actionable
