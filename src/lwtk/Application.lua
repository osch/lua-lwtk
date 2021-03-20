local lpugl = require"lpugl_cairo"
local lwtk  = require"lwtk"

local Timer       = lwtk.Timer
local Window      = lwtk.Window
local FontInfos   = lwtk.FontInfos
local Application = lwtk.newClass("lwtk.Application")

local getApp          = lwtk.get.app
local getStyle        = lwtk.get.style
local getKeyBinding   = lwtk.get.keyBinding
local getFontInfos    = lwtk.get.fontInfos

local isClosed        = setmetatable({}, { __mode = "k" })
local createClosures

function Application:new(arg1, arg2)
    local appName
    local initParams
    if type(arg1) == "string" then
        appName = arg1
        if lwtk.Object.is(arg2, lwtk.Style) then
            initParams =  { style = arg2 }
        else
            initParams = arg2 or {}
        end
    else
        initParams = arg1 or {}
        appName = initParams.name
        initParams.name = nil
    end

    isClosed[self] = false
    self.world     = lpugl.newWorld(appName)
    
    local style = initParams.style
    if style then
        initParams.style = nil
        if lwtk.Object.is(style, lwtk.Style) then
            style:setScaleFactor(style.scaleFactor * self.world:getScreenScale())
        else
            style.scaleFactor = (style.scaleFactor or 1) * self.world:getScreenScale()
            style = lwtk.Style(style)
        end
    else
        if not initParams.screenScale then
            initParams.screenScale = self.world:getScreenScale()
        end
        style = lwtk.DefaultStyle(initParams)
    end
    
    if getApp[style] then
        error("Style was alread added to app")
    end
    getApp[style]  = self
    getStyle[self] = style
    getKeyBinding[self]  = lwtk.DefaultKeyBinding()

    self.appName       = appName
    self.windows       = {}
    self.damageReports = nil

    getFontInfos[self]   = FontInfos(self.world:getDefaultBackend():getLayoutContext())

    createClosures(self)

    self:setAttributes(initParams)
end

function Application:close()
    self.world:close()
    isClosed[self] = true
end

function Application:getFontInfo(family, slant, weight, size)
    return getFontInfos[self]:getFontInfo(family, slant, weight, size)
end

function Application:getScreenScale()
    return self.world:getScreenScale()
end

function Application:getScreenScaleFunc()
    local f = self.screenScaleFunc
    if not f then
        local s = self.world:getScreenScale()
        f = function(arg, arg2, arg3, arg4)
            if type(arg) == "table" then
                arg[1] = arg[1] * s
                arg[2] = arg[2] * s
                arg[3] = arg[3] * s
                arg[4] = arg[4] * s
                return arg
            else
                return          s * arg, 
                       arg2 and s * arg2,
                       arg3 and s * arg3,
                       arg4 and s * arg4
            end
        end
        self.screenScaleFunc = f
    end
    return f
end

local function resetStyle2(p, style)
    for i = 1, #p do
        local c = p[i]
        if c._resetStyle then
            c:_resetStyle(style)
        end
        c.hasChanges = true
        c.needsRedraw = true
        resetStyle2(c, style)
    end
end

function Application:_resetStyle(style)
    local windows = self.windows
    for i = 1, #windows do
        local w = windows[i]
        w.hasChanges = true
        w.needsRelayout = true
        if w._resetStyle then
            w:_resetStyle(style)
        end
        resetStyle2(w, style)
    end
end

function Application:setStyle(style) 
    if getApp[style] then
        error("Style was alread added to app")
    end
    if lwtk.Object.is(style, lwtk.Style) then
        style:setScaleFactor(style.scaleFactor * self.world:getScreenScale())
    else
        style = lwtk.Style(style)
    end
    getApp[style]          = self
    getApp[getStyle[self]] = nil
    getStyle[self]         = style
    self:_resetStyle(style)
end

function Application:addStyle(styleRules) 
    getStyle[self]:addRules(styleRules)
    resetStyle(self)
end

function Application:newWindow(attributes)
    return Window(self, attributes)
end

