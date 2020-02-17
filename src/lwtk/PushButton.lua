local lwtk = require"lwtk"

local fillRect = lwtk.draw.fillRect

local Super      = lwtk.Button
local PushButton = lwtk.newClass("lwtk.PushButton", Super)


function PushButton:new(initParams)
    self.text = ""
    Super.new(self, initParams)
end

function PushButton:setOnClicked(onClicked)
    self.onClicked = onClicked
end
function PushButton:setText(text)
    self.text = text
    self:triggerRedraw()
end
function PushButton:onMouseEnter(x, y)
    self:changeState("hover", true)
end
function PushButton:onMouseLeave(x, y)
    self:changeState("hover", false)
end
function PushButton:onMouseDown(x, y, button, modState)
    self:changeState("pressed", true)
end
function PushButton:onMouseUp(x, y, button, modState)
    self:changeState("pressed", false)
    if self.state.hover and self.onClicked then
        self:onClicked()
    end
end
function PushButton:getMeasures()
    local ctx = self:getLayoutContext()
    ctx:select_font_face("sans-serif", "normal", "normal")
    ctx:set_font_size(self:getStyleParam("TextSize"))
    local ext = ctx:text_extents(self.text)
    local width  = (self:getStyleParam("Width") or 0)
    local height = (self:getStyleParam("Height") or 0)
    local minWidth =   (self:getStyleParam("LeftPadding") or 0)
                     + ext.width
                     + (self:getStyleParam("RightPadding") or 0)
    local bestWidth = minWidth < width and width or minWidth
    return minWidth, height, bestWidth, height, bestWidth, height
end
function PushButton:onDraw(ctx)
    local w, h = self:getSize()
    fillRect(ctx, self:getStyleParam("Color"), 0, 0, w, h)
    ctx:set_source_rgba(self:getStyleParam("TextColor"):toRGBA())
    if self.text then
        ctx:select_font_face("sans-serif", "normal", "normal")
        ctx:set_font_size(self:getStyleParam("TextSize"))
        local ext = ctx:text_extents(self.text)
        local offs = self:getStyleParam("TextOffset")
        local tx = (w - ext.width)/2
        local ty = (h - ext.height)/2 + ext.height
        ctx:move_to(offs + math.floor(tx+0.5), offs + math.floor(ty+0.5)) -- sharper text
        ctx:show_text(self.text)
    end
end

return PushButton
