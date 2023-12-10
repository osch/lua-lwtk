local lwtk = require"lwtk"

local match           = string.match
local sub             = lwtk.utf8.sub
local len             = lwtk.utf8.len
local extract         = lwtk.extract
local floor           = math.floor
local InnerCompound   = lwtk.InnerCompound
local TextFragment    = lwtk.TextFragment
local TextCursor      = lwtk.TextCursor
local getFocusHandler = lwtk.get.focusHandler
local getApp          = lwtk.get.app


local Super      = lwtk.Focusable(lwtk.Control(lwtk.Compound(lwtk.Widget)))
local TextInput  = lwtk.newClass("lwtk.TextInput", Super)

TextInput:declare(
    "initActions",
    "inner",
    "cursor",
    "textFragment",
    "cursorPos",
    "tx",
    "text",
    "filterInput"
)

TextInput.implement.getMeasures = lwtk.TextLabel.getMeasures

TextInput.implement._isInput = true

function TextInput.override:new(initParams)
    Super.new(self)
    self.initActions  = extract(initParams, "initActions")
    self.inner        = self:addChild(InnerCompound())
    self.cursor       = self.inner:addChild(TextCursor())
    self.textFragment = self.inner:addChild(TextFragment())
    self.cursorPos    = 1
    self.tx           = 0
    self:setInitParams(initParams)
    if not self.text then
        self:setText("")
    end
end

function TextInput.implement:onRealize()
    if Super.onRealize then
        Super.onRealize(self)
    end
    if self.initActions then
        for _, a in ipairs(self.initActions) do
            if not match(a, "^onAction") then
                a = "onAction"..a
            end
            self:invokeActionMethod(a)
        end
    end
end

local function innerLayout(self)
    local inner, tx          = self.inner, self.tx
    local textFragment       = self.textFragment
    local cursorPos          = self.cursorPos
    local iw, ih             = inner.w, inner.h
    local fontInfo           = textFragment:getFontInfo()
    local fh, ascent         = fontInfo.height, fontInfo.ascent
    local dy = floor((ih - fh)/2 + 0.5)
    local cw = self:getStyleParam("CursorWidth") or 1
    textFragment:setFrame(0, 0, iw, ih)
    local tlen = len(self.text)
    if cursorPos > tlen + 1 then
        cursorPos = tlen + 1
        self.cursorPos = cursorPos
    end
    local cx = fontInfo:getTextWidth(sub(self.text, 1, cursorPos - 1))
    local pw = 0
    if cursorPos > 1 then
        pw = fontInfo:getTextWidth(sub(self.text, cursorPos - 1, cursorPos - 1))
    end
    local atEnd = (cursorPos == tlen + 1)
    local nw
    if atEnd then
        nw = cw
    else
        nw = fontInfo:getTextWidth(sub(self.text, cursorPos, cursorPos))
        if nw < cw then nw = cw end
    end
    if cx - pw < tx then
        tx = cx - pw
        if tx < 0 then tx = 0 end
        self.tx = tx
    elseif cx + nw - tx >= iw then
        tx = cx + nw - iw
        if tx < 0 then tx = 0 end
        self.tx = tx
    end
    if tx > 0 then
        local tw = fontInfo:getTextWidth(self.text) + cw
        if tw - tx < iw then
            tx = tw - iw
        end
        if tx < 0 then tx = 0 end
        self.tx = tx
    end
    textFragment:setTextPos(-tx, dy + ascent)
    self.cursor:setFrame(cx - tx, dy, cw, fh)
end

function TextInput:setText(text)
    if self.text ~= text then
        self.text = text
        self.textFragment:setText(text)
        self:notifyInputChanged()
        if getApp[self] then
            innerLayout(self)
        end
    end
end

function TextInput:setDefault(buttonId)
    self.default = buttonId
    if self.hasFocus then
        local focusHandler = getFocusHandler[self]
        if focusHandler then
            focusHandler:setDefault(buttonId, true)
        end
    end
end

