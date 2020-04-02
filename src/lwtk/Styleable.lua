local lwtk = require"lwtk"

local sort   = table.sort
local concat = table.concat
local match  = string.match
local lower  = string.lower

local getParent      = lwtk.get.parent
local getStyleParams = lwtk.get.styleParams
local getStylePath   = lwtk.get.stylePath
local toPattern      = lwtk.StyleRule.toPattern

local getStateStylePath = setmetatable({}, { __mode = "k" })

local Styleable = lwtk.newClass("lwtk.Styleable")

local function addToStyleSelectorClassPath(path, name)
    local n = match(name, "^.*%.([^.]*)$")
    name = n or name
    return (path or "").."<"..lower(name)..">"
end

function Styleable.initClass(mixinClass, newClass, additionalStyleSelector, ...)
    local className = newClass.__name
    local path = getStylePath[newClass.super]
    path = addToStyleSelectorClassPath(path, className)
    if additionalStyleSelector then
        path = addToStyleSelectorClassPath(path, additionalStyleSelector)
        for i = 1, select("#", ...) do
            path = addToStyleSelectorClassPath(path, select(i, ...))
        end
    end
    getStylePath[newClass] = path
    return newClass
end

function Styleable:new()
    getStylePath[self] = getStylePath[getmetatable(self)]
end

function Styleable:setState(name, flag)
    flag = flag and true or false
    self.state[name] = flag
    getStateStylePath[self] = false
end

function Styleable:setStyle(styleRules)
    local typeList = getStyleParams[self].typeList
    local rules = {}
    for i, r in ipairs(styleRules) do
        rules[i] = toPattern(r, typeList)
    end
    self.styleRules = rules
end



function Styleable:getStateStyleSelectorPath()
    local path = getStateStylePath[self]
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
        getStateStylePath[self] = path
    end
    return path
end

local getStateStyleSelectorPath = Styleable.getStateStyleSelectorPath

function Styleable:getStyleParam(paramName)
    local styleParams = getStyleParams[self]
    if styleParams then
        local statePath = getStateStyleSelectorPath(self)
        return styleParams:getStyleParam(paramName, getStylePath[self], statePath, self.styleRules)
    end
end

return Styleable
