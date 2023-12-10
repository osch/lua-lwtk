local lwtk = require"lwtk"

local getApp     = lwtk.get.app
local keyNameMap = lwtk.love.keyNameMap

local Super = lwtk.MouseDispatcher(lwtk.Node(lwtk.Application))

--[[
    Application implementation for the [LÖVE](https://love2d.org/) 2D game engine.
    
    Use lwtk.Application for runing standalone desktop applications.
]]
local Application = lwtk.newClass("lwtk.love.Application", Super)

Application:declare(
    "_implicitWindowFocus",
    "_keyModState",
    "modKeyToBit",
    "mouseEntered",
    "focusWindow",
    "_handledKey"
)


function Application.override:new(initParams)
    if not initParams then
        initParams = {}
    end
    if not initParams.driver then
        initParams.driver = lwtk.love.Driver()
    end
    getApp[initParams.driver] = self
    Super.new(self, initParams)
    self._implicitWindowFocus = true
    self._keyModState = 0
    self.modKeyToBit = {
        rshift   = lwtk.MOD_SHIFT,
        lshift   = lwtk.MOD_SHIFT,
        rctrl    = lwtk.MOD_CTRL,
        lctrl    = lwtk.MOD_CTRL,
       --ralt    = lwtk.MOD_ALT,
        ralt     = lwtk.MOD_ALTGR, -- !!
        lalt     = lwtk.MOD_ALT,
        rgui     = lwtk.MOD_SUPER,
        lgui     = lwtk.MOD_SUPER,
        capslock = lwtk.MOD_CTRL -- !!
    }
end

local setFocusWindow

function Application.override:update()
    local driver = self.driver
    do
        local newWindows = driver.newWindows 
        local n = #newWindows
        for i = 1, n do
            local window = newWindows[i]
            local view = window.view
            window:_handleConfigure(view.x, view.y, view.w, view.h)
            newWindows[i] = nil
            if i == n and self._implicitWindowFocus then
                setFocusWindow(self, window)
            end
        end
    end
    local ct = love.timer.getTime()
    local nt = driver.nextProcessTime
    if nt and nt <= ct then
        driver.nextProcessTime = nil
        driver.processFunc()
    end
    if self._hasChanges then
        self:_processAllChanges()
    end
end

function Application:draw()
    love.graphics.reset()
    local drawContext = self.driver.drawContext
    local drawn = false
    for _, win in ipairs(self) do
        if win.visible then
            local opacity = win:getStyleParam("Opacity") or 1
            drawn = true
            local view = win.view
            local damagedArea = view.damagedArea
            if damagedArea.count > 0 then
                drawContext:_reset()
                love.graphics.setCanvas(view.canvas)
                for _, ax, ay, aw, ah in damagedArea:iteration() do
                    drawContext:save()
                    drawContext:intersectClip(ax, ay, aw, ah)
                    love.graphics.setColor(0,0,0,1)
                    love.graphics.rectangle("fill", ax, ay, aw, ah)
                    win:_handleExpose(ax, ay, aw, ah, 0)
                    drawContext:restore()
                end
                damagedArea:clear()
                drawContext:_reset()
            end
            love.graphics.setColor(1,1,1, opacity)
            love.graphics.draw(view.canvas, view.x, view.y)
        end
    end
    if drawn then
        love.graphics.reset()
    end
end

function Application:mousemoved(x, y)
    if love.window.hasFocus() then
        self:_processMouseMove(self.mouseEntered, x, y)
    end
end

function Application:mousepressed(x, y, button)
    if love.window.hasFocus() then
        return self:_processMouseDown(x, y, button)
    end
end

function Application:mousereleased(x, y, button)
    self:_processMouseUp(self.mouseEntered, x, y, button)
end

function Application:mousefocus(focus)
    self.mouseEntered = focus
    if love.window.hasFocus() then
        if focus then
            self:_processMouseEnter(love.mouse.getPosition())
        else
            self:_processMouseLeave(love.mouse.getPosition())
        end
    end
end

function Application:focus(focus)
    if focus then
        if love.window.hasMouseFocus() then
            self.mouseEntered = true
            self:_processMouseEnter(love.mouse.getPosition())
        end
        local focusWindow = self.focusWindow
        if focusWindow then
            focusWindow:_handleFocusIn()
        end
    else
        self._handledKey = false
        if self.mouseEntered then
            self.mouseEntered = false
            self:_processMouseLeave(love.mouse.getPosition())
        end
        local focusWindow = self.focusWindow
        if focusWindow then
            focusWindow:_handleFocusOut()
        end
    end
end



function Application:keypressed(key)
    local modState = self._keyModState
    local modBit = self.modKeyToBit[key]
    if modBit then
        modState = bit.bor(modState, modBit)
        self._keyModState = modState
    end
    local focusWindow = self.focusWindow
    if focusWindow then
        key = keyNameMap[key] or key
        local handled = focusWindow:_handleKeyDown(key, modState)
        if handled then
            self._handledKey = key
        else
            self._handledKey = false
        end
    end
end

function Application:keyreleased(key)
    local modState = self._keyModState
    local modBit = self.modKeyToBit[key]
    if modBit then
        modState = bit.band(modState, bit.bnot(modBit))
        self._keyModState = modState
    end
    local focusWindow = self.focusWindow
    if focusWindow then
        key = keyNameMap[key] or key
        self._handledKey = false
        focusWindow:_handleKeyUp(key, modState)
    end
end

function Application:textinput(text)
    local focusWindow = self.focusWindow
    if focusWindow then
        if not self._handledKey then
            focusWindow:_handleKeyDown(nil, self._keyModState, text)
        end
    end
end

setFocusWindow = function(self, window)
    local oldFocusWindow = self.focusWindow
    if oldFocusWindow ~= window then
        self._handledKey = false
        if oldFocusWindow and oldFocusWindow.hasFocus then
            oldFocusWindow:_handleFocusOut()
        end
        self.focusWindow = window
        if window and love.window.hasFocus() then
            window:_handleFocusIn()
        end
    end
end

function Application:setFocusWindow(window)
    setFocusWindow(self, window)
    self._implicitWindowFocus = false
end

return Application

