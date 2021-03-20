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
local getStyle             = lwtk.get.style
local getFocusHandler      = lwtk.get.focusHandler
local getFocusableChildren = lwtk.get.focusableChildren
local getActions           = lwtk.get.actions
local wantsFocus           = lwtk.get.wantsFocus
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



local function setStyleParams(self, style)
    getStyle[self] = style
    for _, child in ipairs(self) do
        setStyleParams(child, style)
    end
end

function Widget:_setApp(app)
    Super._setApp(self, app)
    if not getStyle[self] then
        local style = getStyle[app]
        if style then
            setStyleParams(self, style)
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
    if not getStyle[self] then
        local style = getStyle[parent]
        if style then
            setStyleParams(self, style)
        end
    end
end

local _setFrame = Super._setFrame

function Widget:_setFrame(newX, newY, newW, newH, fromFrameAnimation)
    if not fromFrameAnimation and self._frameTransition then
        self._frameTransition = false
    end
    _setFrame(self, newX, newY, newW, newH)
end

return Widget
