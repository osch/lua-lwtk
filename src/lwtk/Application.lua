local lwtk = require"lwtk"

local Timer       = lwtk.Timer
local Window      = lwtk.Window
local FontInfos   = lwtk.FontInfos
local Application = lwtk.newClass("lwtk.Application")

local extract              = lwtk.extract
local getApp               = lwtk.get.app
local getStyle             = lwtk.get.style
local getKeyBinding        = lwtk.get.keyBinding
local getFontInfos         = lwtk.get.fontInfos
local getVisibilityChanges = lwtk.get.visibilityChanges
local getDeferredChanges   = lwtk.get.deferredChanges
local isInstanceOf         = lwtk.isInstanceOf

local isClosed        = setmetatable({}, { __mode = "k" })
local createClosures

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
    self.driver = extract(initParams, "driver")
    if not self.driver then
        assert(appName, "Application object needs name attribute")
        self.driver = lwtk.lpugl.Driver{ appName = appName }
    end
    isClosed[self] = false
    
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
    
    getVisibilityChanges[self] = lwtk.WeakKeysTable()
    getDeferredChanges[self]   = lwtk.WeakKeysTable()

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
    self.appName       = appName
    self.damageReports = nil

    getFontInfos[self]   = FontInfos(self.driver:getLayoutContext())

    createClosures(self)

    self:setAttributes(initParams)
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
    self[#self + 1] = win
end

function Application:_removeWindow(win)
    for i = 1, #self do
        if self[i] == win then
            table.remove(self, i)
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

createClosures = function(app)

    local driver          = app.driver
    local deferredChanges = getDeferredChanges[app]
    local timers          = {}
    
    function app:setTimer(seconds, func, ...)
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

    local animations     = lwtk.Animations(app)
    local animationTimer = animations.timer
    app._animations      = animations

    function app:getCurrentTime()
        return driver:getTime() 
    end
    
    local procssingDeferedChanges = false
    local postprocessNeeded = {}
    
    function app:deferChanges(callback)
        assert(not procssingDeferedChanges)
        deferredChanges[#deferredChanges + 1] = callback
        app._hasChanges = true
    end
    
    local function _processAllChanges(self)
        if app._hasChanges then
            local visibilityChanges = getVisibilityChanges[app]
            for widget, hidden in pairs(visibilityChanges) do
                widget:onEffectiveVisibilityChanged(hidden)
                visibilityChanges[widget] = nil
            end
            procssingDeferedChanges = true
            for i = 1, #deferredChanges do 
                deferredChanges[i]:call()
                deferredChanges[i] = nil
            end
            procssingDeferedChanges = false
            app._hasChanges = false
            for _, w in ipairs(app) do
                if w._hasChanges then
                    if w:_processChanges() then
                        postprocessNeeded[#postprocessNeeded + 1] = w
                    end
                    assert(not w._hasChanges)
                end
            end
            assert(not app._hasChanges)
        end
        for i = 1, #postprocessNeeded do
            postprocessNeeded[i]:_postProcessChanges()
            postprocessNeeded[i] = nil
        end
    end
    app._processAllChanges = _processAllChanges
    
    if driver.handleNextEvents then
        function app:runEventLoop(timeout)
            local endTime = timeout and (driver:getTime() + timeout)
            if not animationTimer.time then
                _processAllChanges()
            end
            while app:hasWindows() do
                driver:handleNextEvents(endTime and driver:getTime() - endTime)
                if not isClosed[app] and not animationTimer.time then
                    _processAllChanges()
                end
                if endTime and driver:getTime() >= endTime then
                    break
                end
            end
        end
    else
        function app:runEventLoop(timeout)
            error("method 'runEventLoop' not supported")
        end
    end
    
    if driver.handleNextEvents then
        function app:update(timeout)
            if not animationTimer.time then
                _processAllChanges()
            end
            return driver:handleNextEvents(timeout)
        end
    end
    
    driver:setProcessFunc(function()
        local now = driver:getTime()
        local closed = isClosed[app]
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
            closed = isClosed[app]
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
            _processAllChanges()
        end
    end)
    
    function app._eventFunc(window, view, event, ...)
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
            window:_handleClose()
        elseif event == "MAP" then
            window:_handleMap(...)
        elseif event == "CREATE" then
            return
        end
        if not isClosed[app] and not animationTimer.time then
            _processAllChanges()
        end
    end
end



return Application
