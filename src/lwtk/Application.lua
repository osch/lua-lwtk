local lwtk = require"lwtk"

local insert      = table.insert
local remove      = table.remove

local Timer       = lwtk.Timer
local Window      = lwtk.Window
local FontInfos   = lwtk.FontInfos

local extract              = lwtk.extract
local getApp               = lwtk.get.app
local getStyle             = lwtk.get.style
local getKeyBinding        = lwtk.get.keyBinding
local getFontInfos         = lwtk.get.fontInfos
local getVisibilityChanges = lwtk.get.visibilityChanges
local getDeferredChanges   = lwtk.get.deferredChanges
local isInstanceOf         = lwtk.isInstanceOf

local isClosed = lwtk.WeakKeysTable("lwtk.Application.isClosed")

--[[
    Default application implementation.
    
    Use this for standalone desktop applications. Use lwtk.love.Application for
    running within the [LÖVE](https://love2d.org/) 2D game engine.
]]
local Application = lwtk.newClass("lwtk.Application")

Application:declare(
    "_animations",
    "_eventFunc",
    "_hasChanges",
    "animationTimer",
    "appName",
    "driver",
    "postprocessNeeded",
    "procssingDeferedChanges",
    "scale",
    "timers"
)    

local function unpack2(t, i, n)
    if i <= n then
        return t[i], unpack2(t, i + 1, n)
    end
end
local function unpack(t)
    return unpack2(t, 1, t.n)
end


function Application:new(arg1, arg2)
    local appName
    local initParams
    if type(arg1) == "string" then
        appName = arg1
        if isInstanceOf(arg2, lwtk.Style) then
            initParams =  { style = arg2 }
        else
            initParams = arg2 or {}
        end
    else
        initParams = arg1 or {}
        appName = extract(initParams, "name")
    end
    local driver = extract(initParams, "driver")
    if not driver then
        assert(appName, "Application object needs name attribute")
        driver = lwtk.lpugl.Driver{ appName = appName }
    end
    self.driver = driver
    isClosed[self] = false

    local timers = {}    
    self.timers = timers

    local style = initParams.style
    if style then
        initParams.style = nil
        if isInstanceOf(style, lwtk.Style) then
            style:setScaleFactor((style.scaleFactor or 1) * self.driver:getScreenScale())
        else
            style.scaleFactor = (style.scaleFactor or 1) * self.driver:getScreenScale()
            style = lwtk.Style(style)
        end
    else
        if not initParams.screenScale then
            initParams.screenScale = self.driver:getScreenScale()
        end
        style = lwtk.DefaultStyle(initParams)
    end
    
    getVisibilityChanges[self] = lwtk.WeakKeysTable("lwtk.Application.getVisibilityChanges")
    getDeferredChanges[self]   = {}

    if getApp[style] then
        error("Style was alread added to app")
    end
    getApp[style]  = self
    getStyle[self] = style
    getKeyBinding[self]  = lwtk.DefaultKeyBinding()
    do
        local s = self.driver:getScreenScale()
        self.scale = function(a, a2, a3, a4)
            if type(a) == "table" then
                a[1] = a[1] * s
                a[2] = a[2] * s
                if #a > 2 then
                    a[3] = a[3] * s
                    a[4] = a[4] * s
                end
                return a
            else
                return        s * a, 
                       a2 and s * a2,
                       a3 and s * a3,
                       a4 and s * a4
            end
        end
    end
    self.appName           = appName
    self.postprocessNeeded = {}
    self._animations       = lwtk.Animations(self)
    local animationTimer   = self._animations.timer
    self.animationTimer    = animationTimer    
    
    getFontInfos[self]     = FontInfos(self.driver:getLayoutContext())

    self:setAttributes(initParams)

    driver:setProcessFunc(function()
        local now = driver:getTime()
        local closed = isClosed[self]
        while not closed do
            local timer = timers[1]
            if not timer or timer.time > now then
                break
            end
            remove(timers, 1)
            if timer == animationTimer then
                self:_processAllChanges()
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
                driver:setNextProcessTime(t)
            end
        end
        if not closed and not animationTimer.time then
            self:_processAllChanges()
        end
    end)


    self._eventFunc = function(window, view, event, ...)
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
        elseif event == "SCROLL" then
            window:_handleMouseScroll(...)
        elseif event == "CLOSE" then
            window:requestClose()
        elseif event == "MAP" then
            window:_handleMap(...)
        elseif event == "CREATE" then
            return
        end
        if not isClosed[self] and not animationTimer.time then
            self:_processAllChanges()
        end
    end
end

function Application:close()
    self.driver:close()
    isClosed[self] = true
end

function Application:setErrorFunc(...)
    return self.driver:setErrorFunc(...)
end

function Application:setExtensions(extensions)
    self.extensions = extensions
end

function Application:getLayoutContext()
    return self.driver:getLayoutContext()
end

function Application:getFontInfo(family, slant, weight, size)
    return getFontInfos[self]:getFontInfo(family, slant, weight, size)
end

function Application:getScreenScale()
    return self.driver:getScreenScale()
end

local function resetStyle(self, style)
    for i = 1, #self do
        local w = self[i]
        w:_setStyleFromParent(style)
    end
end

function Application:setStyle(style) 
    if getApp[style] then
        error("Style was alread added to app")
    end
    if isInstanceOf(style, lwtk.Style) then
        style:setScaleFactor(style.scaleFactor * self.driver:getScreenScale())
    else
        style = lwtk.Style(style)
    end
    getApp[style]          = self
    getApp[getStyle[self]] = nil
    getStyle[self]         = style
    resetStyle(self, style)
end

function Application:addStyle(additionalStyle) 
    local style = getStyle[self]
    style:addRules(additionalStyle)
    resetStyle(self, style)
end

function Application:newWindow(attributes)
    return Window(self, attributes)
end

function Application:hasWindows()
    if not isClosed[self] then
        if #self > 0 then
            return true
        end
        local hasViews = self.driver.hasViews
        return hasViews and hasViews(self.driver)
    else
        return false
    end
end

function Application:_addWindow(win)
    rawset(self, #self + 1, win)
end

function Application:_removeWindow(win)
    for i = #self, 1, -1 do
        if self[i] == win then
            table.remove(self, i)
        end
    end
end

function Application:setTimer(seconds, func, ...)
    local driver          = self.driver
    local timers          = self.timers

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
    local now  = driver:getTime()
    local time = now + seconds
    timer.time = time
    for i = 1, n do
        if timers[i].time > time then
            insert(timers, i, timer)
            local t = timers[1].time - now
            t = (t >= 0) and t or 0
            driver:setNextProcessTime(t)
            return timer
        end
    end
    timers[n + 1] = timer
    local t = timers[1].time - now
    t = (t >= 0) and t or 0
    driver:setNextProcessTime(t)
    return timer
end

function Application:getCurrentTime()
    return self.driver:getTime() 
end

function Application:deferChanges(callback)
    assert(not self.procssingDeferedChanges)
    local deferredChanges = getDeferredChanges[self]
    deferredChanges[#deferredChanges + 1] = callback
    self._hasChanges = true
end

function Application:_processAllChanges()
    local postprocessNeeded = self.postprocessNeeded
    if self._hasChanges then
        local visibilityChanges = getVisibilityChanges[self]
        for widget, hidden in pairs(visibilityChanges) do
            widget:onEffectiveVisibilityChanged(hidden)
            visibilityChanges[widget] = nil
        end
        self.procssingDeferedChanges = true
        local deferredChanges = getDeferredChanges[self]
        for i = 1, #deferredChanges do 
            deferredChanges[i]()
            deferredChanges[i] = nil
        end
        self.procssingDeferedChanges = false
        self._hasChanges = false
        for i = 1, #self do
            local w = self[i]
            if w._hasChanges then
                if w:_processChanges() then
                    postprocessNeeded[#postprocessNeeded + 1] = w
                end
                assert(not w._hasChanges)
            end
        end
        assert(not self._hasChanges)
    end
    for i = 1, #postprocessNeeded do
        postprocessNeeded[i]:_postProcessChanges()
        postprocessNeeded[i] = nil
    end
end

--[[
    Update by processing events from the window system.

    * *timeout*  - optional float, timeout in seconds  
  
    If *timeout* is given, this function will process events from the window system until
    the time period in seconds has elapsed or until all window objects have been closed.
  
    If *timeout* is `nil` or not given, this function will process events from the window system
    until all window objects have been closed.
]]
function Application:runEventLoop(timeout)
    local driver = self.driver
    if driver.handleNextEvents then
        local endTime = timeout and (driver:getTime() + timeout)
        if not self.animationTimer.time then
            self:_processAllChanges()
        end
        while self:hasWindows() do
            driver:handleNextEvents(endTime and driver:getTime() - endTime)
            if not isClosed[self] and not self.animationTimer.time then
                self:_processAllChanges()
            end
            if endTime and driver:getTime() >= endTime then
                break
            end
        end
    else
        error("method 'runEventLoop' not supported")
    end
end

--[[
    Update by processing events from the window system.
  
    * *timeout*  - optional float, timeout in seconds  
  
    If *timeout* is given, this function will wait for *timeout* seconds until
    events from the window system become available. If *timeout* is `nil` or not
    given, this function will block indefinitely until an event occurs.
  
    As soon as events are available, all events in the queue are processed and this function 
    returns `true`.
    
    If *timeout* is given and there are no events available after *timeout*
    seconds, this function will return `false`.
]]
function Application:update(timeout)
    local driver = self.driver
    if driver.handleNextEvents then
        if not self.animationTimer.time then
            self:_processAllChanges()
        end
        return driver:handleNextEvents(timeout)
    end
end




return Application
