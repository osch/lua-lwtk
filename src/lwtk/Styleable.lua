local lwtk = require"lwtk"

local sort   = table.sort
local concat = table.concat
local lower  = string.lower

local call           = lwtk.call
local getParent      = lwtk.get.parent
local getStyle       = lwtk.get.style
local getStylePath   = lwtk.get.stylePath

local getStateStylePath = setmetatable({}, { __mode = "k" })

local Styleable = lwtk.newMixin("lwtk.Styleable")

local NO_STYLE_SELECTOR = {}
Styleable.NO_STYLE_SELECTOR = NO_STYLE_SELECTOR

local function addToStyleSelectorClassPath(path, name)
    return (path or "").."<"..lower(name)..">"
end

function Styleable.initClass(Styleable, Super)  -- luacheck: ignore 431/Styleable

    function Styleable.newSubClass(className, baseClass, ...)
        local newClass = Super.newSubClass(className, baseClass, ...)
        local path = getStylePath[newClass.super]
        local addToStyleSelector = true
        for i = 1, select("#", ...) do
            if select(i, ...) == NO_STYLE_SELECTOR then
                addToStyleSelector = false
                break
            end
        end
        if addToStyleSelector then
            path = addToStyleSelectorClassPath(path, className, ...)
        end
        getStylePath[newClass] = path
        return newClass
    end

    function Styleable:new(initParams)
        local stylePath = getStylePath[getmetatable(self)]
        if stylePath then
            getStylePath[self] = stylePath
            self.state = {}
        end
        Super.new(self, initParams)
    end
end

function Styleable:setState(name, flag)
    flag = flag and true or false
    local state = self.state
    state[name] = flag
    getStateStylePath[state] = false
end

function Styleable:_setStyleFromParent(parentStyle)
    self:triggerLayout()
    local style
    if self._hasOwnStyle then
        style = getStyle[self]
        style:_replaceParentStyle(parentStyle)
    else
        style = parentStyle
        getStyle[self] = style
    end
    for _, child in ipairs(self) do
        call("_setStyleFromParent", child, style)
    end
end

function Styleable:setStyle(style)
    self:triggerLayout()
    if not lwtk.Object.is(style, lwtk.Style) then
        style = lwtk.Style(style)
    end
    if self._hasOwnStyle then
        local parent = getStyle[self].parent
        style:_setParentStyle(parent)
    else
        self._hasOwnStyle = true
        style:_setParentStyle(getStyle[self])
    end
    getStyle[self] = style
    for _, child in ipairs(self) do
        call("_setStyleFromParent", child, style)
    end
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
    local rslt = style:_getStyleParam(paramName, stylePath, statePath)
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
