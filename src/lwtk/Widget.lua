local lwtk = require"lwtk"

local Application = lwtk.Application
local call        = lwtk.call
local Rect        = lwtk.Rect
local Animatable  = lwtk.Animatable

local intersectRects      = Rect.intersectRects
local roundRect           = Rect.round

local getApp               = lwtk.get.app
local getRoot              = lwtk.get.root
local getParent            = lwtk.get.parent
local getStyleParams       = lwtk.get.styleParams
local getFocusHandler      = lwtk.get.focusHandler
local getFocusableChildren = lwtk.get.focusableChildren
local getActions           = lwtk.get.actions
local wantsFocus           = lwtk.get.wantsFocus
local callOnLayout         = lwtk.layout.callOnLayout
local getStylePath         = lwtk.get.stylePath
local getFontInfos         = lwtk.get.fontInfos

local Super       = lwtk.Component
local Widget      = lwtk.newClass("lwtk.Widget", Super)

Widget:implementFrom(Animatable)
Widget.updateAnimation = Animatable.updateAnimation
Widget.getStyleParam   = Animatable.getStyleParam

function Widget.newClass(className, baseClass, additionalStyleSelector, ...)
    local newClass = Super.newClass(className, baseClass)
    Animatable:initClass(newClass, additionalStyleSelector, ...)
    return newClass
end

function Widget:new(initParams)
    if initParams then
        local id = initParams.id
        if id then
            assert(type(id) == "string", "id must be string")
            self.id = id
            initParams.id = nil
        end
        local style = initParams.style
        if style then
            self.style = style
            initParams.style = nil
        end
    end
    Super.new(self, initParams)
    Animatable.new(self)
end



local function setStyleParams(self, styleParams)
    getStyleParams[self] = styleParams
    for _, child in ipairs(self) do
        setStyleParams(child, styleParams)
    end
end

function Widget:_setApp(app)
    Super._setApp(self, app)
    if not getStyleParams[self] then
        local styleParams = getStyleParams[app]
        if styleParams then
            setStyleParams(self, styleParams)
        end
    end
    local style = self.style
    if style then
        self.style = nil
        self:setStyle(style)
    end
end

function Widget:_setParent(parent)
    Super._setParent(self, parent)
    if not getStyleParams[self] then
        local styleParams = getStyleParams[parent]
        if styleParams then
            setStyleParams(self, styleParams)
        end
    end
end

return Widget
