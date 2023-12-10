local lwtk = require"lwtk"

local getParent             = lwtk.get.parent
local getStyle              = lwtk.get.style
local Callback              = lwtk.Callback

local Super       = lwtk.Animatable(lwtk.Component)
local Widget      = lwtk.newClass("lwtk.Widget", Super)

Widget:declare(
    "default",
    "_isInput"
)

function Widget.override:new(initParams)
    Super.new(self)
    if initParams then
        self:setInitParams(initParams)
    end
end

function Widget:setOnInputChanged(onInputChanged)
    self.onInputChanged = onInputChanged
end

function Widget:setOnRealize(onRealize)
    self.onRealize = onRealize
end

function Widget:notifyInputChanged()
    local w = self
    repeat
        local c = w.onInputChanged
        if c then
            c(w, self)
        end
        w = getParent[w]
    until w == nil
end

function Widget.override:_setApp(app)
    if self._hasOwnStyle then
        local ownStyle = getStyle[self]
        if not ownStyle.parent then
            ownStyle:_setParentStyle(getStyle[app])
        end
    elseif not getStyle[self] then
        getStyle[self] = getStyle[app]
    end
    Super._setApp(self, app)
    local onRealize = self.onRealize
    if onRealize then
        app:deferChanges(Callback(onRealize, self))
    end
end

function Widget.override:_setParent(parent)
    local pstyle = getStyle[parent]
    if pstyle then
        self:_setStyleFromParent(pstyle)
    end
    Super._setParent(self, parent)
end

return Widget
