local lwtk = require"lwtk"

local sort   = table.sort
local concat = table.concat
local lower  = string.lower

local call           = lwtk.call
local getParent      = lwtk.get.parent
local getStyle       = lwtk.get.style
local getStylePath   = lwtk.get.stylePath
local getSuperClass  = lwtk.get.superClass
local isInstanceOf   = lwtk.isInstanceOf

local getStateStylePath = lwtk.WeakKeysTable("lwtk.Styleable.getStateStylePath")

local NO_STYLE_SELECTOR = {}

local function addToStyleSelectorClassPath(path, name)
    return (path or "").."<"..lower(name)..">"
end

local Styleable = lwtk.newMixin("lwtk.Styleable",
    
    function(Styleable, Super)

        Styleable:declare(
            "_hasOwnStyle",
            "state"
        )

        function Styleable.static.newSubClass(baseClass, className, ...)
            local newClass = Super.newSubClass(baseClass, className, ...)
            local path = getStylePath[getSuperClass[newClass]]
            local addToStyleSelector = true
            for i = 1, select("#", ...) do
                if select(i, ...) == NO_STYLE_SELECTOR then
                    addToStyleSelector = false
                    break
                end
            end
            if addToStyleSelector then
                path = addToStyleSelectorClassPath(path, className:match("^[^(]*"), ...)
            end
            getStylePath[newClass] = path
            return newClass
        end
    
        function Styleable.override:new(initParams)
            local stylePath = getStylePath[self:getClass()]
            if stylePath then
                getStylePath[self] = stylePath
                self.state = {}
            end
            Super.new(self, initParams)
        end
    end
)

Styleable.NO_STYLE_SELECTOR = NO_STYLE_SELECTOR

function Styleable:setState(name, flag)
    flag = flag and true or false
    local state = self.state
    state[name] = flag
    getStateStylePath[state] = false
end

function Styleable.implement:_setStyleFromParent(parentStyle)
    self:triggerLayout()
    local style
    if self._hasOwnStyle then
        style = getStyle[self]
        style:_replaceParentStyle(parentStyle)
    else
        style = parentStyle
        getStyle[self] = style
    end
    for i = 1, #self do
        call("_setStyleFromParent", self[i], style)
    end
end

function Styleable:setStyle(style)
    self:triggerLayout()
    if not isInstanceOf(style, lwtk.Style) then
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
    for i = 1, #self do
        local child = rawget(self, i)
        call("_setStyleFromParent", child, style)
    end
end

function Styleable:clearStyleCache()
    self:triggerLayout()
    local style = getStyle[self]
    if style then
        for _, child in ipairs(self) do
            call("_setStyleFromParent", child, style)
        end
    end
end



function Styleable:getStyle(style)
    return getStyle[self]
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

local function _getStyleParam2(self, paramName, style, extraParentStyle)
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
    local rslt = style:_getStyleParam(paramName, stylePath, statePath, self._hasOwnStyle, extraParentStyle)
    if not rslt and paramName:match("^.*Opacity$") then
        return 1
    else
        return rslt
    end
end
function Styleable:_getStyleParam(style, paramName)
    local myStyle = getStyle[self]
    if myStyle then
        return _getStyleParam2(self, paramName, myStyle, style)
    else
        return _getStyleParam2(self, paramName, style)
    end
end

function Styleable.override:getStyleParam(paramName)
    if not self.visible and paramName == "Opacity" then
        return 0
    end
    local style = getStyle[self]
    if style then
        return _getStyleParam2(self, paramName, style)
    end
end

return Styleable
