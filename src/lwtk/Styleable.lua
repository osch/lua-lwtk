local lwtk = require"lwtk"

local sort   = table.sort
local concat = table.concat
local match  = string.match
local lower  = string.lower

local getParent      = lwtk.get.parent
local getStyle       = lwtk.get.style
local getStylePath   = lwtk.get.stylePath
local toPattern      = lwtk.internal.StyleRule.toPattern

local getStateStylePath = setmetatable({}, { __mode = "k" })

local Styleable = lwtk.newClass("lwtk.Styleable")

local ADOPT_PARENT_STYLE = {}

Styleable.ADOPT_PARENT_STYLE = ADOPT_PARENT_STYLE

local function addToStyleSelectorClassPath(path, name)
    local n = match(name, "^.*%.([^.]*)$")
    name = n or name
    return (path or "").."<"..lower(name)..">"
end

function Styleable.initClass(mixinClass, newClass, additionalStyleSelector, ...)
    if additionalStyleSelector ~= ADOPT_PARENT_STYLE then
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
    end
    return newClass
end

function Styleable:new()
    local stylePath = getStylePath[getmetatable(self)]
    if stylePath then
        getStylePath[self] = stylePath
        self.state = {}
    end
end

function Styleable:setState(name, flag)
    flag = flag and true or false
    local state = self.state
    state[name] = flag
    getStateStylePath[state] = false
end

function Styleable:setStyle(styleRules)
    local typeList = getStyle[self].typeList
    local rules = {}
    for i, r in ipairs(styleRules) do
        rules[i] = toPattern(r, typeList)
    end
    self.styleRules = rules
end



function Styleable:getStateString()
    local state = self.state
    local path = getStateStylePath[state]
    if not path then
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
        getStateStylePath[state] = path
    end
    return path
end

local getStateString = Styleable.getStateString

local function _getStyleParam(self, style, paramName)
    local stylePath = getStylePath[self]
    if not stylePath then
        local p = getParent[self]
        while p do
            stylePath = getStylePath[p]
            if stylePath then
                getStylePath[self] = stylePath
                self.state = p.state
                break
            else
                p = getParent[p]
            end
        end
    end
    assert(stylePath, "Widget not connected to parent")
    local statePath = getStateString(self)
    local rslt = style:_getStyleParam(paramName, stylePath, statePath, self.styleRules)
    if not rslt and paramName:match("^.*Opacity$") then
        return 1
    else
        return rslt
    end
end
Styleable._getStyleParam = _getStyleParam

function Styleable:getStyleParam(paramName)
    if not self.visible and paramName == "Opacity" then
        return 0
    end
    local style = getStyle[self]
    if style then
        return _getStyleParam(self, style, paramName)
    end
end

return Styleable