function Application:_addWindow(win)
    self.windows[#self.windows + 1] = win
end

function Application:_removeWindow(win)
    for i = 1, #self.windows do
        if self.windows[i] == win then
            self.windows[i] = nil
        end
    end
end

local insert = table.insert
local remove = table.remove

local function unpack2(t, i, n)
    if i <= n then
        return t[i], unpack2(t, i + 1, n)
    end
end
local function unpack(t)
    return unpack2(t, 1, t.n)
end

createClosures = function(self)

    local world  = self.world
    local timers = {}
    
    function self:setTimer(seconds, func, ...)
        local n = #timers
        local timer
        if type(func) == "table" then
            timer = func
            if timer.time then
                for i = 1, n do
                    if timers[i] == timer then
                        remove(timers, i)
                        n = n - 1
                        break
                    end
                end
            end
        else
            assert(type(func) == "function", "Timer object or function expected")
            timer = Timer(func, ...)
        end
        local now  = world:getTime()
        local time = now + seconds
        timer.time = time
        for i = 1, n do
            if timers[i].time > time then
                insert(timers, i, timer)
                local t = timers[1].time - now
                t = (t >= 0) and t or 0
                world:setNextProcessTime(t)
                return timer
            end
        end
        timers[n + 1] = timer
        local t = timers[1].time - now
        t = (t >= 0) and t or 0
        world:setNextProcessTime(t)
        return timer
    end

    local animations     = lwtk.Animations(self)
    local animationTimer = animations.timer
    self._animations     = animations

    function self:getCurrentTime()
        return world:getTime() 
    end
    
    local function _processAllChanges()
        if self._hasChanges then
            self._hasChanges = false
            local windows = self.windows
            for _, w in ipairs(windows) do
                if w._hasChanges then
                    w._hasChanges = false
                    w:_processChanges()
                end
            end
            assert(not self._hasChanges)
        end
    end
    
    function self:runEventLoop(timeout)
        local endTime = timeout and (world:getTime() + timeout)
        if not animationTimer.time then
            _processAllChanges()
        end
        while world:hasViews() do
            world:update(endTime and world:getTime() - endTime)
            if not isClosed[self] and not animationTimer.time then
                _processAllChanges()
            end
            if endTime and world:getTime() >= endTime then
                break
            end
        end
    end
    
    function self:update(timeout)
        if not animationTimer.time then
            _processAllChanges()
        end
        return world:update(timeout)
    end
    
    world:setProcessFunc(function()
        local now = world:getTime()
        local closed = isClosed[self]
        while not closed do
            local timer = timers[1]
            if not timer or timer.time > now then
                break
            end
            remove(timers, 1)
            if timer == animationTimer then
                _processAllChanges()
            end
            timer.time = false
            timer.func(unpack(timer))
            closed = isClosed[self]
        end
        local timer = timers[1]
        if timer then
            local t = timer.time - now
            t = (t >= 0) and t or 0
            if not closed then
                world:setNextProcessTime(t)
            end
        end
        if not closed and not animationTimer.time then
            _processAllChanges()
        end
    end)
    
    function self._eventFunc(window, view, event, ...)
        --print(event, ...)
        if event == "CONFIGURE" then
            window:_handleConfigure(...)
        elseif event == "EXPOSE" then
            window:_handleExpose(...)
        elseif event == "MOTION" then
            window:_handleMouseMove(...)
        elseif event == "POINTER_OUT" then
            window:_handleMouseLeave(...)
        elseif event == "POINTER_IN" then
            window:_handleMouseEnter(...)
        elseif event == "KEY_PRESS" then
            window:_handleKeyDown(...)
        elseif event == "KEY_RELEASE" then
            window:_handleKeyUp(...)
        elseif event == "BUTTON_PRESS" then
            window:_handleMouseDown(...)
        elseif event == "BUTTON_RELEASE" then
            window:_handleMouseUp(...)
        elseif event == "FOCUS_IN" then
            window:_handleFocusIn(...)
        elseif event == "FOCUS_OUT" then
            window:_handleFocusOut(...)
        elseif event == "CLOSE" then
            window:_handleClose()
        end
        if not isClosed[self] and not animationTimer.time then
            _processAllChanges()
        end
    end
end



return Application
