local lwtk = require"lwtk"

local utf8     = lwtk.utf8
local fillRect = lwtk.draw.fillRect

local Focusable  = lwtk.Focusable
local Super      = lwtk.Button
local PushButton = lwtk.newClass("lwtk.PushButton", Super)

PushButton:implementFrom(Focusable)

function PushButton:new(initParams)
    self.text = ""
    Super.new(self, initParams)
end

function PushButton:setOnClicked(onClicked)
    self.onClicked = onClicked
end
function PushButton:setText(text)
    local a, b, c = string.match(text, "^([^&]*)&().*$")
    if not a then
        a = ""
        b = ""
        c = text
    else
        local nextCharPos = utf8.offset(text, 2, b)
        b = text:sub(b, nextCharPos - 1)
        c = text:sub(nextCharPos)
        local B = utf8.upper(b)
        self.hotkey = B
        self:setHotkey(B)
    end
    self.labelLeft  = a
    self.labelKey   = b
    self.labelRight = c
    self.label      = a..b..c
    self.text       = text
    self:triggerRedraw()
end
function PushButton:onMouseEnter(x, y)
    self.mouseEntered = true
    self:setState("hover", true)
end
function PushButton:onMouseLeave(x, y)
    self.mouseEntered = false
    self:setState("hover", false)
end
function PushButton:onMouseDown(x, y, button, modState)
    self.mousePressed = true
    self:setState("pressed", true)
    self:setFocus()
end
function PushButton:onMouseUp(x, y, button, modState)
    self.mousePressed = false
    self:setState("pressed", false)
    if self.state.hover and self.onClicked then
        self:onClicked()
    end
end
function PushButton:onFocusIn()
    self:setState("focused", true)
end
function PushButton:onFocusOut()
    self:setState("focused", false)
end

local function simulateButtonClick2(self)
    self:setState("pressed", self.mousePressed)
    self:setState("hover",   self.mouseEntered)
    if self.onClicked then
        self:onClicked()
    end
end

local function simulateButtonClick1(self)
    self:setState("hover",   true)
    self:setState("pressed", true)
    self:setTimer(self:getStyleParam("SimulateButtonClickSeconds") or 0.1, 
                  simulateButtonClick2, self)
end

function PushButton:onHotkeyDown()
    simulateButtonClick1(self)
end

function PushButton:getMeasures()
    local ctx = self:getLayoutContext()
    ctx:select_font_face("sans-serif", "normal", "normal")
    ctx:set_font_size(self:getStyleParam("TextSize"))
    local ext = ctx:text_extents(self.label)
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
    fillRect(ctx, self:getStyleParam("BackgroundColor"), 0, 0, w, h)
    ctx:set_source_rgba(self:getStyleParam("TextColor"):toRGBA())
    if self.label then
        ctx:select_font_face("sans-serif", "normal", "normal")
        ctx:set_font_size(self:getStyleParam("TextSize"))
        local ext  = ctx:text_extents(self.label)
        local fext = ctx:font_extents()
        local fh   = fext.ascent + fext.descent
        local offs = self:getStyleParam("TextOffset")
        local tx = (w - ext.width)/2
        local ty = (h - fh)/2 + fext.ascent
        ctx:move_to(offs + math.floor(tx+0.5), offs + math.floor(ty+0.5)) -- sharper text
        ctx:show_text(self.label)
        if self.hotkey and self:isHotkeyEnabled(self.hotkey) then
            local x1 = tx + ctx:text_extents(self.labelLeft).x_advance + ctx:text_extents(self.labelKey).x_bearing
            local x2 = x1 + ctx:text_extents(self.labelKey).width
            local y1 = ty + fext.descent / 2
            ctx:set_line_width(1)
            ctx:move_to(math.floor(x1 + 0.5 + offs) + 0.5, math.floor(y1 + 0.5 + offs) + 0.5)
            ctx:line_to(math.floor(x2 + 0.5 + offs) + 0.5, math.floor(y1 + 0.5 + offs) + 0.5)
            ctx:stroke()
        end
    end
    local borderSize  = self:getStyleParam("BorderSize") or 0
    local borderColor = self:getStyleParam("BorderColor")
    if borderSize > 0 and borderColor then
        ctx:rectangle(0.5, 0.5, w-1, h-1)
        ctx:set_source_rgba(borderColor:toRGBA())
        ctx:set_line_width(borderSize)
        ctx:stroke()
    end
end

return PushButton
