local lwtk = require"lwtk"

local sort   = table.sort
local concat = table.concat
local match  = string.match
local lower  = string.lower

local getParent      = lwtk.get.parent
local getStyleParams = lwtk.get.styleParams
local toPattern      = lwtk.StyleRule.toPattern

local Styleable = lwtk.newClass("lwtk.Styleable")

function Styleable.initClass(mixinClass, newClass)
    local className = newClass.__name
    local m = match(className, "^.*%.([^.]*)$")
    className = m or className
    newClass.styleSelectorClassPath = (newClass.styleSelectorClassPath or "").."<"..lower(className)..">"
    return newClass
end

function Styleable:setState(name, flag)
    flag = flag and true or false
    self.state[name] = flag
    self.stateStyleSelectorPath = nil
end

function Styleable:setStyle(styleRules)
    local rules = {}
    for i, r in ipairs(styleRules) do
        rules[i] = { toPattern(r[1], r[2]) }
    end
    self.styleRules = rules
end


function Styleable:getStyleParams()
    local styleParams = getStyleParams[self]
    if not styleParams then
        local parent = getParent[self]
        if parent then
            styleParams = parent:getStyleParams()
            getStyleParams[self] = styleParams
        end
    end
    return styleParams
end

function Styleable:getStateStyleSelectorPath()
    local path = self.stateStyleSelectorPath
    if not path then
        local state = self.state
        local stateNames = {}
        if state then
            for name, flag in pairs(state) do
                if flag then
                    stateNames[#stateNames + 1] = name
                end
            end
        end
        if #stateNames > 0 then
            sort(stateNames)
            path = "<"..concat(stateNames, "><")..">"
        else
            path = ""
        end
        self.stateStyleSelectorPath = path
    end
    return path
end

local getStateStyleSelectorPath = Styleable.getStateStyleSelectorPath

function Styleable:getStyleParam(paramName)
    local styleParams = self:getStyleParams()
    if styleParams then
        local statePath = getStateStyleSelectorPath(self)
        return styleParams:getStyleParam(paramName, self.styleSelectorClassPath, statePath, self.styleRules)
    end
end

return Styleable