function TextInput.override:onLayout(width, height)
    Super.onLayout(self, width, height)
    innerLayout(self)
end

function TextInput.implement:onFocusIn()
    self:setState("focused", true)
    if self.default then
        local focusHandler = getFocusHandler[self]
        if focusHandler then
            focusHandler:setDefault(self.default, true)
        end
    end
end
function TextInput.implement:onFocusOut()
    self:setState("focused", false)
    if self.default then
        local focusHandler = getFocusHandler[self]
        if focusHandler then
            focusHandler:setDefault(self.default, false)
        end
    end
end

function TextInput.implement:onMouseDown(mx, my, button, modState)
    if button == 1 then
        self:setFocus(true)
        local fontInfo = self.textFragment:getFontInfo()
        local cx = self.cursor.x
        local cp = self.cursorPos
        if cx < mx then
            local maxcp = len(self.text) + 1
            local dx
            repeat
                dx = fontInfo:getTextWidth(sub(self.text, cp, cp))
                cx = cx + dx
                if cp == maxcp then break end
                cp = cp + 1
            until mx <= cx
            if mx <= cx and cx - mx < dx then
                cp = cp - 1
            end
        else
            local dx
            repeat
                dx = fontInfo:getTextWidth(sub(self.text, cp, cp))
                cx = cx - dx
                if cp == 1 then break end
                cp = cp - 1
            until cx < mx
            if cx < mx and mx - cx > dx then
                cp = cp + 1
            end
        end
        if self.cursorPos ~= cp then
            self.cursorPos = cp
            innerLayout(self)
        end
    end
end

function TextInput:onActionCursorRight()
    local p = self.cursorPos
    if p <= len(self.text) then
        self.cursorPos = p + 1
        innerLayout(self)
    end
    return true
end
function TextInput:onActionCursorLeft()
    local p = self.cursorPos
    if p > 1 then 
        self.cursorPos = p - 1
        innerLayout(self)
    end
    return true
end

function TextInput:onActionDeleteCharLeft()
    local text      = self.text
    local cursorPos = self.cursorPos
    if cursorPos > 1 then
        local nt = sub(text, 1, cursorPos - 2) .. sub(text, cursorPos)
        self.cursorPos = cursorPos - 1
        self:setText(nt)
        innerLayout(self)
    end
    return true
end

function TextInput:onActionDeleteCharRight()
    local text      = self.text
    local cursorPos = self.cursorPos
    if cursorPos <= len(text) then
        local nt = sub(text, 1, cursorPos - 1) .. sub(text, cursorPos + 1)
        self:setText(nt)
        innerLayout(self)
    end
    return true
end

function TextInput:onActionCursorToBeginOfLine()
    if self.cursorPos > 1 then
        self.cursorPos = 1
        innerLayout(self)
    end
    return true
end

function TextInput:onActionCursorToEndOfLine()
    local text      = self.text
    local cursorPos = self.cursorPos
    local tlen      = len(text)
    if cursorPos <= tlen then
        self.cursorPos = tlen + 1
        innerLayout(self)
    end
    return true
end

function TextInput:onActionInputNext()
    local focusHandler = getFocusHandler[self]
    if focusHandler then
        focusHandler:setFocusToNextInput(self)
    end
    return true
end
function TextInput:onActionInputPrev()
    local focusHandler = getFocusHandler[self]
    if focusHandler then
        focusHandler:setFocusToPrevInput(self)
    end
    return true
end

function TextInput:setFilterInput(filterInput)
    self.filterInput = filterInput
end

function TextInput.implement:onKeyDown(keyName, keyState, keyText)
    if keyText and keyText ~= "" then
        local filterInput = self.filterInput
        if filterInput then
            keyText = filterInput(self, keyText)
        end
        if keyText then
            local text      = self.text
            local cursorPos = self.cursorPos
            local nt = sub(text, 1, cursorPos - 1) .. keyText .. sub(text, cursorPos)
            self.cursorPos = cursorPos + 1
            self:setText(nt)
            innerLayout(self)
            return true
        end
    end
end

return TextInput
